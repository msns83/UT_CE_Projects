from collections import deque

def add_edge(u, v, graph):
    graph[u].append([v, 1, len(graph[v]), False])
    graph[v].append([u, 0, len(graph[u]) - 1, True])

def bfs(n, level, graph):
    for i in range(len(level)):
        level[i] = -1

    level[1] = 0
    queue = deque([1])

    while queue:
        u = queue.popleft()
        for edge in graph[u]:
            v, capacity, _, _ = edge

            if level[v] < 0 and 0 < capacity:
                level[v] = level[u] + 1
                queue.append(v)

    return 0 <= level[n]

def dfs(u, flow, target, level, traversed_edges, graph):
    if u == target:
        return flow
    
    while traversed_edges[u] < len(graph[u]):
        edge = graph[u][traversed_edges[u]]

        if level[edge[0]] == level[u] + 1 and edge[1] > 0:
            temp_flow = dfs(edge[0], min(flow, edge[1]), target, level, traversed_edges, graph)

            if temp_flow > 0:
                edge[1] -= temp_flow
                graph[edge[0]][edge[2]][1] += temp_flow
                return temp_flow
            
        traversed_edges[u] += 1

    return 0

def main():
    n, m = map(int, input().split())
    graph = [[] for _ in range(n + 1)]

    for _ in range(m):
        u, v = map(int, input().split())
        add_edge(u, v, graph)

    source = 1
    target = n
    max_flow = 0

    level = [-1] * (n + 1)
    traversed_edges = [0] * (n + 1)

    while bfs(target, level, graph):
        for i in range(n + 1):
            traversed_edges[i] = 0

        while True:
            flow = dfs(source, 10**9, target, level, traversed_edges, graph)
            if flow <= 0:
                break
            max_flow += flow

    print(max_flow)

    for _ in range(max_flow):
        path = []
        current_node = source

        while current_node != target:
            path.append(current_node)

            for edge in graph[current_node]:
                if graph[edge[0]][edge[2]][1] > 0 and edge[3] == False:
                    edge[3] = True
                    current_node = edge[0]
                    break

        path.append(target)

        print(len(path))
        string = ""
        for u in path:
            string += str(u) + " "
        print(string)

main()