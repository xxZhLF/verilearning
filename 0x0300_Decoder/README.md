RISC-V 译码器

指令类型一共6种：R，I，S，B，U，J。分别为：
- 「0110011」寄存器类型指令
- 「0010011」立即数类型指令
- 「0100011」写内存类型指令
- 「1100011」条件分支类型指令
- 「0110111」高位立即数加载指令
- 「1101111」无条件跳转指令

<table style="text-align:center">
  <tr>
    <th style="border:0;"></th>
    <th>31</th> <th>30</th> <th>29</th> <th>28</th> <th>27</th> <th>26</th> <th>25</th> <th>24</th> 
    <th>23</th> <th>22</th> <th>21</th> <th>20</th> <th>19</th> <th>18</th> <th>17</th> <th>16</th> 
    <th>15</th> <th>14</th> <th>13</th> <th>12</th> <th>11</th> <th>10</th> <th> 9</th> <th> 8</th> 
    <th> 7</th> <th> 6</th> <th> 5</th> <th> 4</th> <th> 3</th> <th> 2</th> <th> 1</th> <th> 0</th>
  </tr>
  <tr>
    <td style="border:0;">R</td>
    <td colspan="7">func7</td>
    <td colspan="5">rs2</td>
    <td colspan="5">rs1</td>
    <td colspan="3">func3</td>
    <td colspan="5">rd</td>
    <td colspan="7">op</td>
  </tr>
  <tr>
    <td style="border:0;">I</td>
    <td colspan="12">imm<sub>11:0</sub></td>
    <td colspan="5">rs1</td>
    <td colspan="3">func3</td>
    <td colspan="5">rd</td>
    <td colspan="7">op</td>
  </tr>
  <tr>
    <td style="border:0;">S</td>
    <td colspan="7">imm<sub>11:5</sub></td>
    <td colspan="5">rs2</td>
    <td colspan="5">rs1</td>
    <td colspan="3">func3</td>
    <td colspan="5">imm<sub>4:0</sub></td>
    <td colspan="7">op</td>
  </tr>
  <tr>
    <td style="border:0;">B</td>
    <td colspan="7">imm<sub>12, 10:5</sub></td>
    <td colspan="5">rs2</td>
    <td colspan="5">rs1</td>
    <td colspan="3">func3</td>
    <td colspan="5">imm<sub>4:1, 11</sub></td>
    <td colspan="7">op</td>
  </tr>
  <tr>
    <td style="border:0;">U</td>
    <td colspan="20">imm<sub>31:12</sub></td>
    <td colspan="5">rd</td>
    <td colspan="7">op</td>
  </tr>
  <tr>
    <td style="border:0;">J</td>
    <td colspan="20">imm<sub>20, 10:1, 11, 19:12</sub></td>
    <td colspan="5">rd</td>
    <td colspan="7">op</td>
  </tr>
</table>


