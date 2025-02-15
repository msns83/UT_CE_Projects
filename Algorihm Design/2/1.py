# AI Assistance:
# I used ChatGPT to help solve this problem. All prompts and responses are documented in detail
# in the following link: https://chatgpt.com/share/672f141d-18c8-800d-8ca1-cd3ec0adcb99
# You can easily find the prompt related to each question by looking at the corresponding replies and prompt texts.


def min_magic_cost(n, magic_costs, scrolls):
    reversed_scrolls = [s[::-1] for s in scrolls]
    
    inf = float('inf')
    dp = [[inf] * 2 for _ in range(n)]
    
    dp[0][0] = 0
    dp[0][1] = magic_costs[0]
    
    for i in range(1, n):
        if scrolls[i] >= scrolls[i-1]:
            dp[i][0] = min(dp[i][0], dp[i-1][0])
        if scrolls[i] >= reversed_scrolls[i-1]:
            dp[i][0] = min(dp[i][0], dp[i-1][1])
        if reversed_scrolls[i] >= scrolls[i-1]:
            dp[i][1] = min(dp[i][1], dp[i-1][0] + magic_costs[i])
        if reversed_scrolls[i] >= reversed_scrolls[i-1]:
            dp[i][1] = min(dp[i][1], dp[i-1][1] + magic_costs[i])
    
    result = min(dp[n-1][0], dp[n-1][1])
    return -1 if result == inf else result

# I added this part, myself

def main():
    n = int(input())
    magic_costs = list(map(int, input().split()))
    scrolls = []
    for _ in range (n):
        scrolls.append(input())
    print(min_magic_cost(n, magic_costs, scrolls))

main()
