`ifndef ARITHMETIC_LOGICAL_UNIT_32BIT_V
`define ARITHMETIC_LOGICAL_UNIT_32BIT_V

`include "../IPs_shared/MacroFunc.v"

module ALU32 (
    input  wire [ 1:0] ctl,
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [31:0] res
);

    function [31:0] NOT (input [31:0] val);
        return ~val;
    endfunction

    function [31:0] AND (input [31:0] op1, input [31:0] op2);
        return op1 & op2;
    endfunction

    function [31:0]  OR (input [31:0] op1, input [31:0] op2);
        return op1 | op2;
    endfunction

    wire        USELESS;
    wire [31:0] sum;
    AdderLC32bit adder(
        .op1(op1),
        .op2(ctl[0] ? NOT(op2) : op2),
        .cin(ctl[0]),
        .sum(sum),
        .cout(USELESS)
    );

    assign res = `isEQ(ctl, 2'b00) |
                 `isEQ(ctl, 2'b01) ? sum :
                 `isEQ(ctl, 2'b10) ? AND(op1, op2) : 
                 `isEQ(ctl, 2'b11) ?  OR(op1, op2) : 32'hZZZZZZZZ;

endmodule

`endif 