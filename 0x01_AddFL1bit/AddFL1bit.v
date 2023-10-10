module AddFL1bit(
    input  wire op1,
    input  wire op2,
    input  wire cin,
    output wire sum,
    output wire cout
);

    assign sum  = op1 ^ op2 ^ cin;
    assign cout = (op1 & op2) | ((op1 ^ op2) & cin);

endmodule