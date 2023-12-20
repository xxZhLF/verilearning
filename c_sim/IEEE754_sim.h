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

#define show_contrastbl() do { \
    printf("\n"); \
    char* l1 = "+--------------------------------------+"; \
    char* hd = "|               CONTRAST               |"; \
    char* dl = "+---------+----------------------------+"; \
    printf("%s\n%s\n", l1, hd); \
    for (unsigned int i = 1; i <= 23; ++i){printf("%s\n", dl); \
        printf("| 2^(-%-2d) | %.24f |\n", i, 1.0 / (1 << i)); \
    }   printf("%s\n", dl); \
    printf("\n"); \
} while(0)

#define IEEE754_decode(fraction) ( \
    ((0b00000000100000000000000000000000 | (unsigned int)(fraction)) << 8) \
)

#define IEEE754_encode(fraction) ( \
    (0b00000000011111111111111111111111 & ((unsigned int)(fraction) >> 8)) \
    + ((unsigned int)(fraction) >> 7 & 1 ? 1 : 0) \
)

#define Complement_of_2(sign, fraction) ( \
    !(unsigned int)(sign) ? ((unsigned int)(fraction) >> 1) : \
                          (~((unsigned int)(fraction) >> 1) + 1) \
)

#define Complement2TrueCode(fraction) ( \
    !((unsigned int)(fraction) >> 31) ? ((unsigned int)(fraction) << 1) : \
                                      ~(((unsigned int)(fraction) << 1) - 1) \
)

#define show_FLOAT2BIN(n, end) do { \
    union { \
        float f; \
        unsigned int u; \
    } _ = { .f = n }; \
    for (unsigned char j = sizeof(float) * 8 - 1; j != 0xFF; --j){ \
        printf("%c", (_.u >> j) & 1 ? '1' : '0'); if (j == 31 || j == 23) printf(","); \
    }   printf(" = 0x%08X = %11.6f %c", _.u, _.f, end);\
} while (0)

#define show_calc_add(a, b) do {\
    float c = calc_IEEE754(a, b, '+'); \
    show_FLOAT2BIN(c, ' '); \
    printf("= %10.6f + %10.6f (Error to CPU: %.20f)\n", a, b, fabs(c - (a + b))); \
    fprintf(fp, "%08X + %08X = %08X\n", *(unsigned int *)&a, *(unsigned int *)&b, *(unsigned int *)&c); \
} while(0)

#define show_calc_sub(a, b) do {\
    float c = calc_IEEE754(a, b, '-'); \
    show_FLOAT2BIN(c, ' '); \
    printf("= %10.6f - %10.6f (Error to CPU: %.30f)\n", a, b, fabs(c - (a - b))); \
    fprintf(fp, "%08X - %08X = %08X\n", *(unsigned int *)&a, *(unsigned int *)&b, *(unsigned int *)&c); \
} while(0)

#define show_calc_mul(a, b) do {\
    float c = calc_IEEE754(a, b, '*'); \
    show_FLOAT2BIN(a, ' '); printf("T\n"); \
    show_FLOAT2BIN(b, ' '); printf("M\n"); \
    show_FLOAT2BIN(c, ' '); printf("B\n"); \
    printf("(%f)@T * (%f)@M = (%f)@B\n", a, b, c); \
    printf("Error to CPU: %.30f\n\n", fabs(c - (a * b))); \
    fprintf(fp, "%08X * %08X = %08X\n", *(unsigned int *)&a, *(unsigned int *)&b, *(unsigned int *)&c); \
} while(0)

