`ifndef SUB_32BIT_COMPLEMENT_V
`define SUB_32BIT_COMPLEMENT_V

module Sub32(
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [31:0] diff
);

    reg USELESS;
    AdderLC32bit subtractor(  
        .op1( op1), 
        .op2(~op2), 
        .cin(1'b1),
        .sum(diff),
        .cout(USELESS)
    );

endmodule

`endif 