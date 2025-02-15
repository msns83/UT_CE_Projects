# AI Assistance:
# I used ChatGPT to help solve this problem. All prompts and responses are documented in detail
# in the following link: https://chatgpt.com/share/672f141d-18c8-800d-8ca1-cd3ec0adcb99
# You can easily find the prompt related to each question by looking at the corresponding replies and prompt texts.

def max_coins(n, m):
    m = [1] + m + [1]
    
    dp = [[0] * (n + 2) for _ in range(n + 2)]
    
    for length in range(1, n + 1):
        for l in range(1, n - length + 2):
            r = l + length - 1
            for k in range(l, r + 1):
                coins = m[l - 1] * m[k] * m[r + 1] + dp[l][k - 1] + dp[k + 1][r]
                dp[l][r] = max(dp[l][r], coins)
    
    return dp[1][n]

# I added this part, myself
def main():
    n = int(input())
    m = list(map(int, input().split()))
    print(max_coins(n, m))

main()