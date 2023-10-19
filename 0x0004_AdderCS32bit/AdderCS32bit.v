module AdderCS32bit (
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    input  wire [31:0] op3,
    input  wire        cin,
    output wire [31:0] sum,
    output wire        cout
);

    wire [31:0] lcOP1, lcOP2;
    AdderLC32bit adderLC32bit(
        .op1(lcOP1),
        .op2(lcOP2),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

endmodule

module AdderCS1bit(
    input  wire op1,
    input  wire op2,
    input  wire op3,
    output wire sum,
    output wire cout
);

    AdderFL1bit adderFL1bit(
        .op1(op1),
        .op2(op2),
        .cin(op3),
        .sum(sum),
        .cout(cout)
    );

endmodule