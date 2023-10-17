module Add64(
    input  wire [63:0] op1,
    input  wire [63:0] op2,
    output wire [63:0] sum
);

    reg  ZERO = 1'b0;
    reg  NULL;
    wire cinner;

    AdderLC32bit adderL(
        .op1(op1[31:0]),
        .op2(op2[31:0]),
        .cin(ZERO),
        .sum(sum[31:0]),
        .cout(cinner)
    ); 
    AdderLC32bit adderH(
        .op1(op1[63:32]),
        .op2(op2[63:32]),
        .cin(cinner),
        .sum(sum[63:32]),
        .cout(NULL)
    );

endmodule