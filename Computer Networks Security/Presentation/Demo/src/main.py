from __future__ import annotations

import argparse
from pathlib import Path

from attack import decode_queries, encode_message_as_queries
from data import load_benign_dataset
from result import (
    print_feature_comparison,
    print_metrics,
    print_results,
    save_results,
)
from defence import DNSDefense


PROJECT_ROOT = Path(__file__).resolve().parents[1]

def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="DNS tunneling attack and defense demonstration."
    )

    parser.add_argument(
        "--message",
        default=(
            "CLASSROOM DEMO ONLY | project=network-security | "
            "sample-record=alice,42,prototype | "
        ) * 5,
        help="Harmless text to encode into simulated DNS query names.",
    )

    parser.add_argument(
        "--show-all",
        action="store_true",
        help="Print every test query instead of only the first twelve.",
    )

    parser.add_argument(
        "--paper-settings",
        action="store_true",
        help="Use the paper-like values: 2 trees and 18 maximum samples.",
    )

    parser.add_argument(
        "--save-csv",
        type=Path,
        help="Optional path for saving all detection results as CSV.",
    )

    parser.add_argument(
        "--data-dir",
        type=Path,
        default=PROJECT_ROOT / "data",
        help="Directory containing benign domains_*.txt and/or *.pcap files.",
    )

    parser.add_argument(
        "--benign-source",
        choices=("auto", "text", "pcap", "both"),
        default="auto",
        help="Where benign training/test queries should be loaded from.",
    )

    parser.add_argument(
        "--train-count",
        type=int,
        default=800,
        help="Number of benign dataset queries used for training.",
    )

    parser.add_argument(
        "--test-count",
        type=int,
        default=80,
        help="Number of benign dataset queries used for false-alarm testing.",
    )

    parser.add_argument(
        "--pcap-limit",
        type=int,
        default=5000,
        help="Maximum DNS queries to extract from each PCAP file. Use 0 for no limit.",
    )

    return parser

def attack_sim(
        message: str
) -> list[str]:
    print("DNS EXFILTRATION AND DETECTION")
    print("=" * 30)

    attack_queries = encode_message_as_queries(message)
    restored_message = decode_queries(attack_queries)

    print("\n1) Simulated attack")
    print(f"  Original message size: {len(message.encode('utf-8'))} bytes")
    print(f"  Generated DNS-looking queries: {len(attack_queries)}")
    print(f"  First query: {attack_queries[0]}")
    print(f"  Receiver rebuilt message correctly: {restored_message == message}")

    return attack_queries

def defence_sim(
   args,
   attack_queries    
):
    pcap_limit = None if args.pcap_limit == 0 else args.pcap_limit
    benign_dataset = load_benign_dataset(
        data_dir=args.data_dir,
        source=args.benign_source,
        train_count=args.train_count,
        test_count=args.test_count,
        pcap_limit=pcap_limit,
    )
    training_queries = benign_dataset.training_queries
    benign_test_queries = benign_dataset.test_queries

    trees = 2 if args.paper_settings else 100
    max_samples = 18 if args.paper_settings else 64

    defense = DNSDefense(
        n_trees=trees,
        max_samples=max_samples,
        contamination=0.02,
    )

    defense.train(training_queries)
    threshold_source = "learned from benign training data"
    
    if args.paper_settings:
        defense.model.threshold = 0.54
        threshold_source = "fixed paper-reported value"

    print("\n2) Simulated defense")
    print(f"  Benign source: {benign_dataset.source}")
    print(f"  Data directory: {benign_dataset.data_dir}")
    print(
        "  Loaded benign names: "
        f"{benign_dataset.unique_queries} unique "
        f"({benign_dataset.text_queries} from text, "
        f"{benign_dataset.pcap_queries} from PCAP)"
    )
    print(f"  Benign training queries: {len(training_queries)}")
    print(f"  Benign test queries: {len(benign_test_queries)}")
    print(f"  Isolation trees: {trees}")
    print(f"  Maximum samples per tree: {max_samples}")
    print(
        f"  Anomaly threshold: {defense.model.threshold:.3f} "
        f"({threshold_source})"
    )

    results = [
        defense.inspect(query, expected="benign")
        for query in benign_test_queries
    ]

    results.extend(
        defense.inspect(query, expected="attack")
        for query in attack_queries
    )

    print_results(results, show_all=args.show_all)
    print_feature_comparison(benign_test_queries[0], attack_queries[0])
    print_metrics(results)

    return results


def main() -> None:
    args = build_parser().parse_args()

    attack_queries = attack_sim(args.message)
    results = defence_sim(args, attack_queries)

    if args.save_csv:
        save_results(args.save_csv, results)
        print(f"\nSaved results to: {args.save_csv}")

if __name__ == "__main__":
    main()
