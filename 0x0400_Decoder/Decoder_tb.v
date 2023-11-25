`timescale 1ps/1ps 

module Decoder_tb(
    // None
);

    wire [31:0] instr;
    wire [ 6:0] op;
    wire [ 4:0] rs1, rs2, rd;
    wire [ 9:0] func;
    wire [11:0] imms;
    wire [19:0] imml;
    Decoder decoder(
        .instr(instr),
        .op(op),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .func(func),
        .imms(imms),
        .imml(imml)
    );

    initial begin
        integer fd = $fopen("prog.mc", "r");
        if (fd == 0) begin
            $display("* WARNING: Test Program is NOT Exist!");
            $display("* SUGGEST: Run \"make prog.mc\" to generate, Please.");
            $finish;
        end
        while(!$feof(fd)) begin
            reg [  32-1 : 0] instruction;
            reg [ 8*8-1 : 0] mnemonic_p1;
            reg [16*8-1 : 0] mnemonic_p2;
            $fscanf(fd, "%h \t %s \t %s \n", instruction, mnemonic_p1, mnemonic_p2);
            $display("%s %s", mnemonic_p1, mnemonic_p2);
        end
        $fclose(fd);
        $finish;
    end

    initial begin
        $dumpfile("Decoder.vcd");
        $dumpvars(0, instr);
        $dumpvars(1, op);
        $dumpvars(2, rs1);
        $dumpvars(3, rs2);
        $dumpvars(4, rd);
        $dumpvars(5, func);
        $dumpvars(6, imms);
        $dumpvars(7, imml);
    end

endmodule