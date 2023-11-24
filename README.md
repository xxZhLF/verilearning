# verilearning
我的Verilog学习记录

工具链：
- Verilator ([Home](https://verilator.org/guide/latest/index.html))
  - `sudo apt install verilator`
  - `git clone https://github.com/verilator/verilator.git`
    1. `cd verilator`
    2. `unset VERILATOR_ROOT`
    3. `git checkout stable`
    4. `autoconf`
    5. `./configure --prefix=/opt/verilator`
    6. `make -j N` N = 1, 2, 3, 4...
    7. `sudo make install`
- GTKWave ([Home](https://gtkwave.sourceforge.net/))
  - `sudo apt install gtkwave`
- Xilinx Vivado (Optional)

[RISC-V GNU Toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain)
```bash
$ git clone https://github.com/riscv-collab/riscv-gnu-toolchain.git
$ ./configure --with-arch=rv32i --with-abi=ilp32 --prefix=/opt/riscv
$ sudo make linux  
```

[LLVM](https://llvm.org/docs/GettingStarted.html)
```bash
$ git clone https://github.com/llvm/llvm-project.git
$ mkdir llvm-project/build
$ cd llvm-project/build
$ cmake -G "Unix Makefiles" \
        -DCMAKE_BUILD_TYPE="Release" \
        -DLLVM_ENABLE_PROJECTS="clang;lld" \
        -DLLVM_TARGETS_TO_BUILD="RISCV" \
        -DLLVM_DEFAULT_TARGET_TRIPLE='riscv32-unknown-unknown-elf' \
        -DCMAKE_INSTALL_PREFIX="/opt/llvm-riscv" ../llvm
$ make -j8
$ sudo make install
```

<details>

<summary>内存不足时</summary>

错误信息：
```bash
c++: fatal error: Killed signal terminated program cc1plus
```

创建交换空间：
```bash
sudo mkdir -p /var/cache/swap                                    // 1st time only
sudo dd if=/dev/zero of=/var/cache/swap/swap0 bs=64M count=64    // 1st time only
sudo chmod 0600 /var/cache/swap/swap0                            // 1st time only
sudo mkswap /var/cache/swap/swap0                                // Everytime
sudo swapon /var/cache/swap/swap0                                // Everytime
sudo swapon -s                                                   // Option
```

在这里重新 `make`

释放交换空间：
```bash
sudo swapoff /var/cache/swap/swap0                               // Everytime
sudo rm /var/cache/swap/swap0                                    // Everytime
sudo swapoff -a                                                  // Everytime
```

</details>

---

git promopt 优化： [here](https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh)
```bash
wget https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
```

---

关于目录结构： \
$`\qquad\qquad\quad 0\textup{x}[A][B][C][D]\_[E]`$
- $`A`$: 保留
- $`B`$: 功能目录
- $`C`$: 逻辑功能
- $`D`$: 逻辑实现
- $`E`$: 实装名称