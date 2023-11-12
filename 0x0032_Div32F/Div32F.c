#include "../IPs_shared/IEEE754_sim.h"

int main (int argc, char* argv[]){

    printf("\n");
    char* l1 = "+--------------------------------------+";
    char* hd = "|               CONTRAST               |";
    char* dl = "+---------+----------------------------+";
    printf("%s\n%s\n", l1, hd);
    for (unsigned int i = 1; i <= 23; ++i){printf("%s\n", dl);
        printf("| 2^(-%-2d) | %.24f |\n", i, 1.0 / (1 << i));
    }   printf("%s\n", dl);
    printf("\n");

    if (LSB != endian_check()){
        printf("Error: This machin is Big Endian! \n");
        return -1;
    }

    float array[] = {0.0007, 8192.5625, 0.7, -0.7, 70, -70};

    Prepare4Show();

    show_calc_div(array[0], array[1]);
    show_calc_div(array[0], array[2]); 
    show_calc_div(array[0], array[3]); 
    show_calc_div(array[0], array[4]);
    show_calc_div(array[0], array[5]);
    show_calc_div(array[2], array[2]);
    show_calc_div(array[2], array[3]);
    show_calc_div(array[3], array[3]);
    show_calc_div(array[3], array[3]);
    show_calc_div(array[4], array[4]);
    show_calc_div(array[4], array[5]);
    show_calc_div(array[5], array[5]);

    CleanUp4Show();

    return 0;
}