`timescale 1ps/1ps 

module ALU32_tb (
    // None
);

    reg  [ 1:0] ctl;
    reg  [31:0] op1, op2;
    wire [31:0] res;

    initial begin
           op1 = 32'hFF; op2 = 32'h0F; ctl = 2'b00;
        #5                             ctl = 2'b01;
        #5                             ctl = 2'b10;
        #5                             ctl = 2'b11;
        #5 ;
    end

    ALU32 alu(
        .ctl(ctl),
        .op1(op1),
        .op2(op2),
        .res(res)
    );
    
    initial begin
        $dumpfile("ALU32.vcd");
        $dumpvars(0, ctl);
        $dumpvars(1, op1);
        $dumpvars(2, op2);
        $dumpvars(3, res);
    end

endmodule