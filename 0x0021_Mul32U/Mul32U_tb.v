`timescale 1ps/1ps

module Mul32U_tb(
    // None
);
    reg  [127:0] cnt;
    reg          rst, clk;
    reg  [ 31:0] op1, op2;
    wire [ 63:0] res;

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (cnt == 128'h0) begin
            {rst, clk} <= 2'b00;
            op1 <= 32'h00000000;
            op2 <= 32'h00000000;
            cnt <= 128'h00000000000000000000000000000000;
        end else if (cnt == 128'h1) begin
            rst <= 1'b1;
            op1 <= 32'h00000002; 
            op2 <= 32'h80000000;
        end else if (cnt == 128'h1F + 2) begin
            rst <= 1'b1;
        end else if (cnt == 128'h4F) begin
            $finish;
        end else begin
            rst <= 1'b0;
        end
        cnt <= cnt + 1;
    end

    Mul32U multiplier(
        .rst(rst),
        .clk(clk),
        .op1(op1),
        .op2(op2),
        .res(res)
    );

    initial begin
        $dumpfile("Mul32U.vcd");
        $dumpvars(0, clk);
        $dumpvars(0, rst);
        $dumpvars(2, op1);
        $dumpvars(3, op2);
        $dumpvars(4, res);
    end

endmodule