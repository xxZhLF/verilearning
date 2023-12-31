`ifndef ADD_32BIT_V
`define ADD_32BIT_V

module Add32(
    input wire  [31:0] op1,
    input wire  [31:0] op2,
    output wire [31:0] sum
);

    reg ZERO = 1'b0;
    reg NULL;

    AdderLC32bit adder(
        .op1(op1),
        .op2(op2),
        .cin(ZERO),
        .sum(sum),
        .cout(NULL)
    );

endmodule

`endif 