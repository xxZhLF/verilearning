`ifndef IEEE754_V
`define IEEE754_V

`include "../0x0005_Add32/Add32.v"
`include "../0x0012_Sub32U/Sub32.v"
`include "Shift.v"

module IEEE754_decompo(
    input  wire [31:0] float,
    output wire [23:0] fraction,
    output wire [ 7:0] exponent,
    output wire        sign
);

    assign sign = float[31];

    assign fraction = { 1'b1, float[22: 0]};
    assign exponent = {       float[30:23]};

endmodule


module IEEE754_compose(
    input  wire        sign,
    input  wire [ 7:0] exponent,
    input  wire [23:0] fraction,
    output wire [31:0] float
);

    wire         L0R;
    wire [ 7: 0] nbs;
    assign {L0R, nbs} = fraction[31] ? {1'b0, 8'd08 - 8'd31 - 8'd23} : 
                        fraction[30] ? {1'b0, 8'd08 - 8'd30 - 8'd23} :
                        fraction[29] ? {1'b0, 8'd08 - 8'd29 - 8'd23} :
                        fraction[28] ? {1'b0, 8'd08 - 8'd28 - 8'd23} :
                        fraction[27] ? {1'b0, 8'd08 - 8'd27 - 8'd23} :
                        fraction[26] ? {1'b0, 8'd08 - 8'd26 - 8'd23} :
                        fraction[25] ? {1'b0, 8'd08 - 8'd25 - 8'd23} :
                        fraction[24] ? {1'b0, 8'd08 - 8'd24 - 8'd23} :
                        fraction[23] ? {1'b0, 8'd000000000000000000} :
                        fraction[22] ? {1'b1, 8'd23 - 8'd22} :
                        fraction[21] ? {1'b1, 8'd23 - 8'd21} :
                        fraction[20] ? {1'b1, 8'd23 - 8'd20} :
                        fraction[19] ? {1'b1, 8'd23 - 8'd19} :
                        fraction[18] ? {1'b1, 8'd23 - 8'd18} :
                        fraction[17] ? {1'b1, 8'd23 - 8'd17} :
                        fraction[16] ? {1'b1, 8'd23 - 8'd16} :
                        fraction[15] ? {1'b1, 8'd23 - 8'd15} :
                        fraction[14] ? {1'b1, 8'd23 - 8'd14} :
                        fraction[13] ? {1'b1, 8'd23 - 8'd13} :
                        fraction[12] ? {1'b1, 8'd23 - 8'd12} :
                        fraction[11] ? {1'b1, 8'd23 - 8'd11} :
                        fraction[10] ? {1'b1, 8'd23 - 8'd10} :
                        fraction[ 9] ? {1'b1, 8'd23 - 8'd09} :
                        fraction[ 8] ? {1'b1, 8'd23 - 8'd08} :
                        fraction[ 7] ? {1'b1, 8'd23 - 8'd07} :
                        fraction[ 6] ? {1'b1, 8'd23 - 8'd06} :
                        fraction[ 5] ? {1'b1, 8'd23 - 8'd05} :
                        fraction[ 4] ? {1'b1, 8'd23 - 8'd04} :
                        fraction[ 3] ? {1'b1, 8'd23 - 8'd03} :
                        fraction[ 2] ? {1'b1, 8'd23 - 8'd02} :
                        fraction[ 1] ? {1'b1, 8'd23 - 8'd01} :
                        fraction[ 0] ? {1'b1, 8'd23 - 8'd00} : {1'bZ, 8'hZZ};

    wire [31: 0] expL;
    Add32 adder(
        .op1(exponent),
        .op2({24'b0, nbs}),
        .sum(expL)
    );

    wire [31: 0] expR;
    Sub32 subtractor(
        .op1(exponent),
        .op2({24'b0, nbs}),
        .diff(expR)
    );

    wire [31: 0] fracL;
    ShiftL32U shiftL(
        .n(nbs),
        .in({8'b0, fraction[30:7]}),
        .out(fracL)
    );

    wire [31: 0] fracR;
    ShiftR32U shiftR(
        .n(nbs),
        .in({8'b0, fraction[30:7]}),
        .out(fracR)
    );

    assign float = {fraction[31], L0R ? expL[7:0] : expR[7:0], L0R ? fracL[22:0] : fracR[22:0]};

endmodule

`endif 