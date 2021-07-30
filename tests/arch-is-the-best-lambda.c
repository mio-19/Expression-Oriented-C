#include <stdio.h>
#include <stdlib.h>
#include <prelude.h>
int main(void) start(
   let arch_best = lambda_returns(void)(puts("Arch is the best!"); mkvoid());
   void (*arch_best2)(int) = lambda_returns(void, int x)(printf("Arch is the best! %d\n", x);mkvoid());
   arch_best();
   arch_best2(9999);
   EXIT_SUCCESS)
