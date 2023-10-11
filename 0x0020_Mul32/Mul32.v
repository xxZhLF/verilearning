module Mul32 (
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [63:0] res
);

    wire [63:0] op1EX;
    assign op1EX = {32'h00000000, op1};

    wire [63:0] vecL1 [31:0];
    generate
        for (genvar i = 0; i < 32; ++i) begin
            assign vecL1[i] = op2[i] ^ 1'b0 ? op1EX << i : 64'h0000000000000000;
        end
    endgenerate

    wire [63:0] vecL2 [15:0];
    generate
        for (genvar i = 0; i < 16; ++i) begin
            Add64 adder(
                .op1(vecL1[i+0]),
                .op2(vecL1[i+1]),
                .sum(vecL2[i])
            );
        end
    endgenerate
    
endmodule

module Add64(
    input  wire [63:0] op1,
    input  wire [63:0] op2,
    output wire [63:0] sum
);

    reg  ZERO = 1'b0;
    reg  NULL;
    wire cinner;

    AdderLA32bit adderL(
        .op1(op1[31:0]),
        .op2(op2[31:0]),
        .cin(ZERO),
        .sum(sum[31:0]),
        .cout(cinner)
    ); 
    AdderLA32bit adderH(
        .op1(op1[63:32]),
        .op2(op2[63:32]),
        .cin(cinner),
        .sum(sum[63:32]),
        .cout(NULL)
    );

endmodule