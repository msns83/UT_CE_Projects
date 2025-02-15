import bisect

def find_min_price(Arr, n,pivot,start, end,A,B,storage,power2):
    if (n == 0):
        if (start >= end):
            return A
        return B * (end - start)
    
    if (start, end, n) in storage:
        return storage[(start, end, n)]

    price1 = B * (end - start) * power2[n]
    if start >= end:
        price1 = A
    
    i = bisect.bisect_right(Arr, pivot, start, end)
    
    left_price = find_min_price(Arr, n - 1, pivot - power2[n-2], start, i, A,B,storage,power2)
    right_price = find_min_price(Arr, n - 1, pivot + power2[n-2], i, end, A,B,storage,power2)

    result = min(left_price + right_price, price1)
    storage[(start, end, n)] = result
    return result

def main():
    n, k, A, B = map(int, input().split())
    places = list(map(int, input().split()))
    places.sort()
    storage = {}
    storage.clear()
    power2 = [2 ** i for i in range(n+1)]
    

    ans = find_min_price(places, n, power2[n-1], 0, len(places),A,B,storage,power2)
    print(ans)

main()
