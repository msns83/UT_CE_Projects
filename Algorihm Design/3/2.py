def code(nums, s):

    counts =[s.count('H'), s.count('P'), s.count('HP'), s.count('PH')] 

    if counts[0] != nums[0]+nums[2]+nums[3]:
        return "NO"
    if counts[1] != nums[1]+nums[2]+nums[3]:
        return "NO"
    if counts[2] < nums[2]:
        return "NO"
    if counts[3] < nums[3]:
        return "NO"
    
    
    return "YES"

    
    
def main():
    tests = int(input())

    for _ in range(tests):
        nums = list(map(int, input().split()))
        s = input()
        print(code(nums, s))

main()