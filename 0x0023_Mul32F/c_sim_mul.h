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

#define show_float(n, end) do { \
    union { \
        float f; \
        unsigned int u; \
    } _ = { .f = n }; \
    for (unsigned char j = sizeof(float) * 8 - 1; j != 0xFF; --j){ \
        printf("%c", (_.u >> j) & 1 ? '1' : '0'); if (j == 31 || j == 23) printf(","); \
    }   printf(" = 0x%08X = %7.2f %c", _.u, _.f, end);\
} while (0)

#define show_calc_add(a, b) do {\
    float c = calc_IEEE754(a, b, '*'); \
    show_float(c, ' '); \
    printf("= %7.2f * %7.2f (Error to CPU: %.20f)\n", a, b, fabs(c - (a * b))); \
    fprintf(fp, "%08X + %08X = %08X\n", *(unsigned int *)&a, *(unsigned int *)&b, *(unsigned int *)&c); \
} while(0)

#define Prepare4Show() FILE* fp = fopen("data.tb", "w")
#define CleanUp4Show() fclose(fp)

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
            printf("Mul: UnSupported\n");
            break;
        case '-':
            printf("Mul: UnSupported\n");
            break;
        case '*':
            c.f = a.f * b.f;
            break;
        case '/':
            printf("Div: UnSupported\n");
            break;
        default:
            break;
    }
    return c.f;    
}