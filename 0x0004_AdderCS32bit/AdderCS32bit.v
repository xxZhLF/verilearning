module AdderCS32bit (
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    input  wire [31:0] op3,
    input  wire        cin,
    output wire [31:0] sum,
    output wire        cout
);

    wire coutL1, coutL2;

    generate
        wire [31:0] carry, sum_without_carry;
        for (genvar i = 0; i < 32; ++i) begin
            AdderCS1bit adderCS1bit(
                .op1(op1[i]),
                .op2(op2[i]),
                .op3(op3[i]),
                .sum(sum_without_carry[i]),
                .cout(carry[i])
            );
        end
        assign coutL1 = carry[31];
    endgenerate

    AdderLC32bit adderLC32bit(
        .op1(sum_without_carry),
        .op2({carry[30:0], cin}),
        .cin(1'b0),
        .sum(sum),
        .cout(coutL2)
    );

    assign cout = coutL1 | coutL2;

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