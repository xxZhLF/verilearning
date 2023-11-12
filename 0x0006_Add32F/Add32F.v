`ifndef ADD_32BIT_FLOAT_V
`define ADD_32BIT_FLOAT_V

`include "../IPs_shared/IEEE754.v"
`include "../IPs_shared/Shift.v"
`include "../IPs_shared/Comparator.v"
`include "../IPs_shared/TC_converter.v"
`include "../0x0005_Add32/Add32.v"
`include "../0x0012_Sub32U/Sub32.v"

module Add32F(
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [31:0] sum
);

    wire        s[1:0];
    wire [23:0] f[1:0]; 
    wire [ 7:0] e[1:0];
    IEEE754_decompo decompo0(
        .float(op1),
        .fraction(f[0]),
        .exponent(e[0]),
        .sign(s[0])
    ),              decompo1(
        .float(op2),
        .fraction(f[1]),
        .exponent(e[1]),
        .sign(s[1])
    );

    wire [ 1:0] exp1_vs_exp2;
    wire [ 7:0] frac_sft_nbs;
    IEEE754_exponent_process processor_e(
        .exp1(e[0]),
        .exp2(e[1]),
        .exp1_vs_exp2(exp1_vs_exp2),
        .frac_sft_nbs(frac_sft_nbs) 
    );

    wire        fracoverflow;
    wire [31:0] fraction_raw;
    IEEE754_fraction_process processor_f(
        .sign(s),
        .frac(f),
        .exp1_vs_exp2(exp1_vs_exp2), 
        .frac_sft_nbs(frac_sft_nbs), 
        .frac_of(fracoverflow),
        .frac3rd(fraction_raw)
    );

    wire [ 7:0] exponent_cooked; 
    wire [22:0] fraction_cooked;
    IEEE754_smart_shift smart_shift(
        .exponent_i(`isEQ(exp1_vs_exp2, `OP1_GT_OP2) ? e[0] : e[1]),
        .fraction_i(fraction_raw),
        .overflow_i(fracoverflow),
        .exponent_o(exponent_cooked),
        .fraction_o(fraction_cooked)
    );

    IEEE754_compose compose(
        .sign(fraction_raw[31]),
        .exponent(exponent_cooked),
        .fraction(fraction_cooked),
        .float(sum)
    );

endmodule

