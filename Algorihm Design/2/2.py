# AI Assistance:
# I used ChatGPT to help solve this problem, specifically to find the dynamic programming solution.
# However, it couldn't provide the full solution but gave me some useful hints. I then solved the problem myself. 
# The prompts and responses are documented in detail
# in the following link: https://chatgpt.com/share/672f60f0-5e70-800d-9280-db9d1591eb65


def your_chance(n,m,k):
    dp = [0.0] * (n+1)
    dp[0] = 1.0

    for i in range (0, m):
        for dice in range (1,k+1):
            if (i+dice <= n):
                dp[i + dice] +=  dp[i] * (1/k)

    return sum(dp[m:n + 1])

def main():
    n, m, k = map(int, input().split())
    print(your_chance(n,m,k))

main()

