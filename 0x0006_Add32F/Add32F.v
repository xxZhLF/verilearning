`ifndef ADD_32BIT_FLOAT_V
`define ADD_32BIT_FLOAT_V

`include "IEEE754.v"
`include "../IPs_shared/Shift.v"
`include "../0x0003_AdderLC32bit/AdderLC32bit.v"

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

    wire [31:0] sft_nbit;
    wire        sft_frac;
    IEEE754_analyzer analyzer(
        .exp1(e[0]),
        .exp2(e[1]),
        .sft_nbit(sft_nbit),
        .sft_frac(sft_frac)
    );

    wire [31:0] sft_out;
    ShiftL32U shift(
        .n(sft_nbit[7:0]),
        .in(sft_frac ? f[1] : f[0]),
        .out(sft_out)
    );

    // reg         USELESS;
    // wire [31:0] f_sum;
    // AdderLC32bit adder(
    //     .op1(~sft_frac ? f[1] : f[0]),
    //     .op2(sft_out),
    //     .cin(1'b0),
    //     .sum(f_sum),
    //     .cout(USELESS)
    // );

    // IEEE754_compose compose(
    //     .fraction(f_sum),
    //     .exponent(~sft_frac ? e[1] : e[0]),
    //     .float(sum)
    // );

endmodule

module IEEE754_analyzer(
    input  wire [31:0] exp1,
    input  wire [31:0] exp2,
    output wire [31:0] sft_nbit,
    output wire        sft_frac
);

    wire [ 1:0] cmp_res;
    Cmp32U cmp(
        .op1(exp1),
        .op2(exp2),
        .res(cmp_res)
    );

    Sub32 subtractor(
        .op1(`isEQ(cmp_res, `OP1_GT_OP2) ? exp1 : exp2),
        .op2(`isEQ(cmp_res, `OP1_GT_OP2) ? exp2 : exp1),
        .diff(sft_nbit)
    );

    assign sft_frac = `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b1 : 1'b0;
    /*(exp1 > exp2) => (frac2 << exp1-exp2) => (sft_frac = 1'b1)
      (exp1 < exp2) => (frac1 << exp2-exp1) => (sft_frac = 1'b0)*/

endmodule

`endif 