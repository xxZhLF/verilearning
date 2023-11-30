`ifndef FULL_FUNCTION_ARITHMETIC_LOGICAL_UNIT_32BIT_V
`define FULL_FUNCTION_ARITHMETIC_LOGICAL_UNIT_32BIT_V

`include "CtrlALU.v"
`include "../IPs_shared/universal4inc.v"

module ALU32FF (
    input  wire [31:0] ctrl,
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [31:0] res
);

    wire [31:0] res_of_add;
    Add32 adder(
        .op1(op1),
        .op2(op2),
        .sum(res_of_add)
    );

    wire [31:0] res_of_sub;
    Sub32 subtractor(
        .op1(op1),
        .op2(op2),
        .diff(res_of_sub)
    );

    wire [63:0]  res_of_mul_s;
    MulBT32S multipiler_s(
        .op1(op1),
        .op2(op2),
        .res(res_of_mul_s)
    );

    wire [31:0] op1_T;
    CTC32 c2t(
        .C(op1),
        .T(op1_T)
    );

    wire [63:0]  res_of_mul_u;
    MulWL32U multipiler_u(
        .op1(`isEQ(ctrl, `ALU_CTRL_MULHSU) ? {1'b0, op1_T[30:0]} : op1),
        .op2(op2),
        .res(res_of_mul_u)
    );

    wire [63:0] res_of_mul_u_T;
    TCC64 t2c(
        .T({op1[31], res_of_mul_u[62:0]}),
        .C(res_of_mul_u_T)
    );

    wire [31:0]  res_of_div_s_quoti;
    wire [31:0]  res_of_div_s_remai;
    Div32S divider_s(
        .dived(op1),
        .divor(op2),
        .quoti(res_of_div_s_quoti),
        .remai(res_of_div_s_remai)
    );

    wire [31:0]  res_of_div_u_quoti;
    wire [31:0]  res_of_div_u_remai;
    Div32U divider_u(
        .dived(op1),
        .divor(op2),
        .quoti(res_of_div_u_quoti),
        .remai(res_of_div_u_remai)
    );

    wire [ 1:0] res_of_cmp_s;
    Cmp32S cmp_s(
        .op1(op1),
        .op2(op2),
        .res(res_of_cmp_s)
    );

    wire [ 1:0] res_of_cmp_u;
    Cmp32S cmp_u(
        .op1(op1),
        .op2(op2),
        .res(res_of_cmp_u)
    );

    wire [31:0] res_of_shiftL_u;
    ShiftL32U shiftL_u(
        .n(op2[7:0]),
        .in(op1),
        .out(res_of_shiftL_u)
    );

    wire [31:0] res_of_shiftR_u;
    ShiftR32U shiftR_u(
        .n(op2[7:0]),
        .in(op1),
        .out(res_of_shiftR_u)
    );

    wire [31:0] res_of_shiftR_s;
    ShiftR32S shiftR_s(
        .n(op2[7:0]),
        .in(op1),
        .out(res_of_shiftR_s)
    );

    function [31:0]  OR (input [31:0] op1, input [31:0] op2);
        return op1 | op2;
    endfunction

    function [31:0] AND (input [31:0] op1, input [31:0] op2);
        return op1 & op2;
    endfunction

    function [31:0] XOR (input [31:0] op1, input [31:0] op2);
        return op1 ^ op2;
    endfunction

    assign res = `isEQ(ctrl, `ALU_CTRL_ADD)    ? res_of_add : 
                 `isEQ(ctrl, `ALU_CTRL_SUB)    ? res_of_sub :
                 `isEQ(ctrl, `ALU_CTRL_MUL)    ? res_of_mul_s[31: 0] :
                 `isEQ(ctrl, `ALU_CTRL_DIV)    ? res_of_div_s_quoti :
                 `isEQ(ctrl, `ALU_CTRL_REM)    ? res_of_div_s_remai : 
                 `isEQ(ctrl, `ALU_CTRL_DIVU)   ? res_of_div_u_quoti :
                 `isEQ(ctrl, `ALU_CTRL_REMU)   ? res_of_div_u_remai :
                 `isEQ(ctrl, `ALU_CTRL_MULH)   ? res_of_mul_s[63:32] :
                 `isEQ(ctrl, `ALU_CTRL_MULHU)  ? res_of_mul_u[63:32] :
                 `isEQ(ctrl, `ALU_CTRL_MULHSU) ? res_of_mul_u_T[63:32] :
                 `isEQ(ctrl, `ALU_CTRL_SLT)    ? {31'b0, `isEQ(res_of_cmp_s, `OP1_LT_OP2)} :
                 `isEQ(ctrl, `ALU_CTRL_SLTU)   ? {31'b0, `isEQ(res_of_cmp_u, `OP1_LT_OP2)} :
                 `isEQ(ctrl, `ALU_CTRL_SLL)    ? res_of_shiftL_u :
                 `isEQ(ctrl, `ALU_CTRL_SRL)    ? res_of_shiftR_u :
                 `isEQ(ctrl, `ALU_CTRL_SRA)    ? res_of_shiftR_s :
                 `isEQ(ctrl, `ALU_CTRL_OR)     ?  OR(op1, op2) :
                 `isEQ(ctrl, `ALU_CTRL_AND)    ? AND(op1, op2) :
                 `isEQ(ctrl, `ALU_CTRL_XOR)    ? XOR(op1, op2) : 32'hZZZZZZZZ;

endmodule

`endif 