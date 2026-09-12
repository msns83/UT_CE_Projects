import math
import random
from typing import Sequence
from dataclasses import dataclass

def average_path_adjustment(size: int) -> float:
    if size <= 1:
        return 0.0
    if size == 2:
        return 1.0
    harmonic_approximation = math.log(size - 1) + 0.5772156649
    return 2.0 * harmonic_approximation - (2.0 * (size - 1) / size)

@dataclass
class IsolationNode:
    size: int
    feature: int | None = None
    split: float | None = None
    left: "IsolationNode | None" = None
    right: "IsolationNode | None" = None

    @property
    def is_leaf(self) -> bool:
        return self.feature is None

class SimpleIsolationForest:
    def __init__(
        self,
        n_trees: int = 100,
        max_samples: int = 64,
        contamination: float = 0.02,
    ) -> None:

        self.n_trees = n_trees
        self.max_samples = max_samples
        self.contamination = contamination
        self.rng = random.Random(42)
        self.trees: list[IsolationNode] = []
        self.sample_size = 0
        self.max_depth = 0
        self.threshold = 0.0

    def fit(
        self,
        rows: Sequence[Sequence[float]]
    ) -> None:
        
        self.sample_size = min(self.max_samples, len(rows))
        self.max_depth = math.ceil(math.log2(self.sample_size))
        self.trees = []

        for _ in range(self.n_trees):
            sample = self.rng.sample(list(rows), self.sample_size)
            self.trees.append(self._build_tree(sample, depth=0))

        training_scores = sorted(self.score(row) for row in rows)
        position = math.ceil((1.0 - self.contamination) * len(training_scores)) - 1
        position = max(0, min(position, len(training_scores) - 1))
        self.threshold = training_scores[position]

    def _build_tree(
        self,
        rows: Sequence[Sequence[float]],
        depth: int,
    ) -> IsolationNode:
        
        if depth >= self.max_depth or len(rows) <= 1:
            return IsolationNode(size=len(rows))

        usable_features = []
        for feature in range(len(rows[0])):
            values = [row[feature] for row in rows]
            if min(values) < max(values):
                usable_features.append(feature)

        if not usable_features:
            return IsolationNode(size=len(rows))

        feature = self.rng.choice(usable_features)
        values = [row[feature] for row in rows]
        split = self.rng.uniform(min(values), max(values))
        left_rows = [row for row in rows if row[feature] < split]
        right_rows = [row for row in rows if row[feature] >= split]

        if not left_rows or not right_rows:
            return IsolationNode(size=len(rows))

        return IsolationNode(
            size=len(rows),
            feature=feature,
            split=split,
            left=self._build_tree(left_rows, depth + 1),
            right=self._build_tree(right_rows, depth + 1),
        )

    def _path_length(
        self,
        row: Sequence[float],
        node: IsolationNode,
        depth: int,
    ) -> float:
        if node.is_leaf:
            return depth + average_path_adjustment(node.size)

        assert node.feature is not None
        assert node.split is not None
        assert node.left is not None
        assert node.right is not None

        next_node = node.left if row[node.feature] < node.split else node.right
        return self._path_length(row, next_node, depth + 1)

    def score(self, row: Sequence[float]) -> float:
        if not self.trees:
            raise RuntimeError("The Isolation Forest has not been trained")

        mean_path = sum(
            self._path_length(row, tree, depth=0) for tree in self.trees
        ) / len(self.trees)
        normalizer = average_path_adjustment(self.sample_size)
        return 2.0 ** (-mean_path / normalizer) if normalizer else 1.0

    def is_anomaly(self, row: Sequence[float]) -> tuple[bool, float]:
        score = self.score(row)
        return score >= self.threshold, score