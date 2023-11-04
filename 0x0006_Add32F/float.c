#include <stdio.h>
#include <stdlib.h>

#define LSB 0xFC
#define MSB 0xCF

unsigned char endian_check(){
    unsigned int v = 0xFC;
    unsigned char *p = (unsigned char *)&v;
    if (*p == 0xFC){
        return LSB;
    } else {
        return MSB;
    }
}

char* f2b_string(float num, char* str){
    for (unsigned int i = 0; i < sizeof(float)*8; ++i){
        str[i] = ((((unsigned int)num) >> i) & 1) + '0';
    }   return str;
}

int main(int argc, char* argv[]){

    if (LSB != endian_check()){
        printf("Error: This machin is Big Endian! \n");
        return -1;
    }

    float array[] = {0.7, -0.7, 0.04, -0.04, 77.44, 33.66, -44.77, -66.33};

    for (unsigned char i = 0; i < sizeof(array) / sizeof(float); ++i){
        union {
            float f;
            unsigned int u;
        } _ = { .f = array[i] };
        for (unsigned char j = sizeof(float) * 8 - 1; j != 0xFF; --j){
            printf("%c", (_.u >> j) & 1 ? '1' : '0'); if (j == 31 || j == 23) printf(",");
        }   printf(" = 0x%08X = %6.2f \n", _.u, _.f);
    }

    return 0;
}