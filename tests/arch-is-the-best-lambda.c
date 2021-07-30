#include <stdio.h>
#include <stdlib.h>
#include <prelude.h>
int main(void) start(
   let arch_best = lambda(void, (void))(puts("Arch is the best!"); mkvoid());
   void (*arch_best2)(void) = lambda(void, (void))(puts("Arch is the best!"); mkvoid());
   arch_best();
   arch_best2();
   EXIT_SUCCESS)
