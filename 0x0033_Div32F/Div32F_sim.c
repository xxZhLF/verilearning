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

    float array[] = {0.07, 0.0007, 100, 1000, 5.734794};

    Prepare4Show();

    show_calc_div(array[0], array[1]);
    show_calc_div(array[2], array[3]);
    show_calc_div(array[4], array[1]);
    show_calc_div(array[4], array[0]);

    CleanUp4Show();

    return 0;
}