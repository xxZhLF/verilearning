RISC-V 译码器

指令类型一共6种：R，I，S，B，U，J。

```math
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
    }}}} \quad \textup{R-Type}
```

```math
     % I-Type
    \underset{12~btis}{\overset{31:20}{\underline{\overline{
    | ~~~~~~~~~~~~ ~_{~~~~~~~}
      \textup{imm}_{11:0}
      ~~~~~~~~~~~~ ~_{~~~~~~~}
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
    }}}} \quad \textup{I-Type}
```

```math
    % S-Type
    \underset{7~btis}{\overset{31:25}{\underline{\overline{
    | ~~~~~~~ 
      \textup{imm}_{11:5}
      ~~~~~~~ ~_{~~~~~~}
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
    | ~~~~~ ~_{~~}
      \textup{imm}_{4:0}
      ~~~~~ ~_{~~~~~~~}
    }}}}
    \underset{7~btis}{\overset{6:0}{\underline{\overline{
    | ~~~~~~
      \textup{op}
      ~~~~~~ |
    }}}} \quad \textup{S-Type}
```

```math
    % B-Type
    \underset{7~btis}{\overset{31:25}{\underline{\overline{
    | ~~~~~~~
      \textup{imm}_{12},~_{10:5}
      ~~~~~~~
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
    | ~~~~~ ~_{~~}
      \textup{imm}_{4:1}, ~_{11}
      ~~~~~
    }}}}
    \underset{7~btis}{\overset{6:0}{\underline{\overline{
    | ~~~~~~
      \textup{op}
      ~~~~~~ |
    }}}} \quad \textup{B-Type}
```

```math
    % U-Type
    \underset{5~btis}{\overset{31:12}{\underline{\overline{
    | ~~~~~~~~~~~~~~~~~~~~ ~_{~~~~}
      \textup{imm}_{31:12}
      ~~~~~~~~~~~~~~~~~~~~ ~_{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
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
    }}}} \quad \textup{U-Type}
```

```math
    % J-Type
    \underset{5~btis}{\overset{31:12}{\underline{\overline{
    | ~~~~~~~~~~~~~~~~~~~~ ~_{~~~~}
      \textup{imm}_{20}, ~_{10:1}, ~_{11}, ~_{19:12}
      ~~~~~~~~~~~~~~~~~~~~ ~_{~~~~}
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
    }}}} \quad \textup{J-Type}
```
