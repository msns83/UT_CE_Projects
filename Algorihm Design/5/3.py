import math
from collections import deque

def add_edge(u, v, capacity, graph):
        graph[u].append([v, capacity, len(graph[v]), True])
        graph[v].append([u, 0, len(graph[u]) - 1, False])

def bfs(graph):
        level = [-1]*(len(graph))
        level[0] = 0
        queue = deque([0])
        while queue:
            u = queue.popleft()
            for edge in graph[u]:
                v, capacity, _, _ = edge
                if capacity > 0 and level[v] < 0:
                    level[v] = level[u]+1
                    queue.append(v)
        return level

def dfs(u, flow, target, level, traversed_edges, graph):
        if u == target:
            return flow
        
        while traversed_edges[u] < len(graph[u]):
            v, capacity, reverse,_ = graph[u][traversed_edges[u]]
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
                if flow<=0:
                    break
                max_flow += flow

        return max_flow

def main():
    t = int(input())
    
    outputs = []

    for _ in range(t):
        n, m = map(int, input().split()) 
        table = []
        for i in range(n):
            row_vals = list(map(float, input().split()))
            table.append(row_vals)

        row_sum = []
        for row in table:
            row_sum.append(sum(row))

        col_sum = []
        for j in range(m):
            temp_col_sum = 0
            for i in range(n):
                temp_col_sum += table[i][j]
            col_sum.append(temp_col_sum)

        row_floor_sum = [0]*n
        col_floor_sum = [0]*m
        for i in range(n):
            for j in range(m):
                floor_val = math.floor(table[i][j])
                row_floor_sum[i] += floor_val
                col_floor_sum[j] += floor_val

        row_need = [0]*n
        col_need = [0]*m
        for i in range(n):
            row_need[i] = round(row_sum[i] - row_floor_sum[i])
        for i in range(m):
            col_need[i] = round(col_sum[i] - col_floor_sum[i])
        
        if sum(row_need) != sum(col_need):
            outputs.append("NO")
            continue
        
        total_need = sum(row_need)
        
        source = 0
        target = n+m+1
        graph = [[] for _ in range(target+1)]
        
        for i in range(n):
            add_edge(source, i+1, row_need[i], graph)
        
        for i in range(n):
            for j in range(m):
                if  1e-9 < abs(table[i][j] - math.floor(table[i][j])): 
                    add_edge(i+1, n+j+1, 1, graph)
        
        for j in range(m):
            add_edge(n+j+1, target, col_need[j], graph)


        max_flow_val = max_flow(graph)
        if max_flow_val < total_need:
            outputs.append("NO")
            continue

        answer_table = [[0]*m for _ in range(n)]
        
        for i in range(n):
            row_node = i+1
            for edge in graph[row_node]:
                 if edge[3] and 0 < graph[edge[0]][edge[2]][1]:
                      answer_table[i][edge[0]-n-1] = 1
                    
        
        outputs.append("YES")
        for i in range(n):
            string = ""
            for j in range(m):
                string += str(answer_table[i][j]) + " "
            outputs.append(string)
    
    for i in range(len(outputs)):
        print(outputs[i])


main()