module IEEE754_exponent_process(
    input  wire [ 7:0] exp1,
    input  wire [ 7:0] exp2,
    output wire [ 1:0] exp1_vs_exp2,
    output wire [ 7:0] frac_sft_nbs
);

    wire [ 1:0] cmp_res;
    Cmp32U cmp(
        .op1({24'b0, exp1}),
        .op2({24'b0, exp2}),
        .res(cmp_res)
    );

    wire [31:0] nbs;
    Sub32 subtractor(
        .op1(`isEQ(cmp_res, `OP1_GT_OP2) ? {24'b0, exp1} : {24'b0, exp2}),
        .op2(`isEQ(cmp_res, `OP1_GT_OP2) ? {24'b0, exp2} : {24'b0, exp1}),
        .diff(nbs)
    );

    assign {exp1_vs_exp2, frac_sft_nbs} = {cmp_res, nbs[7:0]};

endmodule

module IEEE754_fraction_process(
    input  wire        sign[1:0],
    input  wire [23:0] frac[1:0],
    input  wire [ 1:0] exp1_vs_exp2,
    input  wire [ 7:0] frac_sft_nbs,
    output wire        frac_of,
    output wire [31:0] frac3rd
);

    wire [ 1:0] frac1_vs_frac2;
    Cmp32U cmp(
        .op1({8'b0, frac[0]}),
        .op2({8'b0, frac[1]}),
        .res(frac1_vs_frac2)
    );

    /* sft_tgt is 1'b1 means:
               expornet[0] >  expornet[1] 
               fraction[1] should be shifted
       sft_tgt is 1'b0 means:
               expornet[0] <= expornet[1] 
               fraction[0] should be shifted
    */wire sft_tgt;
    assign sft_tgt = `isEQ(exp1_vs_exp2, `OP1_GT_OP2);

    wire [31:0] fracEX [1:0];
    assign fracEX[0] = {frac[0], 8'b0};
    assign fracEX[1] = {frac[1], 8'b0};

    wire [31:0] fracSFT, fracNotSFT;
    assign fracNotSFT = sft_tgt ? fracEX[0] : fracEX[1];
    ShiftR32U shift(
        .n(frac_sft_nbs[7:0]),
        .in(sft_tgt ? fracEX[1] : fracEX[0]),
        .out(fracSFT)
    );

    wire [31:0] frac1T, frac2T;
    assign frac1T = {sft_tgt ? sign[1] : sign[0], fracSFT[31:1]};
    assign frac2T = {sft_tgt ? sign[0] : sign[1], fracNotSFT[31:1]};

    wire [31:0] frac1C, frac2C;
    TCC32 t2c_0(
        .T(frac1T),
        .C(frac1C)
    ),    t2c_1(
        .T(frac2T),
        .C(frac2C)
    );

    wire [31:0] frac3C;
    Add32 adder(
        .op1(frac1C),
        .op2(frac2C),
        .sum(frac3C)
    );  

    wire sign3, overflow;
    assign sign3 = `isEQ(exp1_vs_exp2, `OP1_GT_OP2) ? sign[0] :
                   `isEQ(exp1_vs_exp2, `OP1_LT_OP2) ? sign[1] : `isEQ(frac1_vs_frac2, `OP1_GT_OP2) ? sign[0] : sign[1];
    assign overflow = sign3 ^ frac3C[31];

    CTC32 c2t(
        .C(overflow ? {sign3, frac3C[31:1]} : frac3C),
        .T(frac3rd)
    );

    assign frac_of = overflow;

endmodule

module IEEE754_smart_shift(
    input  wire [ 7:0] exponent_i,
    input  wire [31:0] fraction_i,
    input  wire        overflow_i,
    output wire [ 7:0] exponent_o,
    output wire [22:0] fraction_o
);

    wire        rbt;
    wire [ 7:0] nbs;
    wire [31:0] fraction;               /* |Where is 2^0    |nbs    |fo = fi << nbs            |Round Bit      */
    assign {nbs, fraction[22:0], rbt} = /* fraction_i[31] ? Sign Bit NOT Subject                              :*/
                                           fraction_i[30] ? {8'd0,  {fraction_i[29:7]       }, fraction_i[6]} : 
                                           fraction_i[29] ? {8'd1,  {fraction_i[28:6]       }, fraction_i[5]} :
                                           fraction_i[28] ? {8'd2,  {fraction_i[27:5]       }, fraction_i[4]} :
                                           fraction_i[27] ? {8'd3,  {fraction_i[26:4]       }, fraction_i[3]} :
                                           fraction_i[26] ? {8'd4,  {fraction_i[25:3]       }, fraction_i[2]} :
                                           fraction_i[25] ? {8'd5,  {fraction_i[24:2]       }, fraction_i[1]} :
                                           fraction_i[24] ? {8'd6,  {fraction_i[23:1]       }, fraction_i[0]} :
                                           fraction_i[23] ? {8'd7,  {fraction_i[22:0]       },          1'b0} :
                                           fraction_i[22] ? {8'd8,  {fraction_i[21:0],  1'b0},          1'b0} :
                                           fraction_i[21] ? {8'd9,  {fraction_i[20:0],  2'b0},          1'b0} :
                                           fraction_i[20] ? {8'd10, {fraction_i[19:0],  3'b0},          1'b0} :
                                           fraction_i[19] ? {8'd11, {fraction_i[18:0],  4'b0},          1'b0} :
                                           fraction_i[18] ? {8'd12, {fraction_i[17:0],  5'b0},          1'b0} :
                                           fraction_i[17] ? {8'd13, {fraction_i[16:0],  6'b0},          1'b0} :
                                           fraction_i[16] ? {8'd14, {fraction_i[15:0],  7'b0},          1'b0} :
                                           fraction_i[15] ? {8'd15, {fraction_i[14:0],  8'b0},          1'b0} :
                                           fraction_i[14] ? {8'd16, {fraction_i[13:0],  9'b0},          1'b0} :
                                           fraction_i[13] ? {8'd17, {fraction_i[12:0], 10'b0},          1'b0} :
                                           fraction_i[12] ? {8'd18, {fraction_i[11:0], 11'b0},          1'b0} :
                                           fraction_i[11] ? {8'd19, {fraction_i[10:0], 12'b0},          1'b0} :
                                           fraction_i[10] ? {8'd20, {fraction_i[ 9:0], 13'b0},          1'b0} :
                                           fraction_i[ 9] ? {8'd21, {fraction_i[ 8:0], 14'b0},          1'b0} :
                                           fraction_i[ 8] ? {8'd22, {fraction_i[ 7:0], 15'b0},          1'b0} :
                                           fraction_i[ 7] ? {8'd23, {fraction_i[ 6:0], 16'b0},          1'b0} :
                                           fraction_i[ 6] ? {8'd24, {fraction_i[ 5:0], 17'b0},          1'b0} :
                                           fraction_i[ 5] ? {8'd25, {fraction_i[ 4:0], 18'b0},          1'b0} :
                                           fraction_i[ 4] ? {8'd26, {fraction_i[ 3:0], 19'b0},          1'b0} :
                                           fraction_i[ 3] ? {8'd27, {fraction_i[ 2:0], 20'b0},          1'b0} :
                                           fraction_i[ 2] ? {8'd28, {fraction_i[ 1:0], 21'b0},          1'b0} :
                                           fraction_i[ 1] ? {8'd29, {fraction_i[   0], 22'b0},          1'b0} :
                                           fraction_i[ 0] ? {8'd30, {                  23'b0},          1'b0} : {exponent_i, 23'b0, 1'b0};

    wire [31:0] exponent; /* (f << n) */
    Sub32 subtractor(  /* => (e -  n) */
        .op1({24'b0, exponent_i}),
        .op2({24'b0, nbs}),
        .diff(exponent)
    );

    wire [31:0] exponent_2;
    Add32 adderE(
        .op1(exponent),
        .op2({31'b0, overflow_i}),
        .sum(exponent_2)
    );  assign exponent_o = exponent_2[7:0];

    wire [31:0] fraction_r;
    Add32 adderF(
        .op1(fraction),
        .op2({31'b0, rbt}),
        .sum(fraction_r)
    );  assign fraction_o = fraction_r[22:0];

endmodule

`endif 