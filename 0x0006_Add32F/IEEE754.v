`ifndef IEEE754_V
`define IEEE754_V

`include "../IPs_shared/Comparator.v"
`include "../IPs_shared/MacroFunc.v"
`include "../0x0012_Sub32U/Sub32.v"

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

`endif 