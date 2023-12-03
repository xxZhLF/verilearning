int buff[16];
int main(int argc, char* argv[]){
    int bias = -14;
    for (unsigned int i = 0; i < 16; ++i){
        if (i < 8) {
            buff[i] = i + (bias >> 1);
        } else {
            buff[i] = (buff[i-8] + i) * 3;
        }
    }
    return 0;
}