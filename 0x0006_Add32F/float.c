#include <stdio.h>
#include <math.h>

#define LSB 0xFC
#define MSB 0xCF

#define IEEE754l(fraction) \
    ((0b00000000100000000000000000000000 | fraction) << 8)
#define IEEE754s(fraction) \
    (0b00000000011111111111111111111111 & (fraction >> 8))

#define calc_float(a, b) \
    { \
        union { \
            float f; \
            unsigned int u; \
        } _ = { .f = calc_IEEE754(a, b) }; \
        for (unsigned char j = sizeof(float) * 8 - 1; j != 0xFF; --j){ \
            printf("%c", (_.u >> j) & 1 ? '1' : '0'); if (j == 31 || j == 23) printf(","); \
        }   printf(" = 0x%08X = %7.2f = %7.2f + %7.2f\n", _.u, _.f, a, b); \
    }

float calc_IEEE754(float _a_, float _b_){
    union {
        float f;
        struct {
            unsigned int fraction : 23; /* bit[22: 0] */
            unsigned int exponent :  8; /* bit[30:23] */
            unsigned int     sign :  1; /* bit[31]    */
        } u;
    } a = { .f = _a_ }, b = { .f = _b_ }, c;
    unsigned int frac_a = IEEE754l(a.u.fraction);
    unsigned int frac_b = IEEE754l(b.u.fraction);
    unsigned int nbs = a.u.exponent > b.u.exponent ? a.u.exponent - b.u.exponent : b.u.exponent - a.u.exponent;
    if (a.u.exponent > b.u.exponent){
        unsigned int frac_c1 = IEEE754s(frac_a + (frac_b >> nbs));
        unsigned int frac_c2 = IEEE754s(frac_a - (frac_b >> nbs));
        printf("%08X + (%08X >> %d) = %08X\n", frac_a, frac_b, nbs, frac_c1);
        c.u.sign = a.u.sign ^ b.u.sign;
        c.u.exponent = a.u.exponent;
        c.u.fraction = c.u.sign ? frac_c1 : frac_c2;
    } else {
        unsigned int frac_c1 = IEEE754s((frac_a >> nbs) + frac_b);
        unsigned int frac_c2 = IEEE754s((frac_a >> nbs) - frac_b);
        c.u.sign = a.u.sign ^ b.u.sign;
        c.u.exponent = b.u.exponent;
        c.u.fraction = c.u.sign ? frac_c1 : frac_c2;
    }
    return c.f;    
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