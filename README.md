# verilearning
我的Verilog学习记录

工具链：
- Verilator
  - `sudo apt install verilator`
  - `git clone https://github.com/verilator/verilator.git`
    1. `cd verilator`
    2. `unset VERILATOR_ROOT`
    3. `git checkout stable`
    4. `autoconf`
    5. `./configure --prefix=/opt/verilator`
    6. `make -j N` N = 1, 2, 3, 4...
    7. `sudo make install`
- GTKWave
  - `sudo apt install gtkwave`
