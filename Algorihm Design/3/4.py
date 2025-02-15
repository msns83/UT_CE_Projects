import sys
import threading

def main():
    sys.setrecursionlimit(1 << 25)
    input = sys.stdin.readline
    n = int(input())
    h = list(map(int, input().split()))
    tree = [[] for _ in range(n)]
    for _ in range(n - 1):
        u, v = map(int, input().split())
        u -= 1
        v -= 1
        tree[u].append(v)
        tree[v].append(u)

    total = [0]
    root = 0  # Assuming node 0 as root

    def dfs(u, p):
        max1 = max2 = 0
        children = 0
        for v in tree[u]:
            if v != p:
                children += 1
                e_v = dfs(v, u)
                if e_v > max1:
                    max2 = max1
                    max1 = e_v
                elif e_v > max2:
                    max2 = e_v
        if children >= 2:
            needed = max(0, h[u] - min(max1, max2))
        elif children == 1:
            needed = max(0, h[u] - max1)
        else:
            needed = h[u]
        total[0] += needed
        return max(h[u], max1)

    dfs(root, -1)
    print(total[0])

threading.Thread(target=main).start()