`timescale 1ps/1ps 

module ALU32FF_tb (
    // None
);

    reg  [23:0] ctrl;
    reg  [31:0] op1, op2;
    wire [31:0] res;

    ALU32FF alu(
        .ctrl(ctrl),
        .op1(op1),
        .op2(op2),
        .res(res)
    );

    initial begin
        $dumpfile("ALU32FF.vcd");
    end

endmodule