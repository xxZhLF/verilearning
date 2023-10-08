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
\begin{aligned}
    \left\{ \begin{aligned}
    c_{in,0} &= c_{in,0} \\
    c_{in,1} &= P_{0} + G_{0} \cdot c_{in,0} \\
    c_{in,2} &= P_{1} + G_{1} \cdot c_{in,1} \\
             &= P_{1} + G_{1} \cdot (P_{0} + G_{0} \cdot c_{in,0}) \\
             &= P_{1} + P_{0} \cdot G_{1} + G_{0} \cdot G_{1} \cdot c_{in,0} \\
\end{aligned} \right.
\end{aligned}
```
<!-- $$ -->