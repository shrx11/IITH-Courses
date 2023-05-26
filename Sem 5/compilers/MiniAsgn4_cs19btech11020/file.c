#include<stdlib.h>
int* foo(int* a, int* b) {
return *a > *b ? a : b;
}
void bar(int* x, int* y) {
int tmp = *x;
*x = *y;
*y = *x;
}
int main() {
int* a0 = (int*)malloc(4);
int* a1 = (int*)malloc(4);
int* a2 = (int*)malloc(4);
int* a3 = (int*)malloc(4);
int* a4;
*a0 = 0;
*a1 = 1;
*a2 = 2;
*a3 = 3;
a4 = foo(a0, a1);

bar(a2, a3);
return *a0 + *a1 + *a2 + *a3 + *a4;
}