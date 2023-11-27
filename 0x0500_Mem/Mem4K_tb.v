`timescale 1ps/1ps 

module Mem4K_tb (
    // None
);

    reg clk;
    initial begin
        clk = 1'b0;
    end always #5 clk = ~ clk;

    reg         A_EnWR,  B_EnWR;
    reg  [31:0] A_ABus,  B_ABus;
    reg  [31:0] A_DBusW, B_DBusW;
    wire [31:0] A_DBusR, B_DBusR;
    Mem4K memory (
        .clk(clk),
        .A_EnWR(A_EnWR),
        .A_ABus(A_ABus),
        .A_DBusW(A_DBusW),
        .A_DBusR(A_DBusR),
        .B_EnWR(B_EnWR),
        .B_ABus(B_ABus),
        .B_DBusW(B_DBusW),
        .B_DBusR(B_DBusR)
    );

    always @(posedge clk) begin
    end

    initial begin
        $dumpfile("Mem4K.vcd");
        $dumpvars(0, clk);
    end

endmodule