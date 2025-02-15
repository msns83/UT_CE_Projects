def check(arr, k, n):
    for i in range(n):
        found = False
        for j in range(i + 1, min(i + k + 1, n+1)):
            if arr[j] < arr[i]:
                found = True
                break
        if not found:
            return False
    return True

def sol(arr, k, n):
    if check(arr, k, n):
        return "YES"
    
    for i in range(n - 1):
        for j in range(i + 1, n):
            if arr[i] > arr[j]:
                arr[i], arr[j] = arr[j], arr[i]
                if check(arr, k, n):
                    return "YES"
                arr[i], arr[j] = arr[j], arr[i]
    
    return "NO"

def main():
    n, k = map(int, input().split())
    arr = list(map(int, input().split()))
    arr.append(-1)
    print(sol(arr, k, n))

main()