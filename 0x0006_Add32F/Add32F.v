`ifndef ADD_32BIT_FLOAT_V
`define ADD_32BIT_FLOAT_V

`include "IEEE754.v"

module Add32F(
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [31:0] sum
);

    wire        s[1:0];
    wire [31:0] f[1:0], e[1:0];
    IEEE754_decompo decompo0(
        .float(op1),
        .fraction(f[0]),
        .exponent(e[0]),
        .sign(s[0])
    ), decompo1(
        .float(op2),
        .fraction(f[1]),
        .exponent(e[1]),
        .sign(s[1])
    );

    wire        sft_frac;
    wire [ 5:0] sft_nbit;
    IEEE754_analyzer analyzer(
        .exp1(e[0]),
        .exp2(e[1]),
        .sft_frac(sft_frac),
        .sft_nbit(sft_nbit)
    );

endmodule

`endif 