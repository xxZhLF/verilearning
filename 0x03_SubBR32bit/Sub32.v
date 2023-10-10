module Sub32(
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [31:0] diff
);

    reg ZERO = 1'b0;
    reg NULL;

    SubBR32bit subtractor(
        .op1(op1),
        .op2(op2),
        .bo(ZERO),
        .diff(diff),
        .bi(NULL)
    );

endmodule