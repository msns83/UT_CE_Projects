import math
import random
import struct
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

FEATURE_NAMES = (
    "FQDN length",
    "Subdomain length",
    "Uppercase characters",
    "Numerical characters",
    "Entropy",
    "Number of labels",
    "Maximum label length",
    "Average label length",
)


@dataclass(frozen=True)
class BenignDataset:
    training_queries: list[str]
    test_queries: list[str]
    source: str
    data_dir: Path
    text_files: int
    pcap_files: int
    text_queries: int
    pcap_queries: int
    unique_queries: int


def extract_features(
    query_name: str
) -> list[float]:
    fqdn = query_name.rstrip(".")
    labels = [label for label in fqdn.split(".") if label]
    text_without_dots = "".join(labels)

    subdomain_labels = labels[:-2] if len(labels) > 2 else []
    subdomain_text = "".join(subdomain_labels)
    label_lengths = [len(label) for label in labels] or [0]

    return [
        float(len(fqdn)),
        float(len(subdomain_text)),
        float(sum(character.isupper() for character in fqdn)),
        float(sum(character.isdigit() for character in fqdn)),
        shannon_entropy(text_without_dots),
        float(len(labels)),
        float(max(label_lengths)),
        sum(label_lengths) / len(label_lengths),
    ]


def shannon_entropy(
    text: str
) -> float:
    if not text:
        return 0.0

    counts = {}
    for character in text:
        counts[character] = counts.get(character, 0) + 1

    length = len(text)
    return -sum(((count / length) * math.log2(count / length)) for count in counts.values())


def normalize_query_name(value: str) -> str | None:
    """Clean one domain/query name from a text file or packet capture."""
    value = value.strip()
    if not value or value.startswith("#"):
        return None

    value = value.split()[0]
    value = value.removeprefix("http://").removeprefix("https://")
    value = value.split("/", 1)[0]
    value = value.strip(".").lower()

    try:
        value = value.encode("idna").decode("ascii")
    except UnicodeError:
        return None

    labels = [label for label in value.split(".") if label]
    if len(labels) < 2:
        return None
    if len(value) > 253:
        return None
    if any(len(label) > 63 for label in labels):
        return None

    allowed = set("abcdefghijklmnopqrstuvwxyz0123456789-_.")
    if any(character not in allowed for character in value):
        return None

    return ".".join(labels)


def unique_preserving_order(values: Iterable[str]) -> list[str]:
    seen = set()
    output = []
    for value in values:
        if value not in seen:
            seen.add(value)
            output.append(value)
    return output


def load_text_domain_queries(paths: Iterable[Path]) -> list[str]:
    queries: list[str] = []
    for path in paths:
        with path.open("r", encoding="utf-8", errors="ignore") as input_file:
            for line in input_file:
                query = normalize_query_name(line)
                if query:
                    queries.append(query)
    return unique_preserving_order(queries)


def load_pcap_dns_queries(paths: Iterable[Path], limit_per_file: int | None = 5000) -> list[str]:
    """Extract DNS question names from classic pcap files using only stdlib."""
    queries: list[str] = []
    for path in paths:
        file_queries = 0
        for packet in iter_pcap_packets(path):
            for query in extract_dns_queries_from_packet(packet):
                normalized = normalize_query_name(query)
                if normalized:
                    queries.append(normalized)
                    file_queries += 1
                    if limit_per_file is not None and file_queries >= limit_per_file:
                        break
            if limit_per_file is not None and file_queries >= limit_per_file:
                break
    return unique_preserving_order(queries)


def iter_pcap_packets(path: Path) -> Iterable[bytes]:
    with path.open("rb") as input_file:
        header = input_file.read(24)
        if len(header) < 24:
            return

        magic = header[:4]
        if magic in (b"\xd4\xc3\xb2\xa1", b"\x4d\x3c\xb2\xa1"):
            endian = "<"
        elif magic in (b"\xa1\xb2\xc3\xd4", b"\xa1\xb2\x3c\x4d"):
            endian = ">"
        else:
            return

        while True:
            packet_header = input_file.read(16)
            if len(packet_header) < 16:
                return

            _, _, included_length, _ = struct.unpack(endian + "IIII", packet_header)
            packet = input_file.read(included_length)
            if len(packet) < included_length:
                return
            yield packet


def extract_dns_queries_from_packet(packet: bytes) -> list[str]:
    payload = extract_udp_dns_payload(packet)
    if payload is None:
        return []
    return extract_dns_question_names(payload)


