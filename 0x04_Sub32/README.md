基于 32-Bit 先行进位加法器的减法器。

```math
\begin{aligned}
    A - B &= A + (-B) \\
          &= A + B_{complement}
\end{aligned}
```

例如：
```math
\begin{matrix}
    &7_{10} &- &4_{10} &= &00000111_{2,T} &- &00000100_{2,T} &  &     \\
    &       &  &       &= &00000111_{2,T} &+ &10000100_{2,T} &  &     \\
    &       &  &       &= &00000111_{2,T} &+ &11111100_{2,C} &  &     \\
    &       &  &       &= &00000011_{2,C} &= &00000011_{2,T} &= &~3_{10}
\\\\
    &4_{10} &- &7_{10} &= &00000100_{2,T} &- &00000111_{2,T} &  &     \\
    &       &  &       &= &00000100_{2,T} &+ &10000111_{2,T} &  &     \\
    &       &  &       &= &00000100_{2,T} &+ &11111001_{2,C} &  &     \\
    &       &  &       &= &11111101_{2,C} &= &10000011_{2,T} &= &-3_{10}
\end{matrix}
```

原码（T） -> 补码（C）：符号位保持不变，数据位按位取反后+1。