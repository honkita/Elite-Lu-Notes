#include <stdio.h>
#include <stdlib.h>

extern int axor(int a, int b); 

int xor(int a, int b){
    return a ^ b;
}

int main(){
    //check if this holds true
    char * sentence = "Bitwise xor of %i and %i is supposed to be %i. Function printed out %i with c and as %i with ARM\n";
    printf(sentence, 5, 2, 7, xor(5,2), axor(5, 2));
    printf(sentence, 10, 10, 0, xor(10,10), axor(10, 10));
    printf(sentence, 10, 5, 15, xor(10,5), axor(10, 5));
    return 0;
}



