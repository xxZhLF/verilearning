`ifndef IEEE754_V
`define IEEE754_V

module IEEE754_decompo(
    input  wire [31:0] float,
    output wire [23:0] fraction,
    output wire [ 7:0] exponent,
    output wire        sign
);

    assign sign = float[31];

    assign exponent = {       float[30:23]};
    assign fraction = { 1'b1, float[22: 0]};

endmodule


module IEEE754_compose(
    input  wire        sign,
    input  wire [ 7:0] exponent,
    input  wire [22:0] fraction,
    output wire [31:0] float
);

    assign float = {sign, exponent, fraction};

endmodule

`endif 