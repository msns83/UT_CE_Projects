def max_members(n, k, counts):

    start = 0
    end = sum(counts) // k
    result = 0
    
    while start <= end:
        mid = (start + end) // 2
        temp = counts.copy()

        formed_groups = 0

        if n == 1 :
            formed_groups = temp[0] // mid

        for i in range(n-1):
            if  k <= formed_groups:
                break

            val = temp[i] + temp[i+1]
            formed_groups += val // mid
            rem = val % mid

            if temp[i+1] <= rem :
                temp[i] = rem - temp[i+1]
            else:
                temp[i+1] = rem
                temp[i] = 0
        
        if  k <= formed_groups:
            result = mid * k
            start = mid + 1
        else:
            end = mid - 1


    return result     
            

def main():
    tests = int(input())
    for _ in range(tests):
        n, k = map(int, input().split())
        counts = list(map(int, input().split()))
        print(max_members(n, k, counts))
        

main()