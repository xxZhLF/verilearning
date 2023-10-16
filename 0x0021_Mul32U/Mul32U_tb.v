`timescale 1ps/1ps

module Mul32U_tb(
    // None
);
    reg         off, rst, clk;
    reg  [31:0] cnt;
    reg  [31:0] op1, op2;
    wire [63:0] res;

    initial begin
           off = 1'b1; clk = 1'b0;
        #5 off = 1'b0;
    end

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (off) begin
            {rst, clk} <= 2'b00;
            op1 <= 32'h00000000;
            op2 <= 32'h00000000;
            cnt <= 32'h00000000;
        end else begin
            case (cnt)
                32'h00000000: begin 
                    rst <= 1'b1; 
                    op1 <= 32'h00000001; 
                    op2 <= 32'hFFFFFFFF;
                end
                32'h00000020: begin
                    rst <= 1'b1; 
                    op1 <= 32'h00000000; 
                    op2 <= 32'h80000000;
                end
                32'h00000021: $finish;
                default:      rst <= 1'b0;
            endcase
            cnt <= cnt + 1;
        end
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