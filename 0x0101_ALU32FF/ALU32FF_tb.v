`timescale 1ps/1ps 

module ALU32FF_tb (
    // None
);

    reg  [ 3:0] ctl;
    reg  [31:0] rs1, rs2;
    wire [31:0] rd;

    initial begin
        $dumpfile("ALU32FF.vcd");
    end

endmodule