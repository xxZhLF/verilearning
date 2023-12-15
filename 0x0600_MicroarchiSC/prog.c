#if defined(__x86) || defined(__x86_64)
#include <stdio.h>
#endif

int buff[16];
int main(int argc, char* argv[]){
    int bias = -14;
    for (unsigned int i = 0; i < 16; ++i){
        if (i < 8) {
            buff[i] = i + (bias >> 1);
        } else {
            buff[i] = (buff[i-8] * i) << 3;
        }
    }
#if defined(__x86) || defined(__x86_64)
    for (unsigned int i = 0; i < 16; ++i){
        printf("%08x\n", buff[i]);
    }
#endif
    return 0;
}