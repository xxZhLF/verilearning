#include <stdio.h>
#include <math.h>

#define LSB 0xFC
#define MSB 0xCF

#define calc_float(a, b) \
    { \
        union { \
            float f; \
            unsigned int u; \
        } _ = { .f = a + b }; \
        for (unsigned char j = sizeof(float) * 8 - 1; j != 0xFF; --j){ \
            printf("%c", (_.u >> j) & 1 ? '1' : '0'); if (j == 31 || j == 23) printf(","); \
        }   printf(" = 0x%08X = %7.2f = %7.2f + %7.2f\n", _.u, _.f, a, b); \
    }

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
        }   printf(" = 0x%08X = %7.2f \n", _.u, _.f);
    }

    calc_float(array[0], array[2]);
    calc_float(array[1], array[2]);
    calc_float(array[1], array[3]);
    calc_float(array[0], array[3]);
    calc_float(array[4], array[5]);
    calc_float(array[6], array[7]);
    calc_float(array[4], array[6]);
    calc_float(array[5], array[7]);

    printf("\n");
    char* dl = "+---------+----------------------------+";
    char* hd = "| 2^{-n}  | Value                      |";
    printf("%s\n%s\n", dl, hd);
    for (unsigned int i = 1; i <= 23; ++i){printf("%s\n", dl);
        printf("| 2^(-%-2d) | %.24f |\n", i, 1.0 / pow(2, i));
    }   printf("%s\n", dl);


    return 0;
}