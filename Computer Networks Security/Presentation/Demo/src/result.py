import csv
from pathlib import Path
from typing import Sequence
from dataclasses import dataclass

from data import extract_features, FEATURE_NAMES

@dataclass
class DetectionResult:
    expected: str
    verdict: str
    score: float
    reason: str
    query: str

def shorten(text: str, width: int = 76) -> str:
    return text if len(text) <= width else text[: width - 3] + "..."

def print_results(results: Sequence[DetectionResult], show_all: bool) -> None:
    visible = list(results if show_all else results[:12])
    print("\nDetection results")
    print("-" * 112)
    print(f"{'EXPECTED':<10} {'VERDICT':<11} {'SCORE':>7}  {'REASON':<24} QUERY")
    print("-" * 112)
    for result in visible:
        print(
            f"{result.expected:<10} {result.verdict:<11} {result.score:>7.3f}  "
            f"{result.reason:<24} {shorten(result.query)}"
        )
    if len(visible) < len(results):
        print(f"... {len(results) - len(visible)} more rows hidden; use --show-all")

def print_feature_comparison(benign_query: str, tunnel_query: str) -> None:
    benign_features = extract_features(benign_query)
    tunnel_features = extract_features(tunnel_query)

    print("\nWhy the attack looks unusual")
    print("-" * 70)
    print(f"{'FEATURE':<25} {'NORMAL QUERY':>18} {'TUNNEL QUERY':>18}")
    print("-" * 70)
    for name, benign, tunnel in zip(
        FEATURE_NAMES, benign_features, tunnel_features
    ):
        print(f"{name:<25} {benign:>18.2f} {tunnel:>18.2f}")

def save_results(path: Path, results: Sequence[DetectionResult]) -> None:
    with path.open("w", newline="", encoding="utf-8") as output:
        writer = csv.writer(output)
        writer.writerow(("expected", "verdict", "score", "reason", "query"))
        for result in results:
            writer.writerow(
                (
                    result.expected,
                    result.verdict,
                    f"{result.score:.6f}",
                    result.reason,
                    result.query,
                )
            )

def print_metrics(results: Sequence[DetectionResult]) -> None:
    attacks = [result for result in results if result.expected == "attack"]
    benign = [result for result in results if result.expected == "benign"]

    detected_attacks = sum(result.verdict == "ANOMALOUS" for result in attacks)
    false_alarms = sum(result.verdict == "ANOMALOUS" for result in benign)

    attack_rate = 100.0 * detected_attacks / len(attacks) if attacks else 0.0
    false_rate = 100.0 * false_alarms / len(benign) if benign else 0.0

    print("\nPrototype summary")
    print(f"  Attack queries detected: {detected_attacks}/{len(attacks)} "
          f"({attack_rate:.1f}%)")
    print(f"  Benign false alarms:     {false_alarms}/{len(benign)} "
          f"({false_rate:.1f}%)")
