`timescale 1ps/1ps 

`include "Mem4K.v"

module Mem4K_tb (
    // None
);

    reg rst, clk;
    initial begin
        {rst, clk} = 2'b10;
    end always #10 clk = ~clk;

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
        .B_Size(B_Size),
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
        for (i = 2048; !$feof(fd); i += 4) begin
            $fscanf(fd, "%h\n", instr[i]);
            A_EnWR = `MM_ENB_W; A_ABus = i; A_DBusW = instr[i]; #20;
        end A_EnWR = `MM_ENB_W; A_ABus = i; A_DBusW = 32'hFFFF; #20;
        #10 rst = 1'b0;
    end 

    reg [31:0] cnt;
    initial cnt = 32'b0;
    always @(posedge clk) cnt <= rst ? 32'b0 : cnt + 1'b1;

    reg isInit;
    always @(negedge rst or posedge clk) begin
        if (rst) begin
            isInit <= 1'b1;
        end else begin
            B_EnWR <= `MM_ENB_R;
            B_Size <= `MW_Word;
            if (isInit) begin
                isInit <= 1'b0;
                B_ABus <= 32'd2048;
            end else begin
                B_ABus <= B_ABus + 4;
            end
        end
    end

    always @(negedge rst or negedge clk) begin
        if (rst) begin
        end else begin
            if (isInit) begin
            end else begin
                if (B_DBusR == 32'hFFFF) begin
                    $finish;
                end else begin
                    $display("[%s]@%08H", B_DBusR == instr[B_ABus-4] ? "OK" : "NG", B_ABus);
                end
            end
        end
    end

    initial begin
        $dumpfile("Mem4K.vcd");
        $dumpvars( 0, rst);
        $dumpvars( 1, clk);
        $dumpvars( 2, cnt);
        $dumpvars( 3, A_EnWR);
        $dumpvars( 4, A_ABus);
        $dumpvars( 5, A_DBusW);
        $dumpvars( 6, A_DBusR);
        $dumpvars( 7, B_EnWR);
        $dumpvars( 8, B_Size);
        $dumpvars( 9, B_ABus);
        $dumpvars(10, B_DBusW);
        $dumpvars(11, B_DBusR);
    end

endmodule