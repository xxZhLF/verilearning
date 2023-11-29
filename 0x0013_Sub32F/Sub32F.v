`ifndef SUB_32BIT_FLOAT_V
`define SUB_32BIT_FLOAT_V

module Sub32F(
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [31:0] diff
);

    Add32F adder(
        .op1(op1),
        .op2({~op2[31], op2[30:0]}),
        .sum(diff)
    );

endmodule

`endif 