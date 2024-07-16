from sys import stdin


def type_one(el, x, y):
    return abs(el[0]-x)+abs(el[1]-y)


def finding(x, y):
    biggest = -1
    for pair in cords:
        if (pair[0] != -1):
            sum = abs(pair[0]-x) + abs(pair[1]-y)
            if biggest < sum:
                biggest = sum
    print(biggest)


def decider(operator, nums):
    if operator == "+":
        cords.append((nums[0], nums[1]))
    elif operator == "-":
        if nums[0] <= len(cords):
            cords[nums[0]-1] = (-1, -1)
    elif operator == "?":
        finding(nums[0], nums[1])


def main():
    q = int(stdin.readline())
    for i in range(0, q):
        parts = stdin.readline().split()
        decider(parts[0], [int(part) for part in parts[1:]])


cords = []
main()
