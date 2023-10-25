`ifndef SUB_32BIT_COMPLEMENT_V
`define SUB_32BIT_COMPLEMENT_V

`include "../IPs_shared/TC_converter.v"

module Sub32(
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [31:0] diff
);

    wire [31:0] op2C;
    TCC32 t2c( 
        .T({1'b1, op2[30:0]}),
        .C(op2C)
    );

    wire [31:0] op2T;
    CTC32 c2t(
        .C(op2),
        .T(op2T)
    );

    reg ZERO, USELESS;
    always ZERO = 1'b0;
    AdderLC32bit adder(  
        .op1(op1), 
        .op2(op2[31] ? {1'b0, op2T[30:0]} : op2C), 
        .cin(),
        .sum(diff),
        .cout(USELESS)
    );

endmodule

`endif 