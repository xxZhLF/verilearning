`timescale 1ps/1ps 

`include "Mem4K.v"

module Mem4K_tb (
    // None
);

    reg rst, clk;
    initial begin
        {rst, clk} = 2'b10;
    end

    reg         A_EnWR,  B_EnWR;
    reg  [ 1:0]          B_Size;
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
        .B_Size(),
        .B_ABus(B_ABus),
        .B_DBusW(B_DBusW),
        .B_DBusR(B_DBusR)
    );

    reg [31:0] instr[1023:0];
    initial begin 
        integer  i = 0;
        integer fd = $fopen("prog.mc", "r");
        if (fd == 0) begin
            $display("* WARNING: Test Program is NOT Exist!");
            $display("* SUGGEST: Run \"make prog.mc\" to generate, Please.");
            $finish;
        end
        for (i = 0; !$feof(fd); i += 4) begin
            $fscanf(fd, "%h\n", instr[i]);
            A_EnWR = `ENB_W; A_ABus = i; A_DBusW = instr[i]; #10;
        end A_EnWR = `ENB_W; A_ABus = i; A_DBusW = 32'hFFFF; #10;
        rst = 1'b0; #5;
    end 

    always #5 clk = ~clk;
    always @(negedge rst or posedge clk) begin
        if (rst) begin
            B_ABus <= 32'h0;
        end else begin
            B_EnWR <= `ENB_R;
            if (B_DBusR != 32'hFFFF) begin
                if (B_DBusR == instr[B_ABus]) begin
                    B_ABus <= B_ABus + 4;
                    $display("[OK] %H", B_DBusR);
                end else begin
                    $display("Test [NG] @%H: %H != %H.", 
                             B_ABus, B_DBusR, instr[B_ABus]);
                    $finish;
                end
            end else begin
                $finish;
            end
        end
    end

endmodule