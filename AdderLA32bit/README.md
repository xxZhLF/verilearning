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

    c_{in,N} &= \left( P_{N-1} + \sum_{i=0}^{N-2} P_{i} \cdot \prod_{j=i+1}^{N-1} G_{j} \right) + \left( c_{in,0} \cdot \prod_{j=0}^{N-1} G_{j} \right) 
\end{aligned} \right.
```
<!-- $$ -->