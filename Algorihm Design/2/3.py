# AI Assistance:
# I used ChatGPT to help solve this problem. All prompts and responses are documented in detail
# in the following link: https://chatgpt.com/share/672f141d-18c8-800d-8ca1-cd3ec0adcb99
# You can easily find the prompt related to each question by looking at the corresponding replies and prompt texts.

def count_balanced_arrangements(n, m, v, c):
    MOD = 10**8
    
    dp = [[[0, 0] for _ in range(m + 1)] for _ in range(n + 1)]
    dp[0][0][0] = 1  
    dp[0][0][1] = 1

    for i in range(n + 1):
        for j in range(m + 1):
            if i > 0:
                for k in range(1, v + 1):
                    if i - k >= 0:
                        dp[i][j][0] += dp[i - k][j][1]
                        dp[i][j][0] %= MOD
            
            if j > 0:
                for k in range(1, c + 1): 
                    if j - k >= 0:
                        dp[i][j][1] += dp[i][j - k][0]
                        dp[i][j][1] %= MOD

    result = (dp[n][m][0] + dp[n][m][1]) % MOD
    return result

# I added this part, myself

def main():
    n, m, v, c = map(int, input().split())
    print(count_balanced_arrangements(n, m, v, c))

main()
