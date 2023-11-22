module Decoder_tb(
    // None
);

    reg  rst, clk;
    initial begin
         rst = 1'b1;
         clk = 1'b0;
    end
    always #5 clk = ~clk;

    wire [31:0] instr;
    wire [ 4:0] rs1, rs2, rd;
    wire [ 9:0] func;
    wire [11:0] imms;
    wire [19:0] imml;
    Decoder decoder(
        .instr(instr),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .func(func),
        .imms(imms),
        .imml(imml)
    );

    initial begin
        $dumpfile("Decoder.vcd");
        $dumpvars(0, rst);
        $dumpvars(1, clk);
        $dumpvars(2, instr);
        $dumpvars(3, rs1);
        $dumpvars(4, rs2);
        $dumpvars(5, rd);
        $dumpvars(6, func);
        $dumpvars(7, imms);
        $dumpvars(8, imml);
    end

endmodule