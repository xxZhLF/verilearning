`timescale 1ps/1ps 

`include "PC.v"

module PC_tb (
    // None
);

    reg  [ 1:0] mode;
    reg  [31:0] offset, target;
    wire [31:0] addr, addr_ret;

    reg  rst, clk;
    initial begin
        rst = 1'b1;
        clk = 1'b0;
    end
    always #5 clk = ~clk;

    initial begin #5 rst = 1'b0;
        mode = `NORMAL; offset = 32'h00000000; target = 32'h00000000; #100
        mode = `BRANCH; offset = 32'hA0000000; target = 32'h00000000; #10
        mode = `NORMAL; offset = 32'h00000000; target = 32'h00000000; #100
        mode = `UCJUMP; offset = 32'h00000000; target = 32'hB0000000; #10
        mode = `NORMAL; offset = 32'h00000000; target = 32'h00000000; #100
        $finish;
    end

    PC pc(
        .rst(rst),
        .clk(clk),
        .mode(mode),
        .offset(offset),
        .target(target),
        .addr(addr),
        .addr_ret(addr_ret)
    );

    initial begin
        $dumpfile("PC.vcd");
        $dumpvars(0, rst);
        $dumpvars(1, clk);
        $dumpvars(2, mode);
        $dumpvars(3, offset);
        $dumpvars(4, target);
        $dumpvars(5, addr);
        $dumpvars(6, addr_ret);
    end

endmodule