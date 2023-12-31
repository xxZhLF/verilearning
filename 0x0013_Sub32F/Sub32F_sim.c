#include "../c_sim/IEEE754_sim.h"

int main(int argc, char* argv[]){

    show_contrastbl();

    if (LSB != endian_check()){
        printf("Error: This machin is Big Endian! \n");
        return -1;
    }

    float array[] = {0.7, -0.7, 0.04, -0.04, 77.44, 33.66, -44.77, -66.33};

    for (unsigned char i = 0; i < sizeof(array) / sizeof(float); ++i){
        show_FLOAT2BIN(array[i], '\n');
    }   printf("\n");

    Prepare4Show();

    show_calc_sub(array[0], array[2]);
    show_calc_sub(array[1], array[2]);
    show_calc_sub(array[1], array[3]);
    show_calc_sub(array[0], array[3]);
    show_calc_sub(array[4], array[5]);
    show_calc_sub(array[6], array[7]);
    show_calc_sub(array[4], array[6]);
    show_calc_sub(array[7], array[5]);

    CleanUp4Show();

    return 0;
}