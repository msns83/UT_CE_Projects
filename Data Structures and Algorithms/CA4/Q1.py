from collections import deque

v, m = map(int, input().split())

ver = [[0] for _ in range(v+1)]

for i in range(m):
    h, l = map(int, input().split())
    ver[h].append(l)
    ver[l].append(h)

que = deque()
group = []
groups3 = []
groups2 = []
groups1 = []
bad = 0

for i in range(1, v+1):
    if (ver[i][0] == 0):
        ver[i][0] = 1
        que.append(i)
        group.append(i)
        while (len(que) != 0):
            index = que.popleft()
            for j in range(1, len(ver[index])):
                if (ver[ver[index][j]][0] == 0):
                    ver[ver[index][j]][0] = 1
                    que.append(ver[index][j])
                    group.append(ver[index][j])
        if (len(group) == 3):
            groups3.append(tuple(group))
        elif (len(group) == 2):
            groups2.append(tuple(group))
        elif (len(group) == 1):
            groups1.append(tuple(group))
        else:
            bad = 1
            break
        group.clear()

if (bad == 1 or len(groups1) < len(groups2)):
    print(-1)
else:
    for nGroup in groups3:
        print(' '.join(map(str, nGroup)))

    for sublist1, sublist2 in zip(groups2, groups1):
        element1, element2 = sublist1
        element3 = sublist2[0]
        print(f"{element1} {element2} {element3}")

    ones = groups1[len(groups2):]

    for i in range(int(len(ones)/3)):
        print(f"{ones[i*3+0][0]} {ones[i*3+1][0]} {ones[i*3+2][0]}")
