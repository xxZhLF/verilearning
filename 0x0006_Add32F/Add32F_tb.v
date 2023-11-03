module Add32F_tb (
    // None
);

    reg  [31:0] op1, op2;
    wire [31:0] sum;
    initial begin
        op1 = 32'h00000000;
        op2 = 32'h00000000;
    end

    Add32F wrapper(
        .op1(op1),
        .op2(op2),
        .sum(sum)
    );

    initial begin
        $dumpfile("Add32.vcd");
        $dumpvars(0, op1);
        $dumpvars(1, op2);
        $dumpvars(3, sum);
    end

endmodule