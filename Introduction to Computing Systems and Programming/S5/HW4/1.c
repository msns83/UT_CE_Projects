#include <stdio.h>

int main() {

    int array[100], n, d, swap;
    int c = 0 ; /* c should be define as zero because we need it's value*/

    printf("Enter number of elements\n");
    scanf("%d", &n);

    printf("Enter %d integers\n", n); /* &n is used for adress , we need value */
    while (c < n) { /* we need c<n instead of c <= n because c starts from 0 and we can asign up to n-1 */
        scanf("%d", &array[c]);
        c++;
    }

    for (c = 0 ; c < n - 1; c++) {  
        for (d = 0 ; d < n - c - 1; d++) {    
            if (array[d] > array[d+1]) {      
                swap = array[d]; /*we need first keep array[d] in somewhere then change it's value in order to don't lose the first value of it*/
                array[d] = array[d+1];
                array[d+1] = swap;
            }
        }
    }

    printf("Sorted list in ascending order:\n");
    for (c = 0; c < n; c++) { /* we need c<n instead of c <= n because c starts from 0 and we can asign up to n-1 */
        printf("%d\n", array[c]);
    } 


    return 0;
}