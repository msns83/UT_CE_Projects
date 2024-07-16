from collections import deque

que = deque([])


def isCapital(char):
    if (char == char.upper()):
        return True
    return False


def checker(phrase):
    for i in phrase:
        if (isCapital(i)):
            que.appendleft(i)
        else:
            if (len(que) != 0 and que[0] == i.upper()):
                que.popleft()
            else:
                return 0

    if (len(que) == 0):
        return 1

    que.clear()
    return 0


def main():
    phrase = input()
    q = int(input())
    ans = ""
    for i in range(0, q):
        start, end = map(int, input().split())
        ans += f"{checker(phrase[start-1:end])}"
    print(ans, end="")


main()
