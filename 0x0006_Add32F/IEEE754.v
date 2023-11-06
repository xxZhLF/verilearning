`ifndef IEEE754_V
`define IEEE754_V

`include "../IPs_shared/Comparator.v"
`include "../IPs_shared/MacroFunc.v"
`include "../0x0003_AdderLC32bit/AdderLC32bit.v"

module IEEE754_decompo(
    input  wire [31:0] float,
    output wire [31:0] fraction,
    output wire [31:0] exponent,
    output wire        sign
);

    assign sign = float[31];

    assign fraction = {1'b1, float[22: 0],  8'b0};
    assign exponent = {      24'b0, float[30:23]};

endmodule


module IEEE754_compose(
    input  wire [31:0] fraction,
    input  wire [31:0] exponent,
    output wire [31:0] float
);



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

    reg         USELESS;
    AdderLC32bit subtractor(
        .op1(`isEQ(cmp_res, `OP1_GT_OP2) ?  exp1 :  exp2),
        .op2(`isEQ(cmp_res, `OP1_GT_OP2) ? ~exp2 : ~exp1),
        .cin(1'b1),
        .sum(sft_nbit),
        .cout(USELESS)
    );

    assign sft_frac = `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b1 : 1'b0;
    /*(exp1 > exp2) => (frac2 << exp1-exp2) => (sft_frac = 1'b1)
      (exp1 < exp2) => (frac1 << exp2-exp1) => (sft_frac = 1'b0)*/

endmodule

`endif 