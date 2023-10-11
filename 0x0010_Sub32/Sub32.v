// `define SUB_DEBUG_ON

`include "TC_converter.v"

module Sub32(
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [31:0] diff
`ifdef SUB_DEBUG_ON
  , output wire [31:0] debug
`endif
);

    wire [31:0] op1C, op2C;
    ModT2C modT2C_a(  /* Complement of op1 */ 
        .T(op1),
        .C(op1C)
    ), modT2C_b(  /* Complement of -op2 */ 
        .T({~op2[31], op2[30:0]}),
        .C(op2C)
    );

    wire [31:0] diffC;
    Add32 adder(  
        .op1(op1C), 
        .op2(op2C), 
        .sum(diffC)
    );

    ModC2T modC2T(
        .C(diffC),
        .T(diff)
    );  /* Truth of result */ 

`ifdef SUB_DEBUG_ON
    assign debug = op1C;
`endif

endmodule