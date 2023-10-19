`timescale 1ps/1ps    

module AdderCS32bit_tb(
    // None
);

    reg  [31:0] op1, op2, op3;
    reg         cin;
    wire [31:0] sum;
    wire        cout;
    initial begin
        op1 = 32'h00000000;
        op2 = 32'h00000000;
        op3 = 32'h00000000;
        cin =  1'b0;
    end

    initial begin
        integer i;
        for (i = 0; i < 32; i += 8) begin
            #5 op1 = 32'b10010101 << i; op2 = 32'b00110011 << i; op3 = 32'b00001111 << i; cin = 1'b0;
            #5 op1 = 32'b10010101 << i; op2 = 32'b00110011 << i; op3 = 32'b00001111 << i; cin = 1'b1;
        end
        #5 op1 = 32'b0110_1010_1101_0101_0111_0110_0101_0101;
           op2 = 32'b1101_1101_1010_1011_1101_1101_1010_1111;
           op3 = 32'b1011_0111_0111_1110_1010_1011_1111_1011;
           cin = 1'b0;
        #5 cin = 1'b1;
        #5 op1 = {4'b0111,28'h0}; op2 = {4'b0111,28'h0}; op3 = {4'b0111,28'h0}; cin = 1'b0; 
        #5 op1 = {4'b1111,28'h0}; op2 = {4'b1111,28'h0}; op3 = {4'b1111,28'h0}; cin = 1'b0; 
        #5;
    end

    AdderCS32bit adder(
        .op1(op1),
        .op2(op2),
        .op3(op3),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        $dumpfile("AdderCS32bit.vcd");
        $dumpvars(0, op1);
        $dumpvars(1, op2);
        $dumpvars(2, cin);
        $dumpvars(3, sum);
        $dumpvars(4, cout);
    end

endmodule