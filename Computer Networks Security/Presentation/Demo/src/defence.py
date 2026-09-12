from typing import Iterable

from data import extract_features
from model import SimpleIsolationForest
from config import TRUSTED_PRIMARY_DOMAINS
from result import DetectionResult

def primary_domain(query_name: str) -> str:
    labels = query_name.rstrip(".").split(".")
    return ".".join(labels[-2:]) if len(labels) >= 2 else query_name

class DNSDefense:
    def __init__(
        self,
        n_trees: int = 100,
        max_samples: int = 64,
        contamination: float = 0.02,
    ) -> None:
        
        self.model = SimpleIsolationForest(
            n_trees=n_trees,
            max_samples=max_samples,
            contamination=contamination,
        )

    def train(self, benign_queries: Iterable[str]) -> None:
        rows = [extract_features(query) for query in benign_queries]
        self.model.fit(rows)

    def inspect(self, query: str, expected: str = "unknown") -> DetectionResult:
        domain = primary_domain(query)
        if domain in TRUSTED_PRIMARY_DOMAINS:
            return DetectionResult(
                expected=expected,
                verdict="NORMAL",
                score=0.0,
                reason="trusted-domain whitelist",
                query=query,
            )

        anomaly, score = self.model.is_anomaly(extract_features(query))
        return DetectionResult(
            expected=expected,
            verdict="ANOMALOUS" if anomaly else "NORMAL",
            score=score,
            reason="Isolation Forest",
            query=query,
        )