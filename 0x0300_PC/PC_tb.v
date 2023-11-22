`timescale 1ps/1ps 

module PC_tb (
    // None
);

    reg         jmp;
    wire [31:0] dst, pc_val;

    reg  rst, clk;
    initial begin
         rst = 1'b1;
         clk = 1'b0;
    end
    always #5 clk = ~clk;

    initial begin
        #5 rst = 1'b0; jmp = 0;
        #1000 $finish;
    end

    PC pc(
        .rst(rst),
        .clk(clk),
        .jmp(jmp),
        .dst(dst),
        .val(pc_val)
    );

    initial begin
        $dumpfile("PC.vcd");
        $dumpvars(0, rst);
        $dumpvars(1, clk);
        $dumpvars(2, jmp);
        $dumpvars(3, dst);
        $dumpvars(4, pc_val);
    end

endmodule