#define show_calc_div(a, b) do {\
    float c = calc_IEEE754(a, b, '/'); \
    show_FLOAT2BIN(a, ' '); printf("T\n"); \
    show_FLOAT2BIN(b, ' '); printf("M\n"); \
    show_FLOAT2BIN(c, ' '); printf("B\n"); \
    printf("(%f)@T / (%f)@M = (%f)@B\n", a, b, c); \
    printf("Error to CPU: %.30f\n\n", fabs(c - (a / b))); \
    fprintf(fp, "%08X / %08X = %08X\n", *(unsigned int *)&a, *(unsigned int *)&b, *(unsigned int *)&c); \
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
             int msb_at = 0;
    switch (op) {
        case '+': {
                unsigned int nbs = a.u.exponent > b.u.exponent ? a.u.exponent - b.u.exponent : b.u.exponent - a.u.exponent;
                if (a.u.exponent > b.u.exponent){
                    c.u.sign = a.u.sign; 
                    unsigned int frac_c = Complement_of_2(a.u.sign, frac_a) + Complement_of_2(b.u.sign, frac_b >> nbs);
                    frac_c = Complement2TrueCode(frac_c);
                    for (msb_at = 31; (!(frac_c & ((unsigned int)1 << msb_at))) && (msb_at >= 0); --msb_at){}
                    c.u.fraction = IEEE754_encode(frac_c << (31 - msb_at));
                    c.u.exponent = a.u.exponent - (31 - msb_at);
                } else if (a.u.exponent < b.u.exponent) {
                    c.u.sign = b.u.sign; 
                    unsigned int frac_c = Complement_of_2(a.u.sign, frac_a >> nbs) + Complement_of_2(b.u.sign, frac_b);
                    frac_c = Complement2TrueCode(frac_c);
                    for (msb_at = 31; (!(frac_c & ((unsigned int)1 << msb_at))) && (msb_at >= 0); --msb_at){}
                    c.u.fraction = IEEE754_encode(frac_c << (31 - msb_at));
                    c.u.exponent = b.u.exponent - (31 - msb_at);
                } else {
                    c.u.sign = a.u.fraction > b.u.fraction ? a.u.sign : b.u.sign;
                    unsigned int frac_c = Complement_of_2(a.u.sign, frac_a) + Complement_of_2(b.u.sign, frac_b >> nbs);
                    frac_c = Complement2TrueCode(frac_c);
                    for (msb_at = 31; (!(frac_c & ((unsigned int)1 << msb_at))) && (msb_at >= 0); --msb_at){}
                    c.u.fraction = IEEE754_encode(frac_c << (31 - msb_at));
                    c.u.exponent = b.u.exponent - (31 - msb_at);
                }
            } break;
        case '-': {
                b.u.sign = ~b.u.sign;
                c.f = calc_IEEE754(a.f, b.f, '+');
            } break;
        case '*': {
                unsigned long int frac_c = (unsigned long int)(frac_a) * (unsigned long int)(frac_b); 
                for (msb_at = 63; (!(frac_c & ((unsigned int)1 << msb_at))) && (msb_at >= 0); --msb_at){}
                c.u.exponent = a.u.exponent + b.u.exponent - 127 + 1 /* Point left shift 1-bit. Cause is:
                               x.xxx * x.xxx = xx.xxxxx */ - (63 - msb_at);
                c.u.fraction = IEEE754_encode((frac_c >> 32)); 
                c.u.sign = a.u.sign ^ b.u.sign;
            } break;
        case '/': {
                unsigned long int fracEX_a = (unsigned long int)(frac_a) << 32;
                unsigned long int fracEX_b = (unsigned long int)(frac_b) << 32;
                unsigned int frac_c = 0;
                for (unsigned int i = 0; i < 31; ++i){
                    frac_c   = frac_c | (
                               fracEX_a < fracEX_b ? 0 : (unsigned int)1 << (31 - i));
                    fracEX_a = fracEX_a < fracEX_b ? fracEX_a : (fracEX_a - fracEX_b);
                    fracEX_b = fracEX_b >> 1;
                }   for (msb_at = 31; (!(frac_c & ((unsigned int)1 << msb_at))) && (msb_at >= 0); --msb_at){}
                c.u.fraction = IEEE754_encode(frac_c << (31 - msb_at));
                c.u.exponent = a.u.exponent - b.u.exponent + 127 - (31 - msb_at);
                c.u.sign = a.u.sign ^ b.u.sign;
            } break;
        default:
            break;
    }
    return c.f;    
}
