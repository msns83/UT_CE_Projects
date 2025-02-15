def dfs(adj):
    n = len(adj) - 1
    unvisited = set(range(2, n + 1))
    stack = [1]

    while stack:
        node = stack.pop()
        comp_neighbors = unvisited - adj[node]
        unvisited -= comp_neighbors
        stack.extend(comp_neighbors)

    return unvisited

def main():
    n, m = map(int, input().split()) 
    adj = [set() for _ in range(n + 1)]

    for _ in range(m):
        u, v = map(int, input().split())
        adj[u].add(v)
        adj[v].add(u)

    unvisited = dfs(adj)
    print(len(unvisited))

main()
