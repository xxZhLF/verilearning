32-Bit 先行进位加法器（Carry-Lookahade Adder）

<!-- $$ -->
```math
\begin{aligned}
    &\left\{ \begin{aligned}
        sum &= op_{1} \oplus op_{2} \oplus c_{in} \\
        c_{out} &= op_{1} \cdot op_{2} + (op_{1} \oplus op_{S}) \cdot c_{in}
    \end{aligned} \right. \\
    &\underset{
        G = op_{1} \cdot op_{2}
    }{
        \overset{
            P = op_{S} \oplus op_{2}
        }{
            \Longrightarrow
        }
    } \qquad\left\{ \begin{aligned}
        sum &= P \oplus c_{in} \\
        c_{out} &= G + P \cdot c_{in} \quad \ast
    \end{aligned} \right.
\end{aligned}
```
<!-- $$ -->

由，标「*」处的公式便可，提前计算出所有位的进位值。

<!-- $$ -->
```math
    \left\{ \begin{aligned}
    c_{in,0} &= c_{in,0} \\
    c_{in,1} &= P_{0} + G_{0} \cdot c_{in,0} \\
    c_{in,2} &= P_{1} + G_{1} \cdot c_{in,1} \\
             &= P_{1} + G_{1} \cdot (P_{0} + G_{0} \cdot c_{in,0}) \\
             &= P_{1} + P_{0} \cdot G_{1} + G_{0} \cdot G_{1} \cdot c_{in,0} \\
    c_{in,3} &= P_{2} + G_{2} \cdot c_{in,1} \\
             &= P_{2} + G_{2} \cdot (P_{1} + P_{0} \cdot G_{1} + G_{0} \cdot G_{1} \cdot c_{in,0}) \\
             &= P_{2} + P_{1} \cdot G_{2} + P_{0} \cdot G_{1} \cdot G_{2} + G_{0} \cdot G_{1} \cdot G_{2} \cdot c_{in,0} \\
    c_{in,4} &= P_{3} + G_{3} \cdot c_{in,3} \\
             &= P_{3} + G_{3} \cdot (P_{2} + P_{1} \cdot G_{2} + P_{0} \cdot G_{1} \cdot G_{2} + G_{0} \cdot G_{1} \cdot G_{2} \cdot c_{in,0}) \\
             &= P_{3} + P_{2} \cdot G_{3} + P_{1} \cdot G_{2} \cdot G_{3} + P_{0} \cdot G_{1} \cdot G_{2} \cdot G_{3} + G_{0} \cdot G_{1} \cdot G_{2} \cdot G_{3} \cdot c_{in,0} \\
             &= P_{3} + \sum_{i=0}^{2} P_{i} \cdot \prod_{j=i+1}^{3} G_{j} + c_{in,0} \cdot \prod_{j=0}^{3} G_{j} \\
             &\quad\vdots \\
    c_{in,N} &= P_{N-1} + \sum_{i=0}^{N-2} P_{i} \cdot \prod_{j=i+1}^{N-1} G_{j} + c_{in,0} \cdot \prod_{kj=0}^{N-1} G_{k}
\end{aligned} \right.
```
<!-- $$ -->