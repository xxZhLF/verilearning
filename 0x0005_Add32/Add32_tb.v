`timescale 1ps/1ps    

module Add32_tb(
    // None
);

    reg  [31:0] op1, op2;
    wire [31:0] sum;
    initial begin
        op1 = 32'h00000000;
        op2 = 32'h00000000;
    end

    initial begin
        integer i;
        for (i = 0; i < 32; ++i) begin
            #5 op1 = 32'h00000001 << i; op2 = 32'h00000001 << i;
        end
        #5 op1 = 32'hFFFF0000; op2 = 32'h0000FFFF;
        #5 ;
    end

    Add32 wrapper(
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