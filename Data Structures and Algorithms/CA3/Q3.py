from sys import stdin


def finding(index, key):
    while index != -2:
        if tree[index][0] == key:
            return True
        elif key < tree[index][0]:
            index = tree[index][1] - 1
        else:
            index = tree[index][2] - 1
    return False


def main():
    q = int(stdin.readline())
    ans = 0

    roots = set(range(q))
    for i in range(q):
        parts = tuple(map(int, stdin.readline().split()))
        tree.append(parts)
        nums.append(parts[0])
        if parts[1]-1 != -2:
            roots.discard(parts[1] - 1)
        if parts[2]-1 != -2:
            roots.discard(parts[2] - 1)

    root = next(iter(roots))

    for num in nums:
        if not finding(root, num):
            ans += 1

    print(ans)


nums = []
tree = []
main()
