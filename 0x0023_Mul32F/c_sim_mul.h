#include <stdio.h>
#include <math.h>

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

#define IEEE754_decode(fraction) ( \
    /* Without sign bit => Highest data bit at 31 => left shift 8 bits */ \
    (0b00000000100000000000000000000000 | (unsigned int)(fraction)) << 8  \
)

float calc_IEEE754(float _a_, float _b_, char op){
    union {
        float f;
        struct {
            unsigned int fraction : 23; /* bit[22: 0] */
            unsigned int exponent :  8; /* bit[30:23] */
            unsigned int     sign :  1; /* bit[31]    */
        } u;
    } a = { .f = _a_ }, b = { .f = _b_ }, c;
    unsigned int frac_a = IEEE754_decode(a.u.fraction);
    unsigned int frac_b = IEEE754_decode(b.u.fraction);
    switch (op) {
        case '+':
            printf("Mul: UnSupported");
            break;
        case '-':
            printf("Mul: UnSupported");
            break;
        case '*':
            printf("Mul: UnSupported");
            break;
        case '/':
            printf("Div: UnSupported");
            break;
        default:
            break;
    }
    return c.f;    
}