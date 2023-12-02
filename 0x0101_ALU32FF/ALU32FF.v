`ifndef FULL_FUNCTION_ARITHMETIC_LOGICAL_UNIT_32BIT_V
`define FULL_FUNCTION_ARITHMETIC_LOGICAL_UNIT_32BIT_V

`include "CtlALU.v"
`include "../IPs_shared/universal4inc.v"

module ALU32FF (
    input  wire [15:0] ctl,
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [31:0] res
);

    wire        cout;
    wire [31:0] res_of_add_or_sub;
    AdderLC32bit adder(
        .op1(op1),
        .op2(ctl[1] ? NOT(op2) : op2),
        .cin(ctl[1]),
        .sum(res_of_add_or_sub),
        .cout(cout)
    );

    wire [63:0] res_of_mul;
    MulBT32S multipiler(
        .op1(op1),
        .op2(op2),
        .res(res_of_mul)
    );

    wire [31:0]  res_of_div_quoti;
    wire [31:0]  res_of_div_remai;
    Div32U divider(
        .dived(op1),
        .divor(op2),
        .quoti(res_of_div_quoti),
        .remai(res_of_div_remai)
    );

    wire [ 1:0] res_of_cmp_u;
    Cmp32S comparater(
        .op1(ctl[7] ? op1 : {1'b0, op1[30:0]}),
        .op2(ctl[7] ? op2 : {1'b0, op2[30:0]}),
        .res(res_of_cmp_u)
    );

    wire [ 1:0] res_of_cmp_s;
    assign res_of_cmp_s =  ~(op1[31]  ^   op2[31]) ? res_of_cmp_u :
                           (~op1[31]) &   op2[31]  ? `OP1_LT_OP2 :
                             op1[31]  & (~op2[31]) ? `OP1_GT_OP2 : 2'bZZ;

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

    function [31:0] AND (input [31:0] op1, input [31:0] op2);
        return op1 & op2;
    endfunction

    function [31:0]  OR (input [31:0] op1, input [31:0] op2);
        return op1 | op2;
    endfunction

    function [31:0] XOR (input [31:0] op1, input [31:0] op2);
        return op1 ^ op2;
    endfunction

    function [31:0] NOT (input [31:0] op);
        return ~op;
    endfunction

    assign res = `isEQ(ctl, `ALU_CTL_ADD)    ? res_of_add_or_sub : 
                 `isEQ(ctl, `ALU_CTL_SUB)    ? res_of_add_or_sub :
                 `isEQ(ctl, `ALU_CTL_MUL)    ? res_of_mul[31: 0] :
                 `isEQ(ctl, `ALU_CTL_DIV)    ? res_of_div_quoti :
                 `isEQ(ctl, `ALU_CTL_REM)    ? res_of_div_remai : 
                 `isEQ(ctl, `ALU_CTL_MULH)   ? res_of_mul[63:32] :
                 `isEQ(ctl, `ALU_CTL_SLT)    ? {31'b0, `isEQ(res_of_cmp_s, `OP1_LT_OP2)} :
                 `isEQ(ctl, `ALU_CTL_SLTU)   ? {31'b0, `isEQ(res_of_cmp_u, `OP1_LT_OP2)} :
                 `isEQ(ctl, `ALU_CTL_SLL)    ? res_of_shiftL_u :
                 `isEQ(ctl, `ALU_CTL_SRL)    ? res_of_shiftR_u :
                 `isEQ(ctl, `ALU_CTL_SRA)    ? res_of_shiftR_s :
                 `isEQ(ctl, `ALU_CTL_AND)    ? AND(op1, op2) :
                 `isEQ(ctl, `ALU_CTL_OR)     ?  OR(op1, op2) :
                 `isEQ(ctl, `ALU_CTL_XOR)    ? XOR(op1, op2) :
                 `isEQ(ctl, `ALU_CTL_NOT)    ? NOT(op1) : 32'hZZZZZZZZ;

endmodule

`endif 