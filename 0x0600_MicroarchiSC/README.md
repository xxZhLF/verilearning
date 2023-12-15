单周期指令架构

逻辑区分：组合逻辑 \
（所有模块均已组合逻辑方式连接，
时钟用于驱动寄存器文件与PC。）

测试代码：
```c
int buff[16];
int main(int argc, char* argv[]){
    int bias = -14;
    for (unsigned int i = 0; i < 16; ++i){
        if (i < 8) {
            buff[i] = i + (bias >> 1);
        } else {
            buff[i] = (buff[i-8] * i) << 3;
        }
    }
    return 0;
}
```

---

**神秘BUG：**（乘法器里有什么奇怪的问题？） \
将`<<`修改为`*`的话，`else`计算结果与预期不符。

Me的水平有限，目前暂时无法找出原因，跪求好心人帮忙调试。

TODO：找出神秘BUG。