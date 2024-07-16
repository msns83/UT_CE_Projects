from sys import stdin

table = []
count = []

def adder_row(i,m, span):
    num = -1
    for j in span:
        if table[i][j] == "#": 
            num = -1
            continue
        else: 
            num += 1
        count[i * m + j] += num

def adder_col(i,m,span):
    num = -1
    for j in span:
        if table[j][i] == "#": 
            num = -1
            continue
        else: 
            num += 1
        count[j * m + i] += num

def main():
    global table 
    global count 
    n, m = map(int, stdin.readline().split())
    table= [[*stdin.readline()] for _ in range(n)]
    count = [0] * (m * n)

    for i in range(n):
        adder_row(i,m,range(m))
        adder_row(i,m,reversed(range(m)))

    for i in range(m):
        adder_col(i,m,range(n))
        adder_col(i,m,reversed(range(n)))

    print(max(count) + 1)

main()
