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

#define number_of_bits_to_shift(fraction) \
( \
  /*((unsigned int)1 << 31) & (unsigned int)fraction ? Sign Bit     :*/ \
    ((unsigned int)1 << 30) & (unsigned int)fraction ? (signed)( 0) : \
    ((unsigned int)1 << 29) & (unsigned int)fraction ? (signed)( 1) : \
    ((unsigned int)1 << 28) & (unsigned int)fraction ? (signed)( 2) : \
    ((unsigned int)1 << 27) & (unsigned int)fraction ? (signed)( 3) : \
    ((unsigned int)1 << 26) & (unsigned int)fraction ? (signed)( 4) : \
    ((unsigned int)1 << 25) & (unsigned int)fraction ? (signed)( 5) : \
    ((unsigned int)1 << 24) & (unsigned int)fraction ? (signed)( 6) : \
    ((unsigned int)1 << 23) & (unsigned int)fraction ? (signed)( 7) : \
    ((unsigned int)1 << 22) & (unsigned int)fraction ? (signed)( 8) : \
    ((unsigned int)1 << 21) & (unsigned int)fraction ? (signed)( 9) : \
    ((unsigned int)1 << 20) & (unsigned int)fraction ? (signed)(10) : \
    ((unsigned int)1 << 19) & (unsigned int)fraction ? (signed)(11) : \
    ((unsigned int)1 << 18) & (unsigned int)fraction ? (signed)(12) : \
    ((unsigned int)1 << 17) & (unsigned int)fraction ? (signed)(13) : \
    ((unsigned int)1 << 16) & (unsigned int)fraction ? (signed)(14) : \
    ((unsigned int)1 << 15) & (unsigned int)fraction ? (signed)(15) : \
    ((unsigned int)1 << 14) & (unsigned int)fraction ? (signed)(16) : \
    ((unsigned int)1 << 13) & (unsigned int)fraction ? (signed)(17) : \
    ((unsigned int)1 << 12) & (unsigned int)fraction ? (signed)(18) : \
    ((unsigned int)1 << 11) & (unsigned int)fraction ? (signed)(19) : \
    ((unsigned int)1 << 10) & (unsigned int)fraction ? (signed)(20) : \
    ((unsigned int)1 <<  9) & (unsigned int)fraction ? (signed)(21) : \
    ((unsigned int)1 <<  8) & (unsigned int)fraction ? (signed)(22) : \
    ((unsigned int)1 <<  7) & (unsigned int)fraction ? (signed)(23) : \
    ((unsigned int)1 <<  6) & (unsigned int)fraction ? (signed)(24) : \
    ((unsigned int)1 <<  5) & (unsigned int)fraction ? (signed)(25) : \
    ((unsigned int)1 <<  4) & (unsigned int)fraction ? (signed)(26) : \
    ((unsigned int)1 <<  3) & (unsigned int)fraction ? (signed)(27) : \
    ((unsigned int)1 <<  2) & (unsigned int)fraction ? (signed)(28) : \
    ((unsigned int)1 <<  1) & (unsigned int)fraction ? (signed)(29) : \
    ((unsigned int)1 <<  0) & (unsigned int)fraction ? (signed)(30) : 31 \
)

#define rounding_bias(fraction) ( \
    ((unsigned int)fraction & ((unsigned int)1 << (6 + number_of_bits_to_shift(fraction)))) ? 1 : 0 \
)

#define smart_shift_4_encoder(fraction) (\
    /* Sign bit at 31 => Highest data bit at 30 => right shift 7 bits */  \
    (((unsigned int)fraction << number_of_bits_to_shift(fraction)) >> 7) + rounding_bias(fraction) \
)

#define IEEE754_decode(fraction) ( \
    /* Without sign bit => Highest data bit at 31 => left shift 8 bits */ \
    (0b00000000100000000000000000000000 | (unsigned int)(fraction)) << 8  \
)

#define IEEE754_encode(fraction) \
    (0b00000000011111111111111111111111 & smart_shift_4_encoder(fraction))

#define Complement_of_2(sign, fraction) ( \
        ((unsigned int)sign << 31) \
    | \
        ((unsigned int)sign == 0 ?  ((unsigned int)fraction >> 1) : \
                                  (~((unsigned int)fraction >> 1) + 1)) \
)

#define Complement2TrueCode(sign, fraction) ( \
        ((unsigned int)sign << 31) \
    | \
        ((unsigned int)sign == 0 ?  ((unsigned int)fraction >> 1) : \
                                  ~(((unsigned int)fraction >> 1) - 1)) \
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
    printf("= %7.2f + %7.2f (Error to CPU: %.30f)\n", a, b, fabs(c - (a + b))); \
    fprintf(fp, "%08X + %08X = %08X\n", *(unsigned int *)&a, *(unsigned int *)&b, *(unsigned int *)&c); \
} while(0)

#define show_calc_sub(a, b) do {\
    float c = calc_IEEE754(a, b, '-'); \
    show_FLOAT2BIN(c, ' '); \
    printf("= %7.2f - %7.2f (Error to CPU: %.30f)\n", a, b, fabs(c - (a - b))); \
    fprintf(fp, "%08X - %08X = %08X\n", *(unsigned int *)&a, *(unsigned int *)&b, *(unsigned int *)&c); \
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
        case '+':
            unsigned int nbs = a.u.exponent > b.u.exponent ? a.u.exponent - b.u.exponent : b.u.exponent - a.u.exponent;
            if (a.u.exponent > b.u.exponent){
                unsigned int frac_c = Complement_of_2(a.u.sign, frac_a) + Complement_of_2(b.u.sign, frac_b >> nbs);
                c.u.fraction = IEEE754_encode(Complement2TrueCode(frac_c >> 31, frac_c << 1));
                c.u.exponent = a.u.exponent - number_of_bits_to_shift(Complement2TrueCode(frac_c >> 31, frac_c << 1));
                c.u.sign = frac_c >> 31;
            } else {
                unsigned int frac_c = Complement_of_2(a.u.sign, frac_a >> nbs) + Complement_of_2(b.u.sign, frac_b);
                c.u.fraction = IEEE754_encode(Complement2TrueCode(frac_c >> 31, frac_c << 1));
                c.u.exponent = b.u.exponent - number_of_bits_to_shift(Complement2TrueCode(frac_c >> 31, frac_c << 1));
                c.u.sign = frac_c >> 31;
            }
            break;
        case '-':
            b.u.sign = ~b.u.sign;
            c.f = calc_IEEE754(a.f, b.f, '+');
            break;
        case '*':
            c.f = a.f * b.f;
            c.u.sign = a.u.sign ^ b.u.sign;
            c.u.exponent = a.u.exponent + b.u.exponent - (unsigned char )127;
            unsigned long int frac_c = (unsigned long int)frac_a 
                                     * (unsigned long int)frac_b;
            frac_c = frac_c >> 32;  /* Calc errors arise here */
            c.u.fraction = IEEE754_encode((unsigned int)frac_c);
            break;
        case '/':
            printf("Div: UnSupported\n");
            break;
        default:
            break;
    }
    return c.f;    
}
