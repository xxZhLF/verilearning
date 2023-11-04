`ifndef IEEE754_V
`define IEEE754_V

`include "../IPs_shared/Comparator.v"

module IEEE754_decompo(
    input  wire [31:0] float,
    output wire [31:0] fraction,
    output wire [31:0] exponent
);



endmodule


module IEEE754_compose(
    input  wire [31:0] fraction,
    input  wire [31:0] exponent,
    output wire [31:0] float
);



endmodule


module IEEE754_analyzer(
    input  wire [31:0] frac0,
    input  wire [31:0] frac1,
    output wire        sft_frac,
    output wire [ 5:0] sft_nbit
);



endmodule

`endif 