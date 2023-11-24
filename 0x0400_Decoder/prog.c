int buff[16];
int main(int argc, char* argv[]){
    for (unsigned int i = 0; i < 16; ++i){
        if (i < 8) {
            buff[i] = i + 7;
        } else {
            buff[i] = buff[i-8] + i;
        }
    }
    return 0;
}