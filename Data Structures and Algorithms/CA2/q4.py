from collections import deque


def isuiMaker(nums, n, isui, reversed):
    if (reversed):
        nums.reverse()
    que = deque([])
    que.appendleft(0)
    for i in range(1, n):
        while (len(que) != 0 and nums[i] < nums[que[0]]):
            index = n - que[0] - 1 if reversed else que[0]
            isui[index] += i-que[0]
            que.popleft()
        que.appendleft(i)
    while (len(que) != 0):
        index = n - que[0] - 1 if reversed else que[0]
        isui[index] += n-que[0]
        que.popleft()
    if(reversed):
        nums.reverse()


def main():
    n = int(input())
    nums = deque([*map(int, input().split())])
    isui = [-1] * n
    ans = -1
    isuiMaker(nums, n, isui,False)
    isuiMaker(nums, n, isui,True)
    for i in range(0,n):
        if(ans < isui[i]*nums[i]):
            ans = isui[i]*nums[i]
    print(ans)



main()
