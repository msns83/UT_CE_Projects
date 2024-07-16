def dfs(start, visit, vert):
    stack = [start]
    while (len(stack) != 0):
        u = stack.pop()
        if (visit[u] == 0):
            visit[u] = 1
            vert.append(u)
            for v in range(n):
                if mat[u][v] == 1 and visit[v] == 0:
                    stack.append(v)


n = int(input())
a = list(map(int, input().split()))
mat = []
verts = []
visit = [0] * n
ans = [0] * n
for i in range(n):
    mat.append(list(map(int, input())))

for i in range(n):
    if (visit[i] == 0):
        vert = []
        dfs(i, visit, vert)
        verts.append(vert)

for i in range(len(verts)):
    values = [a[j] for j in verts[i]]
    values.sort()
    verts[i].sort()
    for j, v in zip(verts[i], values):
        ans[j] = v

print(' '.join(map(str, ans)))
