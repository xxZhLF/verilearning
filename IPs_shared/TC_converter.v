module TCC32(
    input  wire [31:0] T,
    output wire [31:0] C
);

    wire        sign; 
    wire [30:0] datI;
    assign {sign, datI} = T;

    wire [31:0] datO;

    Add32 adder(
        .op1({1'b0, ~datI}), 
        .op2(32'h00000001), 
        .sum(datO)
    );  /* ~datI + 1 */

    assign C = {sign, sign ? datO[30:0] : datI[30:0]};

endmodule

module CTC32(
    input  wire [31:0] C,
    output wire [31:0] T
);

    wire        sign; 
    wire [30:0] datI;
    assign {sign, datI} = C;

    wire [31:0] datO;

    Add32 adder(
        .op1({1'b0, datI}), 
        .op2(32'hFFFFFFFF), // -1
        .sum(datO)
    );  /* ~(datI + -1) 
           ~ at next line */

    assign T = {sign, sign ? ~datO[30:0] : datI[30:0]};

endmodule

module TCC64(
    input  wire [63:0] T,
    output wire [63:0] C
);

    wire        sign; 
    wire [62:0] datI;
    assign {sign, datI} = T;

    wire [63:0] datO;

    AddLC64 adder(
        .op1({1'b0, ~datI}), 
        .op2(64'h0000000000000001), 
        .sum(datO)
    );  /* ~datI + 1 */

    assign C = {sign, sign ? datO[62:0] : datI[62:0]};

endmodule

module CTC64(
    input  wire [63:0] C,
    output wire [63:0] T
);

    wire        sign; 
    wire [62:0] datI;
    assign {sign, datI} = C;

    wire [63:0] datO;

    AddLC64 adder(
        .op1({1'b0, datI}), 
        .op2(64'hFFFFFFFFFFFFFFFF), // -1
        .sum(datO)
    );  /* ~(datI + -1) 
           ~ at next line */

    assign T = {sign, sign ? ~datO[62:0] : datI[62:0]};

endmodule