#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "int_out.c"

void test(int i, char* a){
    int_out(i);
    printf("Expected output: %s\n", a);
}

int main(){
    test(69, "0x45");
    test(5, "0x5");

    return 0;
}

