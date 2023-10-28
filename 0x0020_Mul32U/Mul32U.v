`ifndef MUL_32BIT_UNSIGNED_V_COMBINATORIAL
`define MUL_32BIT_UNSIGNED_V_COMBINATORIAL

`include "../IPs_shared/Shift.v"
`include "../IPs_shared/Add64.v"

module Mul32U (
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [63:0] res
);

    wire [63:0] op1EX;
    assign op1EX = {32'h00000000, op1};

    wire [63:0] vecL1 [31:0];
    generate
        for (genvar i = 0; i < 32; ++i) begin
            // assign vecL1[i] = op2[i] ^ 1'b0 ? op1EX << i : 64'h0000000000000000;
            ShiftL64U shift(
                .n(op2[i] ^ 1'b0 ? i : 8'h40),
                .in(op1EX),
                .out(vecL1[i])
            );
        end
    endgenerate

    wire [63:0] vecL2 [15:0];
    generate
        for (genvar i = 0; i < 16; ++i) begin
            AddLC64 adder(
                .op1(vecL1[i*2+0]),
                .op2(vecL1[i*2+1]),
                .sum(vecL2[i])
            );
        end
    endgenerate

    wire [63:0] vecL3 [7:0];
    generate
        for (genvar i = 0; i < 8; ++i) begin
            AddLC64 adder(
                .op1(vecL2[i*2+0]),
                .op2(vecL2[i*2+1]),
                .sum(vecL3[i])
            );
        end
    endgenerate

    wire [63:0] vecL4 [3:0];
    generate
        for (genvar i = 0; i < 4; ++i) begin
            AddLC64 adder(
                .op1(vecL3[i*2+0]),
                .op2(vecL3[i*2+1]),
                .sum(vecL4[i])
            );
        end
    endgenerate

    wire [63:0] vecL5 [2:0];
    generate
        for (genvar i = 0; i < 2; ++i) begin
            AddLC64 adder(
                .op1(vecL4[i*2+0]),
                .op2(vecL4[i*2+1]),
                .sum(vecL5[i])
            );
        end
    endgenerate

    AddLC64 adder(
        .op1(vecL5[0]),
        .op2(vecL5[1]),
        .sum(res)
    );

endmodule

`endif 