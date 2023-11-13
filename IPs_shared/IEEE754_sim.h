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

#define number_of_bits_to_shift(fraction) ( \
/*  ((unsigned int)1 << 31) & (unsigned int)(fraction) ?  * :  */\
    ((unsigned int)1 << 30) & (unsigned int)(fraction) ?  0 :    \
    ((unsigned int)1 << 29) & (unsigned int)(fraction) ?  1 :    \
    ((unsigned int)1 << 28) & (unsigned int)(fraction) ?  2 :    \
    ((unsigned int)1 << 27) & (unsigned int)(fraction) ?  3 :    \
    ((unsigned int)1 << 26) & (unsigned int)(fraction) ?  4 :    \
    ((unsigned int)1 << 25) & (unsigned int)(fraction) ?  5 :    \
    ((unsigned int)1 << 24) & (unsigned int)(fraction) ?  6 :    \
    ((unsigned int)1 << 23) & (unsigned int)(fraction) ?  7 :    \
    ((unsigned int)1 << 22) & (unsigned int)(fraction) ?  8 :    \
    ((unsigned int)1 << 21) & (unsigned int)(fraction) ?  9 :    \
    ((unsigned int)1 << 20) & (unsigned int)(fraction) ? 10 :    \
    ((unsigned int)1 << 19) & (unsigned int)(fraction) ? 11 :    \
    ((unsigned int)1 << 18) & (unsigned int)(fraction) ? 12 :    \
    ((unsigned int)1 << 17) & (unsigned int)(fraction) ? 13 :    \
    ((unsigned int)1 << 16) & (unsigned int)(fraction) ? 14 :    \
    ((unsigned int)1 << 15) & (unsigned int)(fraction) ? 15 :    \
    ((unsigned int)1 << 14) & (unsigned int)(fraction) ? 16 :    \
    ((unsigned int)1 << 13) & (unsigned int)(fraction) ? 17 :    \
    ((unsigned int)1 << 12) & (unsigned int)(fraction) ? 18 :    \
    ((unsigned int)1 << 11) & (unsigned int)(fraction) ? 19 :    \
    ((unsigned int)1 << 10) & (unsigned int)(fraction) ? 20 :    \
    ((unsigned int)1 <<  9) & (unsigned int)(fraction) ? 21 :    \
    ((unsigned int)1 <<  8) & (unsigned int)(fraction) ? 22 :    \
    ((unsigned int)1 <<  7) & (unsigned int)(fraction) ? 23 :    \
    ((unsigned int)1 <<  6) & (unsigned int)(fraction) ? 24 :    \
    ((unsigned int)1 <<  5) & (unsigned int)(fraction) ? 25 :    \
    ((unsigned int)1 <<  4) & (unsigned int)(fraction) ? 26 :    \
    ((unsigned int)1 <<  3) & (unsigned int)(fraction) ? 27 :    \
    ((unsigned int)1 <<  2) & (unsigned int)(fraction) ? 28 :    \
    ((unsigned int)1 <<  1) & (unsigned int)(fraction) ? 29 :    \
    ((unsigned int)1 <<  0) & (unsigned int)(fraction) ? 30 : 31 \
)

#define rounding_bias(fraction) ( \
    ((unsigned int)(fraction) & ((unsigned int)1 << (6 + number_of_bits_to_shift(fraction)))) ? 1 : 0 \
)

#define recover_function_from_discard(fraction, discard, nbs) ( \
    ((unsigned int)(fraction) << nbs) | ((unsigned)(discard) >> (32 - nbs)) \
)

#define smart_shift_4_encoder(fraction, discard) (\
    /* Sign bit at 31 => Highest data bit at 30 => right shift 7 bits */  \
    (recover_function_from_discard(fraction, discard, number_of_bits_to_shift(fraction)) >> 7) + \
    rounding_bias(recover_function_from_discard(fraction, discard, number_of_bits_to_shift(fraction))) \
)

#define IEEE754_decode(fraction) ( \
    /* Without sign bit => Highest data bit at 31 => left shift 8 bits */ \
    (0b00000000100000000000000000000000 | (unsigned int)(fraction)) << 8  \
)

#define IEEE754_encode(fraction, discard) \
    (0b00000000011111111111111111111111 & smart_shift_4_encoder(fraction, discard))

#define Complement_of_2(sign, fraction) ( \
        ((unsigned int)sign << 31) \
    | \
        ((unsigned int)sign == 0 ?  ((unsigned int)(fraction) >> 1) : \
                                  (~((unsigned int)(fraction) >> 1) + 1)) \
)

#define Complement2TrueCode(sign, fraction) ( \
        ((unsigned int)sign << 31) \
    | \
        ((unsigned int)sign == 0 ?  ((unsigned int)(fraction) >> 1) : \
                                  ~(((unsigned int)(fraction) >> 1) - 1)) \
)

#define show_FLOAT2BIN(n, end) do { \
    union { \
        float f; \
        unsigned int u; \
    } _ = { .f = n }; \
    for (unsigned char j = sizeof(float) * 8 - 1; j != 0xFF; --j){ \
        printf("%c", (_.u >> j) & 1 ? '1' : '0'); if (j == 31 || j == 23) printf(","); \
    }   printf(" = 0x%08X = %12.6f %c", _.u, _.f, end);\
} while (0)

