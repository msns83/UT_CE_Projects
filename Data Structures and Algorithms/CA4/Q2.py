def isWay(verts, u, c, j, flood):
    verts[u][0] = 1
    flood += 1

    if (0 <= u <= flood or c+j+1 <= u <= c+j+1+flood):
        return False

    if ((c <= u <= c+j) or (2*c+j+1 <= u <= 2*c+2*j+1)):
        return True

    for i in range(1, len(verts[u])):
        if (verts[verts[u][i]][0] == 0):
            if (isWay(verts, verts[u][i], c, j, flood) == False):
                continue
            else:
                return True

    return False


nq = int(input())

for _ in range(nq):
    c, j = map(int, input().split())
    left = input()
    right = input()
    verts = [[0] for _ in range(2*(c+j+1))]
    verts[0][0] = -1
    verts[c+j+1][0] = -1

    for i in range(c):
        if (left[i] == 'X'):
            verts[i+1][0] = -1
        if (right[i] == 'X'):
            verts[(c+j+1)+i+1][0] = -1

    for i in range(1, c+1):
        if (verts[i][0] != -1):
            if (verts[i+1][0] != -1):
                verts[i].append(i+1)
            if (verts[i-1][0] != -1):
                verts[i].append(i-1)
            if (verts[(c+j+1)+i+j][0] != -1):
                verts[i].append((c+j+1)+i+j)

    for i in range(c+j+2, 2*c+j+2):
        if (verts[i][0] != -1):
            if (verts[i+1][0] != -1):
                verts[i].append(i+1)
            if (verts[i-1][0] != -1):
                verts[i].append(i-1)
            if (verts[i-(c+1)][0] != -1):
                verts[i].append(i-(c+1))

    if (isWay(verts, 1, c, j, -1)):
        print("YES")
    else:
        print("NO")
