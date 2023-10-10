// `define SUB_DEBUG_ON

module SubBR32bit(
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    input  wire        bo,
    output wire [31:0] diff,
    output wire        bi
`ifdef SUB_DEBUG_ON
  , output wire [31:0] debug
`endif
);

    wire [31:0] op1C, op2IC;
    ModT2C modT2C_a(  /* Complement of  op1 */ 
        .T(op1),
        .C(op1C)
    ),     modT2C_b(  /* Complement of -op2 */ 
        .T({~op2I[31], op2I[30:0]}),
        .C(op2IC)
    );

    reg       ZERO;
    reg [1:0] NULL;
    always ZERO = 1'b0;
    wire [31:0] op2I, diffC;
    AddLA32bit adder0(  /* op2 + bo */ 
        .op1(op2),
        .op2({28'h0000000, 3'b000, bo}),
        .cin(ZERO),
        .sum(op2I),
        .cout(NULL[0])
    ),         adder1(  /* op1 - (op2 + bo) */ 
        .op1(op1C), 
        .op2(op2IC), 
        .cin(ZERO), 
        .sum(diffC), 
        .cout(NULL[1])
    );

    ModC2T modC2T(
        .C(diffC),
        .T(diff)
    );  /* Truth of result */ 

    assign bi = diffC[31];

`ifdef SUB_DEBUG_ON
    assign debug = op1C;
    // assign debug = op2IC;
`endif

endmodule

module ModT2C(
    input  wire [31:0] T,
    output wire [31:0] C
);

    wire        sign; 
    wire [30:0] datI;
    assign {sign, datI} = T;

    wire [31:0] datO;
    reg  ZERO, NULL;
    always ZERO = 1'b0;
    AddLA32bit adder(
        .op1({1'b0, ~datI}), 
        .op2(32'h00000001), 
        .cin(ZERO), 
        .sum(datO), 
        .cout(NULL)
    );  /* ~datI + 1 */

    assign C = datI != {28'h0000000, 3'b000} ? {sign, sign ? datO[30:0] : datI[30:0]} : 32'h00000000;

endmodule

module ModC2T(
    input  wire [31:0] C,
    output wire [31:0] T
);

    wire        sign; 
    wire [30:0] datI;
    assign {sign, datI} = C;

    wire [31:0] datO;
    reg  ZERO, NULL;
    always ZERO = 1'b0;
    AddLA32bit adder(
        .op1({1'b0, datI}), 
        .op2(32'hFFFFFFFF), 
        .cin(ZERO), 
        .sum(datO), 
        .cout(NULL)
    );  /* ~(datI - 1) 
           ~ at next line */

    assign T = datI != {28'h0000000, 3'b000} ? {sign, sign ? ~datO[30:0] : datI[30:0]} : 32'h00000000;

endmodule