#define show_calc_add(a, b) do {\
    float c = calc_IEEE754(a, b, '+'); \
    show_FLOAT2BIN(c, ' '); \
    printf("= %12.6f + %12.6f (Error to CPU: %.20f)\n", a, b, fabs(c - (a + b))); \
    fprintf(fp, "%08X + %08X = %08X\n", *(unsigned int *)&a, *(unsigned int *)&b, *(unsigned int *)&c); \
} while(0)

#define show_calc_sub(a, b) do {\
    float c = calc_IEEE754(a, b, '-'); \
    show_FLOAT2BIN(c, ' '); \
    printf("= %12.6f - %12.6f (Error to CPU: %.30f)\n", a, b, fabs(c - (a - b))); \
    fprintf(fp, "%08X - %08X = %08X\n", *(unsigned int *)&a, *(unsigned int *)&b, *(unsigned int *)&c); \
} while(0)

#define show_calc_div(a, b) do {\
    float c = calc_IEEE754(a, b, '/'); \
    show_FLOAT2BIN(a, '\n'); show_FLOAT2BIN(b, '\n'); show_FLOAT2BIN(c, '\n'); \
    printf("(%f)@T / (%f)@M = (%f)@B\n", a, b, c); \
    printf("Error to CPU: %.30f\n\n", fabs(c - (a / b))); \
    fprintf(fp, "%08X / %08X = %08X\n", *(unsigned int *)&a, *(unsigned int *)&b, *(unsigned int *)&c); \
} while(0)

#define show_calc_mul(a, b) do {\
    float c = calc_IEEE754(a, b, '*'); \
    show_FLOAT2BIN(a, '\n'); show_FLOAT2BIN(b, '\n'); show_FLOAT2BIN(c, '\n'); \
    printf("(%f)@T * (%f)@M = (%f)@B\n", a, b, c); \
    printf("Error to CPU: %.30f\n\n", fabs(c - (a * b))); \
    fprintf(fp, "%08X * %08X = %08X\n", *(unsigned int *)&a, *(unsigned int *)&b, *(unsigned int *)&c); \
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
        case '+': {
            unsigned int nbs = a.u.exponent > b.u.exponent ? a.u.exponent - b.u.exponent : b.u.exponent - a.u.exponent;
            if (a.u.exponent > b.u.exponent){
                c.u.sign = a.u.sign;
                unsigned int frac_c = Complement_of_2(a.u.sign, frac_a) + Complement_of_2(b.u.sign, frac_b >> nbs);
                unsigned int overflow = frac_c >> 31 != c.u.sign;
                frac_c = overflow ? frac_c >> 1 : frac_c;
                c.u.fraction = IEEE754_encode(Complement2TrueCode(c.u.sign, frac_c << 1), 0x00000000);
                c.u.exponent = a.u.exponent - number_of_bits_to_shift(Complement2TrueCode(a.u.sign, frac_c << 1)) + overflow;
            } else if (a.u.exponent < b.u.exponent) {
                c.u.sign = b.u.sign;
                unsigned int frac_c = Complement_of_2(a.u.sign, frac_a >> nbs) + Complement_of_2(b.u.sign, frac_b);
                unsigned int overflow = frac_c >> 31 != c.u.sign;
                frac_c = overflow ? frac_c >> 1 : frac_c;
                c.u.fraction = IEEE754_encode(Complement2TrueCode(c.u.sign, frac_c << 1), 0x00000000);
                c.u.exponent = b.u.exponent - number_of_bits_to_shift(Complement2TrueCode(b.u.sign, frac_c << 1)) + overflow;
            } else {
                c.u.sign = a.u.fraction > b.u.fraction ? a.u.sign : b.u.sign;
                unsigned int frac_c = Complement_of_2(a.u.sign, frac_a) + Complement_of_2(b.u.sign, frac_b >> nbs);
                unsigned int overflow = frac_c >> 31 != c.u.sign;
                frac_c = overflow ? frac_c >> 1 : frac_c;
                c.u.fraction = IEEE754_encode(Complement2TrueCode(c.u.sign, frac_c << 1), 0x00000000);
                c.u.exponent = b.u.exponent + overflow;
            }
            } break;
        case '-': {
            b.u.sign = ~b.u.sign;
            c.f = calc_IEEE754(a.f, b.f, '+');
            } break;
        case '*': {
            c.f = a.f * b.f;
            unsigned long int frac_c = (
                (unsigned long int)frac_a * (unsigned long int)frac_b
            ) >> 1; /* Point left shift 1-bit */
            c.u.exponent = a.u.exponent + b.u.exponent - 127 + 1
                         - number_of_bits_to_shift((unsigned int)(frac_c >> 32));
            c.u.fraction = IEEE754_encode((unsigned int)(frac_c >> 32) >> 1, /* Convert 
                                           Positive Unsigned Integer  to Signed Integer */
                                          (unsigned int)(frac_c & 0x00000000FFFFFFFF));
            c.u.sign = a.u.sign ^ b.u.sign;
            } break;
        case '/': {
            printf("UnSupport\n");
            } break;
        default:
            break;
    }
    return c.f;    
}
