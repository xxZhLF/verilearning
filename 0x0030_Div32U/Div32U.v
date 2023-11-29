`ifndef DIV_32BIT_UNSIGNED_V_SEQUENTIAL
`define DIV_32BIT_UNSIGNED_V_SEQUENTIAL

`include "../IPs_shared/universal4inc.v"

module Div32U (
    input  wire        rst,
    input  wire        clk,
    input  wire [31:0] dived,
    input  wire [31:0] divor,
    output wire [31:0] quoti,
    output wire [31:0] remai
);

    wire [63:0] remaiEXT, divorEXT;
    assign remaiEXT = {32'h00000000, dived};
    assign divorEXT = {divor, 32'h00000000};

    reg  [31:0] quotiREG;
    reg  [63:0] remaiREG, divorREG;

    wire [31:0] cnt;
    Counter32 counter(
        .rst(rst),
        .clk(clk),
        .cnt(cnt)
    );

    wire [ 1:0] cmp_res;
    Cmp64U cmp(
        .op1(divorREG),
        .op2(remaiREG),
        .res(cmp_res)
    );

    wire [63:0] sub_res;
    Sub64 sub(
        .op1(remaiREG),
        .op2(divorREG),
        .diff(sub_res)
    );

    always @(negedge rst or posedge clk) begin
        if (rst) begin
            quotiREG <= 32'h00000000;
            remaiREG <= remaiEXT;
            divorREG <= {1'b0, divorEXT[63:1]};
        end else begin
            divorREG <= {1'b0, divorREG[63:1]};;
            remaiREG <= `isEQ(cmp_res, `OP1_GT_OP2) ? remaiREG : sub_res;
        end
    end

    always @(negedge rst or posedge clk) begin
        if (rst) begin
        end else begin
            case(cnt[4:0])
                5'h00: quotiREG[31] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h01: quotiREG[30] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h02: quotiREG[29] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h03: quotiREG[28] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h04: quotiREG[27] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h05: quotiREG[26] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h06: quotiREG[25] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h07: quotiREG[24] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h08: quotiREG[23] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h09: quotiREG[22] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h0A: quotiREG[21] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h0B: quotiREG[20] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h0C: quotiREG[19] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h0D: quotiREG[18] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h0E: quotiREG[17] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h0F: quotiREG[16] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h10: quotiREG[15] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h11: quotiREG[14] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h12: quotiREG[13] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h13: quotiREG[12] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h14: quotiREG[11] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h15: quotiREG[10] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h16: quotiREG[ 9] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h17: quotiREG[ 8] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h18: quotiREG[ 7] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h19: quotiREG[ 6] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h1A: quotiREG[ 5] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h1B: quotiREG[ 4] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h1C: quotiREG[ 3] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h1D: quotiREG[ 2] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h1E: quotiREG[ 1] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
                5'h1F: quotiREG[ 0] <= `isEQ(cmp_res, `OP1_GT_OP2) ? 1'b0 : 1'b1;
            endcase
        end
    end

    assign {quoti, remai} = {quotiREG, remaiREG[31:0]};

endmodule

`endif 