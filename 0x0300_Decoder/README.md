RISC-V 译码器

指令类型一共6种：R，I，S，B，U，J。

```math
\begin{aligned}
    % R-Type
    \underset{7~btis}{\overset{31:25}{\underline{\overline{
    | ~~~~~~~ ~_{~~~~~}
      \textup{func7}
      ~~~~~~~ ~_{~~~~~}
    }}}}
    \underset{5~btis}{\overset{24:20}{\underline{\overline{
    | ~~~~~
      \textup{rs2}
      ~~~~~
    }}}}
    \underset{5~btis}{\overset{19:15}{\underline{\overline{
    | ~~~~~
      \textup{rs1}
      ~~~~~
    }}}}
    \underset{3~btis}{\overset{14:12}{\underline{\overline{
    | ~~~
      \textup{func3}
      ~~~
    }}}}
    \underset{5~btis}{\overset{11:7}{\underline{\overline{
    | ~~~~~ ~_{~~~~~~~~~~}
      \textup{rd}
      ~~~~~ ~_{~~~~~~~~~~}
    }}}}
    \underset{7~btis}{\overset{6:0}{\underline{\overline{
    | ~~~~~~
      \textup{op}
      ~~~~~~ |
    }}}} & \quad \textup{R-Type}
\end{aligned}
```
