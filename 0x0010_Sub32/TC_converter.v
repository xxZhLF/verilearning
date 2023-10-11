module TCC(
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

    assign C = datI != {28'h0000000, 3'b000} ? {sign, sign ? datO[30:0] : datI[30:0]} : 32'h00000000;

endmodule

module CTC(
    input  wire [31:0] C,
    output wire [31:0] T
);

    wire        sign; 
    wire [30:0] datI;
    assign {sign, datI} = C;

    wire [31:0] datO;

    Add32 adder(
        .op1({1'b0, datI}), 
        .op2(32'hFFFFFFFF), 
        .sum(datO)
    );  /* ~(datI + -1) 
           ~ at next line */

    assign T = datI != {28'h0000000, 3'b000} ? {sign, sign ? ~datO[30:0] : datI[30:0]} : 32'h00000000;

endmodule