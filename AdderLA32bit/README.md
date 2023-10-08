32-Bit 先行进位加法器（Carry-Lookahade Adder）

$$
\begin{aligned}
    &\left\{ \begin{aligned}
        sum &= op_{1} \oplus op_{2} \oplus c_{in} \\
        c_{out} &= op_{1} \cdot op_{2} + (op1 \oplus op2) \cdot c_{in}
    \end{aligned} \right. \\
    &\underset{
        G = op1 \cdot op2
    }{
        \overset{
            P = op1 \oplus op2
        }{
            \Longrightarrow
        }
    } \qquad\left\{ \begin{aligned}
        sum &= P \oplus c_{in} \\
        c_{out} &= G + P \cdot c_{in} \quad \ast
    \end{aligned} \right.
\end{aligned}
$$