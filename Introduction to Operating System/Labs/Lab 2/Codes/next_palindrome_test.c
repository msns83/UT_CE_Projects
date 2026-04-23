#include "types.h"
#include "user.h"

int main(void) {
    int num = 17;
    int result = next_palindrome(num);
    printf(1, "Next palindrome after %d is %d\n", num, result);
    exit();
}