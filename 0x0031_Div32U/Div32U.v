`ifndef DIV_32BIT_UNSIGNED_V_COMBINATIONAL
`define DIV_32BIT_UNSIGNED_V_COMBINATIONAL

`include "../IPs_shared/universal4inc.v"

module Div32U (
    input  wire [31:0] dived,
    input  wire [31:0] divor,
    output wire [31:0] quoti,
    output wire [31:0] remai
);

    wire [63:0] remaiEXT, divorEXT;
    assign remaiEXT = {32'h00000000, dived};
    assign divorEXT = {divor, 32'h00000000};

    generate
        wire [63:0] remaiVEC [1+31:0];
        assign remaiVEC[0] = remaiEXT;
        for (genvar i = 0; i < 32; ++i) begin
            Div32U_chain_of_subtractor core(
                .remai(remaiVEC[i]),
                .divor(divorEXT),
                .nbit(i+1),
                .quoti(quoti[31-i]),
                .remao(remaiVEC[i+1])
            );
        end
    endgenerate

    assign remai = remaiVEC[32][31:0];

endmodule

module Div32U_chain_of_subtractor(
    input  wire [63:0] remai,
    input  wire [63:0] divor,
    input  wire [ 7:0] nbit,
    output wire        quoti,
    output wire [63:0] remao
);

    wire [63:0] divorSFT;
    ShiftR64U shift(
        .n(nbit), 
        .in(divor), 
        .out(divorSFT));

    wire [ 1:0] cmp_res;
    Cmp64U cmp(
        .op1(divorSFT), 
        .op2(remai),
        .res(cmp_res));

    Sub64 sub(
        .op1(remai),
        .op2(`isEQ(cmp_res, `OP1_GT_OP2) ? 64'h0 : divorSFT),
        .diff(remao));

    assign quoti = `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;

endmodule

`endif 