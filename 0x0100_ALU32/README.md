32-Bit 算术逻辑运算单元（Arithmetic Logical Unit）

逻辑区分：组合逻辑

包含以下逻辑电路： \
32-Bit加法器$`\times 1`$，
1-Bit与门$`\times 32`$，
1-Bit或门$`\times 32`$，
32-Bit非门$`\times 1`$

功能选择：
| Ctl $`_{1:0}`$ | Func |
|:-:|:--|
| $`00`$ | Add      |
| $`01`$ | Subtract |
| $`10`$ | AND      |
| $`11`$ | OR       |

Ctl\[0\] 作为减法标志，用于判断是否取反
连接加法器进位引脚，用于判断是否$`+1`$