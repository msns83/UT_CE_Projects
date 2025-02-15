import sys
from collections import defaultdict

input = sys.stdin.readline

def find(x):
    if parent[x] != x:
        parent[x] = find(parent[x])
    return parent[x]

def union(x, y):
    xr = find(x)
    yr = find(y)
    if xr == yr:
        return False
    if rank[xr] < rank[yr]:
        parent[xr] = yr
    else:
        parent[yr] = xr
        if rank[xr] == rank[yr]:
            rank[xr] += 1
    return True

def main():
    n, m = map(int, input().split())
    edges = []

    for index in range(m):
        a, b, w = map(int, input().split())
        edges.append((w, a, b, index))
    
    edges.sort()

    global parent, rank
    parent = list(range(n+1))
    rank = [0]*(n+1)

    ans = ["none"]*m

    i = 0
    while i < m:

        j = i
        same_w = []

        while j < m and edges[j][0] == edges[i][0]:
            same_w.append(edges[j])
            j += 1

        groups = defaultdict(list)

        for w, a, b, index in same_w:
            ra = find(a)
            rb = find(b)
            if ra != rb:
                groups[(ra, rb)].append(index)

        for _, indexes in groups.items():
            if len(indexes) == 1:
                ans[indexes[0]] = "any"
            else:
                for index in indexes:
                    ans[index] = "at least one"

        for w, a, b, index in same_w:
            union(a, b)

        i = j

    for answer in ans:
        print(answer)

main()