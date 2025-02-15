from collections import deque
import sys

input = sys.stdin.readline

def bfs(starts, grid, n, m):
    cost = [[10**9]*m for _ in range(n)]
    dq = deque()
    
    for (r, c) in starts:
        cost[r][c] = 0
        dq.append((r, c))
   
    while dq:
        r, c = dq.popleft()
        for dr, dc in [(1,0),(-1,0),(0,1),(0,-1)]:
            nr, nc = r+dr, c+dc
            if 0 <= nr < n and 0 <= nc < m and grid[nr][nc] != '#':
                add = 0 if grid[nr][nc] in ('1','2','3') else 1
                if cost[r][c] + add < cost[nr][nc]:
                    cost[nr][nc] = cost[r][c] + add
                    if add == 0:
                        dq.appendleft((nr, nc))
                    else:
                        dq.append((nr, nc))
    return cost

def main():
    n, m = map(int, input().split())
    grid = [list(input().rstrip()) for _ in range(n)]
    
    starts1, starts2, starts3 = [], [], []
    for i in range(n):
        for j in range(m):
            if grid[i][j] == '1':
                starts1.append((i,j))
            elif grid[i][j] == '2':
                starts2.append((i,j))
            elif grid[i][j] == '3':
                starts3.append((i,j))
    
    
    cost1 = bfs(starts1, grid, n, m)
    cost2 = bfs(starts2, grid, n, m)
    cost3 = bfs(starts3, grid, n, m)
    
    ans = 10**15
    for i in range(n):
        for j in range(m):
            if cost1[i][j] != 10**9 and cost2[i][j] != 10**9 and cost3[i][j] != 10**9:
                total = cost1[i][j] + cost2[i][j] + cost3[i][j]
                if grid[i][j] == '.':
                    total -= 2
                ans = min(ans, total)
    
    if ans >= 10**9:
        print(-1)
    else:
        print(ans)

main()