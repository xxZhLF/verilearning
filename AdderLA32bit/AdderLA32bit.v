module AdderLA32bit (
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    input  wire        cin,
    output wire [31:0] sum,
    output wire        cout
);

    assign {cout, sum} = op1 + op2 + {24'h000000, 7'b00000000, cin};
    
endmodule