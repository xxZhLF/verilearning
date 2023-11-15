`ifndef DIV_32BIT_FLOAT_V
`define DIV_32BIT_FLOAT_V

`include "../IPs_shared/IEEE754.v"
`include "../IPs_shared/TC_converter.v"
`include "../IPs_shared/Comparator.v"
`include "../0x0031_Div32U/Div32U.v"
`include "../0x0012_Sub32U/Sub32.v"

module Div32F (
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [31:0] res
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

    wire [ 7:0] exponent_raw;
    IEEE754_exponent_process processor_e(
        .exp_i(e),
        .exp_o(exponent_raw)
    );

    wire [23:0] fraction_raw;
    IEEE754_fraction_process processor_f(
        .frac_i(f),
        .frac_o(fraction_raw)
    );

    wire [ 7:0] exponent_cooked; 
    wire [22:0] fraction_cooked;
    IEEE754_smart_shift smart_shift(
        .exponent_i(exponent_raw),
        .fraction_i(fraction_raw),
        .exponent_o(exponent_cooked),
        .fraction_o(fraction_cooked)
    );

    IEEE754_compose compose(
        .sign(s[0] ^ s[1]),
        .exponent(exponent_cooked),
        .fraction(fraction_cooked),
        .float(res)
    );

endmodule

module IEEE754_exponent_process(
    input  wire [7:0] exp_i[1:0],
    output wire [7:0] exp_o
);

    wire [31:0] exp_complement_of_2;
    TCC32 t2c(
        .T({1'b1, 23'b0, exp_i[1][7:0]}),
        .C(exp_complement_of_2)
    );

    wire [31:0] exp_32bit;
    wire [31:0] pipe[1:0];
    AdderCS32bit adderCS(
        .op1({24'b0, exp_i[0]}),
        .op2(exp_complement_of_2),
        .op3({24'b0, 8'b01111111}), /* 127 */
        .sum(pipe[0]),
        .carry(pipe[1])
    );       reg USELESS;
    AdderLC32bit adderLC(
        .op1(pipe[0]),
        .op2({pipe[1][30:0], 1'b0}),
        .cin(1'b0),
        .sum(exp_32bit),
        .cout(USELESS)
    );

    assign exp_o = exp_32bit[7:0];

endmodule

module IEEE754_fraction_process(
    input  wire [23:0] frac_i[1:0],
    output wire [23:0] frac_o
);

    generate
        wire [63:0] remaiVEC[23+1:0];
        assign remaiVEC[0] = {frac_i[0], 8'b0, 32'b0};
        for (genvar i = 0; i < 24; ++i) begin
            Div32U_chain_of_subtractor core(
                .remai(remaiVEC[i]),
                .divor({frac_i[1], 8'b0, 32'b0}),
                .nbit(i),
                .quoti(frac_o[23-i]),
                .remao(remaiVEC[i+1])
            );
        end
    endgenerate

endmodule

module IEEE754_smart_shift(
    input  wire [ 7:0] exponent_i,
    input  wire [23:0] fraction_i,
    output wire [ 7:0] exponent_o,
    output wire [22:0] fraction_o
);

    wire [ 7:0] nbs;              /* |Where is 2^0    |nbs    |fo = fi << nbs            */
    assign {nbs, fraction_o[22:0]} = fraction_i[23] ? {8'd0,  {fraction_i[22:0]       }} :
                                     fraction_i[22] ? {8'd1,  {fraction_i[21:0],  1'b0}} : 
                                     fraction_i[21] ? {8'd2,  {fraction_i[20:0],  2'b0}} : 
                                     fraction_i[20] ? {8'd3,  {fraction_i[19:0],  3'b0}} : 
                                     fraction_i[19] ? {8'd4,  {fraction_i[18:0],  4'b0}} : 
                                     fraction_i[18] ? {8'd5,  {fraction_i[17:0],  5'b0}} : 
                                     fraction_i[17] ? {8'd6,  {fraction_i[16:0],  6'b0}} : 
                                     fraction_i[16] ? {8'd7,  {fraction_i[15:0],  7'b0}} : 
                                     fraction_i[15] ? {8'd8,  {fraction_i[14:0],  8'b0}} : 
                                     fraction_i[14] ? {8'd9,  {fraction_i[13:0],  9'b0}} : 
                                     fraction_i[13] ? {8'd10, {fraction_i[12:0], 10'b0}} : 
                                     fraction_i[12] ? {8'd11, {fraction_i[11:0], 11'b0}} : 
                                     fraction_i[11] ? {8'd12, {fraction_i[10:0], 12'b0}} : 
                                     fraction_i[10] ? {8'd13, {fraction_i[ 9:0], 13'b0}} : 
                                     fraction_i[ 9] ? {8'd14, {fraction_i[ 8:0], 14'b0}} : 
                                     fraction_i[ 8] ? {8'd15, {fraction_i[ 7:0], 15'b0}} : 
                                     fraction_i[ 7] ? {8'd16, {fraction_i[ 6:0], 16'b0}} : 
                                     fraction_i[ 6] ? {8'd17, {fraction_i[ 5:0], 17'b0}} : 
                                     fraction_i[ 5] ? {8'd18, {fraction_i[ 4:0], 18'b0}} : 
                                     fraction_i[ 4] ? {8'd19, {fraction_i[ 3:0], 19'b0}} : 
                                     fraction_i[ 3] ? {8'd20, {fraction_i[ 2:0], 20'b0}} : 
                                     fraction_i[ 2] ? {8'd21, {fraction_i[ 1:0], 21'b0}} : 
                                     fraction_i[ 1] ? {8'd22, {fraction_i[   0], 22'b0}} : 
                                     fraction_i[ 0] ? {8'd23, {                  23'b0}} : {exponent_i, 22'b0, 1'b0};

    wire [31:0] exponent; /* (f << n) */
    Sub32 subtractor(  /* => (e -  n) */
        .op1({24'b0, exponent_i}),
        .op2({24'b0, nbs}),
        .diff(exponent)
    );  assign exponent_o = exponent[7:0];

endmodule

`endif 