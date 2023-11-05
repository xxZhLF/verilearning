`ifndef IEEE754_V
`define IEEE754_V

`include "../IPs_shared/Comparator.v"

module IEEE754_decompo(
    input  wire [31:0] float,
    output wire [31:0] fraction,
    output wire [31:0] exponent,
    output wire        sign
);

    assign sign = float[31];

    assign fraction = { 8'b0, 1'b1, float[22: 0]};
    assign exponent = {24'b0,       float[30:23]};

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
    output wire        sft_frac,
    output wire [ 5:0] sft_nbit
);

    wire [ 1:0] cmp_res;
    Cmp32U cmp(
        .op1(exp1),
        .op2(exp2),
        .res(cmp_res)
    );

endmodule

`endif 