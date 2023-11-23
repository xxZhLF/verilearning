int main(int argc, char* argv[]){
    unsigned int buff[16] = {0};
    for (unsigned int i = 0; i < 16; ++i){
        if (i < 8) {
            buff[i] = i;
        } else {
            buff[i] = buff[i-8] + i;
        }
    }
    return 0;
}