from heapq import heappop, heappush


def theWay(n, m, ist, jst, ien, jen, given):
    founded = [[5000] * (m + 1) for _ in range(n + 1)]
    founded[ist][jst] = 0
    heap = [(0, ist, jst)]

    dirs = [
        (1, -1, '/'), (1, 1, '\\'),
        (-1, 1, '/'), (-1, -1, '\\')
    ]

    while heap:
        changes, i, j = heappop(heap)

        if (i, j) == (ien, jen):
            return changes
        if changes > founded[i][j]:
            continue

        for di, dj, sign in dirs:
            ni, nj = i + di, j + dj

            if 0 <= ni <= n and 0 <= nj <= m:
                editX, editY = i + (di // 2), j + (dj // 2)

                if 0 <= editX < n and 0 <= editY < m:
                    nSign = given[editX][editY]
                else:
                    nSign = sign

                nChanges = changes + (0 if nSign == sign else 1)

                if nChanges < founded[ni][nj]:
                    founded[ni][nj] = nChanges
                    heappush(heap, (nChanges, ni, nj))

    return -1


n, m = map(int, input().split())
ist, jst = map(int, input().split())
ien, jen = map(int, input().split())
given = [input().strip() for _ in range(n)]

print(theWay(n, m, ist, jst, ien, jen, given))
