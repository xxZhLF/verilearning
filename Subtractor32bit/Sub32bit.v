// `define SUB_DEBUG_ON

module Sub32bit(
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    input  wire        cin,
    output wire [31:0] diff,
    output wire        cout
`ifdef SUB_DEBUG_ON
  , output wire [31:0] debug
`endif
);

    wire [31:0] op1C, op2IC;
    ModT2C modT2C_a(
        .T(op1),
        .C(op1C)
    ),     modT2C_b(
        .T({~op2I[31], op2I[30:0]}),
        .C(op2IC)
    );

    ModC2T modC2T(
        .C(diffC),
        .T(diff)
    );

    reg       ZERO;
    reg [1:0] NULL;
    always ZERO = 1'b0;
    wire [31:0] op2I, diffC;
    AdderLA32bit adder0(
        .op1(op2),
        .op2({28'h0000000, 3'b000, cin}),
        .cin(ZERO),
        .sum(op2I),
        .cout(NULL[0])
    ),adder1(
        .op1(op1), 
        .op2(op2IC), 
        .cin(ZERO), 
        .sum(diffC), 
        .cout(NULL[1])
    );

    assign cout = diffC[31];

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
    AdderLA32bit adder(
        .op1({1'b0, ~datI}), 
        .op2(32'h00000001), 
        .cin(ZERO), 
        .sum(datO), 
        .cout(NULL)
    );

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
    AdderLA32bit adder(
        .op1({1'b0, datI}), 
        .op2(32'hFFFFFFFF), 
        .cin(ZERO), 
        .sum(datO), 
        .cout(NULL)
    );

    assign T = datI != {28'h0000000, 3'b000} ? {sign, sign ? ~datO[30:0] : datI[30:0]} : 32'h00000000;

endmodule