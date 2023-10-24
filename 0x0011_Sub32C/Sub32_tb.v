`timescale 1ps/1ps

module Sub32_tb (
    // None
);

    reg  [31:0] op1, op2;
    wire [31:0] diff;
    initial begin
        op1 = 32'h00000000;
        op2 = 32'h00000000;
    end

    Sub32 subtractor(
        .op1(op1),
        .op2(op2),
        .diff(diff)   
    );

    initial begin
        #5 op1 =  32'd4; op2 =  32'd7;
        #5 op1 =  32'd4; op2 = -32'd7;
        #5 op1 = -32'd4; op2 =  32'd7;
        #5 op1 = -32'd4; op2 = -32'd7;
        #5 op1 =  32'd7; op2 =  32'd4;
        #5 op1 = -32'd7; op2 =  32'd4;
        #5 op1 =  32'd7; op2 = -32'd4;
        #5 op1 = -32'd7; op2 = -32'd4;
        #5 ;
    end

    initial begin
        $dumpfile("Sub32.vcd");
        $dumpvars(0, op1);
        $dumpvars(1, op2);
        $dumpvars(2, diff);
    end

endmodule