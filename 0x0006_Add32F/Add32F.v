`ifndef ADD_32BIT_FLOAT_V
`define ADD_32BIT_FLOAT_V

`include "../IPs_shared/IEEE754.v"
`include "../IPs_shared/Shift.v"
`include "../IPs_shared/Comparator.v"
`include "../IPs_shared/TC_converter.v"
`include "../0x0003_AdderLC32bit/AdderLC32bit.v"
`include "../0x0012_Sub32U/Sub32.v"

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

    wire        sft_tgt;
    wire [31:0] sft_nbs;
    IEEE754_exponent_process processor_e(
        .exp1(e[0]),
        .exp2(e[1]),
        .sft_tgt(sft_tgt),
        .sft_nbs(sft_nbs)
    );

    wire [31:0] sum_frac;
    IEEE754_fraction_process processor_f(
        .sign(s),
        .frac(f),
        .sft_tgt(sft_tgt),
        .sft_nbs(sft_nbs),
        .frac3rd(sum_frac)
    );

    IEEE754_compose compose(
        .fraction(sum_frac),
        .exponent(sft_tgt ? e[0] : e[1]),
        .float(sum)
    );

endmodule

module IEEE754_exponent_process(
    input  wire [31:0] exp1,
    input  wire [31:0] exp2,
    output wire        sft_tgt, /* exp1 > exp2 ? 1'b1 : 1'b0 */
    output wire [31:0] sft_nbs  /* Number of Bits to Shift */
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
        .diff(sft_nbs)
    );

    assign sft_tgt = `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b1 : 1'b0;
    /* (exp1 > exp2) => (frac2 << exp1-exp2) => (sft_frac = 1'b1) 
       (exp1 < exp2) => (frac1 << exp2-exp1) => (sft_frac = 1'b0) */

endmodule

module IEEE754_fraction_process(
    input  wire        sign[1:0],
    input  wire [31:0] frac[1:0],
    input              sft_tgt,
    input  wire [31:0] sft_nbs,
    output wire [31:0] frac3rd
);

    wire [31:0] prepro [1:0];
    assign prepro[0] = {sign[0], frac[0][23:0], 7'b0};
    assign prepro[1] = {sign[1], frac[1][23:0], 7'b0};

    wire [31:0] frac1, frac2;
    assign frac1 = sft_tgt ? prepro[0] : prepro[1];
    ShiftR32U shift(
        .n(sft_nbs[7:0]),
        .in(sft_tgt ? prepro[1] : prepro[0]),
        .out(frac2)
    );

    wire [31:0] frac1C, frac2C;
    TCC32 t2c_0(
        .T(frac1),
        .C(frac1C)
    ), t2c_1(
        .T(frac2),
        .C(frac2C)
    );

    wire [31:0] frac3C;
    Add32 adder(
        .op1(frac1C),
        .op2(frac2C),
        .sum(frac3C)
    );

    CTC32 c2t(
        .C(frac3C),
        .T(frac3rd)
    );

endmodule

`endif 