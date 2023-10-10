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

---

git promopt 优化： [here](https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh)
```bash
wget https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
```

---

关于目录结构： \
$`\qquad\qquad\quad 0\textup{x}[A][B][C][D]_[E]`$
- $`A`$: 保留
- $`B`$: 功能目录
- $`C`$: 逻辑功能
- $`D`$: 逻辑实现
- $`E`$: 实装名称