def extract_udp_dns_payload(packet: bytes) -> bytes | None:
    if len(packet) < 14:
        return None

    eth_type = int.from_bytes(packet[12:14], "big")
    offset = 14
    while eth_type in (0x8100, 0x88A8, 0x9100):
        if len(packet) < offset + 4:
            return None
        eth_type = int.from_bytes(packet[offset + 2:offset + 4], "big")
        offset += 4

    if eth_type == 0x0800:
        return extract_ipv4_udp_dns_payload(packet, offset)
    if eth_type == 0x86DD:
        return extract_ipv6_udp_dns_payload(packet, offset)
    return None


def extract_ipv4_udp_dns_payload(packet: bytes, offset: int) -> bytes | None:
    if len(packet) < offset + 20:
        return None

    version_and_ihl = packet[offset]
    version = version_and_ihl >> 4
    header_length = (version_and_ihl & 0x0F) * 4
    if version != 4 or header_length < 20:
        return None

    protocol = packet[offset + 9]
    if protocol != 17:
        return None

    udp_offset = offset + header_length
    return extract_udp_payload(packet, udp_offset)


def extract_ipv6_udp_dns_payload(packet: bytes, offset: int) -> bytes | None:
    if len(packet) < offset + 40:
        return None

    version = packet[offset] >> 4
    next_header = packet[offset + 6]
    if version != 6 or next_header != 17:
        return None

    udp_offset = offset + 40
    return extract_udp_payload(packet, udp_offset)


def extract_udp_payload(packet: bytes, udp_offset: int) -> bytes | None:
    if len(packet) < udp_offset + 8:
        return None

    source_port, destination_port, udp_length, _ = struct.unpack(
        "!HHHH",
        packet[udp_offset:udp_offset + 8],
    )
    if source_port != 53 and destination_port != 53:
        return None

    payload_length = max(0, udp_length - 8)
    payload_start = udp_offset + 8
    payload_end = min(len(packet), payload_start + payload_length)
    return packet[payload_start:payload_end]


def extract_dns_question_names(payload: bytes) -> list[str]:
    if len(payload) < 12:
        return []

    flags = int.from_bytes(payload[2:4], "big")
    is_response = bool(flags & 0x8000)
    if is_response:
        return []

    question_count = int.from_bytes(payload[4:6], "big")
    offset = 12
    names = []

    for _ in range(question_count):
        name, offset = read_dns_name(payload, offset)
        if not name:
            break
        names.append(name)
        offset += 4
        if offset > len(payload):
            break

    return names


def read_dns_name(payload: bytes, offset: int) -> tuple[str | None, int]:
    labels = []
    jumped = False
    next_offset = offset
    visited_offsets = set()

    while True:
        if offset >= len(payload) or offset in visited_offsets:
            return None, next_offset
        visited_offsets.add(offset)

        length = payload[offset]
        if length == 0:
            offset += 1
            if not jumped:
                next_offset = offset
            return ".".join(labels), next_offset

        if length & 0xC0 == 0xC0:
            if offset + 1 >= len(payload):
                return None, next_offset
            pointer = ((length & 0x3F) << 8) | payload[offset + 1]
            if not jumped:
                next_offset = offset + 2
            offset = pointer
            jumped = True
            continue

        if length & 0xC0:
            return None, next_offset

        start = offset + 1
        end = start + length
        if end > len(payload):
            return None, next_offset

        label = payload[start:end].decode("ascii", errors="ignore")
        labels.append(label)
        offset = end
        if not jumped:
            next_offset = offset


def load_benign_dataset(
    data_dir: Path,
    source: str = "auto",
    train_count: int = 800,
    test_count: int = 80,
    seed: int = 100,
    pcap_limit: int | None = 5000,
) -> BenignDataset:
    data_dir = data_dir.resolve()
    text_paths = sorted(data_dir.glob("domains_*.txt"))
    pcap_paths = sorted(data_dir.glob("*.pcap"))

    use_text = source in {"auto", "text", "both"}
    use_pcap = source in {"auto", "pcap", "both"}

    text_queries = load_text_domain_queries(text_paths) if use_text else []
    pcap_queries = load_pcap_dns_queries(pcap_paths, pcap_limit) if use_pcap else []
    all_queries = unique_preserving_order([*text_queries, *pcap_queries])

    needed = train_count + test_count
    if len(all_queries) < needed:
        raise ValueError(
            f"Not enough benign queries in {data_dir}. "
            f"Need {needed}, found {len(all_queries)}."
        )

    shuffled = list(all_queries)
    random.Random(seed).shuffle(shuffled)

    return BenignDataset(
        training_queries=shuffled[:train_count],
        test_queries=shuffled[train_count:needed],
        source=source,
        data_dir=data_dir,
        text_files=len(text_paths) if use_text else 0,
        pcap_files=len(pcap_paths) if use_pcap else 0,
        text_queries=len(text_queries),
        pcap_queries=len(pcap_queries),
        unique_queries=len(all_queries),
    )
