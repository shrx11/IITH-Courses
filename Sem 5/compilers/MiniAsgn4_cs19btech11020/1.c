#include <stdio.h>
#include <stdlib.h>

int main() {
    int NUM = 10;
    static char flags[100 + 1];
    long i, k;
    int count = 0;

    while (NUM--) {
        count = 0;
        for (i=2; i <= 100; i++) {   
            flags[i] = 1;
        }
        for (i=2; i <= 100; i++) {
            if (flags[i]) {
                for (k=i+i; k <= 100; k+=i) {
                    flags[k] = 0;
                }
                count++;
            }
        }
    }
    printf("Count: %d\n", count);
    return(0);
}
