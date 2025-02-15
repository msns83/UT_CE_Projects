import sys
input = sys.stdin.readline

def find(x):
        if parent[x] != x:
            parent[x] = find(parent[x])
        return parent[x]

def union(x, y):
        rx, ry = find(x), find(y)
        if rx == ry:
            return False
        if rank[rx] < rank[ry]:
            parent[rx] = ry
        elif rank[rx] > rank[ry]:
            parent[ry] = rx
        else:
            parent[ry] = rx
            rank[rx] += 1
        return True


def kruskal(n, edges):
    mst_cost = 0
    used = 0

    for w,u,v,_ in edges:
        if union(u,v):
            mst_cost += w
            used += 1
            if used == n-1:
                break

    return mst_cost

def main():

    n,m = map(int, input().split())
    edges = []
    for i in range(m):
        u,v,w = map(int, input().split())
        u -= 1
        v -= 1
        edges.append((w,u,v,i+1))

    edges.sort(key=lambda x: x[0])

    global parent, rank
    parent = list(range(n))
    rank = [0]*n

    mst_cost = kruskal(n, edges)

    reordered_edges = {}
    for (w,u,v,i) in edges:
        reordered_edges[i] = (u,v,w)

    q = int(input())

    ans = []
    for _ in range(q):
        request = list(map(int, input().split()))
        necesary_indexes = request[1:]

        parent = list(range(n))
        rank = [0]*n
        cost = 0
        used = 0

        possible = True
        necesary_edges = []

        for necesary_index in necesary_indexes:
            u,v,w = reordered_edges[necesary_index]
            if not union(u,v):
                possible = False
                break
            cost += w
            used += 1
            necesary_edges.append((w,u,v,necesary_index))

        if not possible:
            ans.append("NO")
            continue

        for (w,u,v,i) in edges:
            if used == n-1:
                break
            if i in necesary_indexes:
                continue
            if union(u,v):
                cost += w
                used += 1

        if used == n-1 and cost == mst_cost:
            ans.append("YES")
        else:
            ans.append("NO")

    for answer in ans:
        print(answer)

main()