`ifndef IPs_SHARED_SUB64_V
`define IPs_SHARED_SUB64_V

`include "./Comparator.v"
`include "./Add64.v"

module Sub64S(
    input  wire [63:0] op1,
    input  wire [63:0] op2,
    output wire [63:0] diff
);

    wire [63:0] op2C;
    TCC64 t2c( 
        .T({1'b1, op2[62:0]}),
        .C(op2C)
    );

    wire [63:0] op2T;
    CTC64 c2t(
        .C(op2),
        .T(op2T)
    );

    reg ZERO, USELESS;
    always ZERO = 1'b0;
    AddLC64 adder(  
        .op1(op1), 
        .op2(op2[63] ? {1'b0, op2T[62:0]} : op2C), 
        .sum(diff)
    );

endmodule

`endif 