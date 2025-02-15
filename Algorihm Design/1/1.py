import math
mod = 1000000007

def combination(n , k):
    return math.factorial(n) // (math.factorial(n-k)* math.factorial(k))

def count_same_BSD(Arr):
    if (len(Arr) < 3):
        return 1
    
    smallers = []
    biggers = []

    for i in range(1,len(Arr)):
        if (Arr[i] < Arr[0]):
            smallers.append(Arr[i])
        else:
            biggers.append(Arr[i])
    
    count_smallers = count_same_BSD(smallers)
    count_biggers = count_same_BSD(biggers)

    ans = count_smallers * count_biggers * combination(len(Arr)-1,len(smallers))

    return ans % mod

def main():
    n = int(input())
    Arr = list(map(int , input().split()))
    ans = count_same_BSD(Arr)
    print(ans-1)

main()