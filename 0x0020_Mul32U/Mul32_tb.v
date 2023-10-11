`timescale 1ps/1ps    

module Mul32_tb(
    // None
);

    reg  [31:0] op1, op2;
    wire [63:0] res;
    initial begin
        op1 = 32'h00000000;
        op2 = 32'h00000000;
    end

    initial begin
        #5 op1 = 32'h00000009; op2 = 32'h00000007;
        #5 ;
    end

    Mul32 multiplier(
        .op1(op1),
        .op2(op2),
        .res(res)
    );

    initial begin
        $dumpfile("Mul32.vcd");
        $dumpvars(0, op1);
        $dumpvars(1, op2);
        $dumpvars(3, res);
    end

endmodule