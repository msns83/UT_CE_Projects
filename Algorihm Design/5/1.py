from collections import deque

def count_lines(row, col, vertical_lines, horizontal_lines):
        num = 0
        if horizontal_lines[row][col]: 
            num += 1
        if horizontal_lines[row+1][col]: 
            num += 1
        if vertical_lines[row][col]: 
            num += 1
        if vertical_lines[row][col+1]: 
            num += 1
        return num

def add_edge(u, v, capacity, graph):
        graph[u].append([v, capacity, len(graph[v])])
        graph[v].append([u, 0, len(graph[u]) - 1])

def bfs(graph):
        level = [-1]*(len(graph))
        level[0] = 0
        queue = deque([0])
        while queue:
            u = queue.popleft()
            for edge in graph[u]:
                v, capacity, _ = edge
                if capacity > 0 and level[v] < 0:
                    level[v] = level[u]+1
                    queue.append(v)
        return level

def dfs(u, flow, target, level, traversed_edges, graph):
        if u == target:
            return flow
        
        while traversed_edges[u] < len(graph[u]):
            v, capacity, reverse = graph[u][traversed_edges[u]]
            if capacity>0 and level[v] == level[u]+1:
                temp_flow = dfs(v, min(flow, capacity), target, level, traversed_edges, graph)
                if temp_flow>0:
                    graph[u][traversed_edges[u]][1] -= temp_flow
                    graph[v][reverse][1] += temp_flow
                    return temp_flow
            traversed_edges[u]+=1

        return 0

def max_flow(graph):
        max_flow = 0

        while True:
            level = bfs(graph)
            if level[len(graph)-1]<0:
                break

            while True:
                flow = dfs(0, 10**9, len(graph)-1, level, [0]*(len(graph)), graph)
                if flow<=0: break
                max_flow += flow

        return max_flow

def main():
    n = int(input())

    horizontal_lines = [[False]*(n-1) for _ in range(n)]
    vertical_lines = [[False]*n for _ in range(n-1)]

    for row in range(2*n - 1):
        string_input = input()
        for col in range(2*n - 1):
            char = string_input[col]
            if row % 2 == 0 and col % 2 == 1 and char == '-':
                horizontal_lines[row // 2][(col - 1) // 2] = True
            elif row % 2 == 1 and col % 2 == 0 and char == '|':
                vertical_lines[(row - 1) // 2][col // 2] = True

    A_id = {}
    B_id = {}
    A_count = 0
    B_count = 0
    for row in range(n-1):
        for col in range(n-1):
            if (row + col) % 2 == 0:
                A_id[(row,col)] = A_count
                A_count += 1
            else:
                B_id[(row,col)] = B_count
                B_count += 1

    source = 0
    target = A_count + B_count + 1
    graph = [[] for _ in range(target+1)]

    for row in range(n-1):
        for col in range(n-1):
            capacity = 3 - count_lines(row, col, vertical_lines, horizontal_lines)      
            if (row + col) % 2 == 0:
                node_id = A_id[(row,col)] + 1
                add_edge(source, node_id, capacity, graph)
            else:
                node_id = B_id[(row,col)] + 1 + A_count
                add_edge(node_id, target, capacity, graph)

    for row in range(n):
        for col in range(n-1):
            if not horizontal_lines[row][col]:

                squares = []
                if 0 <= row-1:
                    squares.append((row-1, col))
                if row < (n-1):
                    squares.append((row, col))

                if len(squares) == 2:
                    (row1,col1),(row2,col2) = squares
                    if (row1 + col1) % 2 == 0:
                        A_node = A_id[(row1,col1)] + 1
                        B_node = B_id[(row2,col2)] + 1 + A_count
                    else:
                        A_node = A_id[(row2,col2)] + 1
                        B_node = B_id[(row1,col1)] + 1 + A_count
                    add_edge(A_node, B_node, 1, graph)
                else:
                    (edgy_row,edgy_col) = squares[0]
                    if (edgy_row + edgy_col) % 2 == 0:
                        A_node = A_id[(edgy_row,edgy_col)] + 1
                        add_edge(A_node,target, 1, graph)
                    else:
                        B_node = B_id[(edgy_row,edgy_col)] + 1 + A_count
                        add_edge(source, B_node, 1, graph)

    for row in range(n-1):
        for col in range(n):
            if not vertical_lines[row][col]:

                squares = []
                if 0 <= col-1:
                    squares.append((row, col-1))
                if col < (n-1): 
                    squares.append((row, col))

                if len(squares) == 2:
                    (row1,col1),(row2,col2) = squares
                    if (row1 + col1) % 2 == 0:
                        A_node = A_id[(row1,col1)] + 1
                        B_node = B_id[(row2,col2)] + 1 + A_count
                    else:
                        A_node = A_id[(row2,col2)] + 1
                        B_node = B_id[(row1,col1)] + 1 + A_count
                    add_edge(A_node, B_node, 1, graph)
                else:
                    (edgy_row,edgy_col) = squares[0]
                    if (edgy_row + edgy_col) % 2 == 0:
                        A_node = A_id[(edgy_row,edgy_col)] + 1
                        add_edge(A_node,target, 1, graph)
                    else:
                        B_node = B_id[(edgy_row,edgy_col)] + 1 + A_count
                        add_edge(source, B_node, 1, graph)

    print(max_flow(graph))

main()