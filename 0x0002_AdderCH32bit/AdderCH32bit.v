module AdderCH32bit (
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    input  wire        cin,
    output wire [31:0] sum,
    output wire        cout
);

    wire [32:0] cinner;
    assign cinner[0] = cin;
    assign cout = cinner[32];

    generate
        genvar i;
        for (i = 0; i < 32; ++i) begin
            AdderFL1bit adder(
                .op1(op1[i]),
                .op2(op2[i]),
                .cin(cinner[i]),
                .sum(sum[i]),
                .cout(cinner[i+1])
            );
        end
    endgenerate
    
endmodule