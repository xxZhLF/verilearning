`timescale 1ps/1ps    

module AdderRC32bit_tb(
    // None
);

    reg  [31:0] op1, op2;
    reg         cin;
    wire [31:0] sum;
    wire        cout;
    initial begin
        op1 = 32'h00000000;
        op2 = 32'h00000000;
        cin =  1'b0;
    end

    initial begin
        integer i;
        for (i = 0; i < 32; ++i) begin
            #5 op1 = 32'h00000001 << i; op2 = 32'h00000001 << i; cin = 1'b0;
            #5 op1 = 32'h00000001 << i; op2 = 32'h00000001 << i; cin = 1'b1;
        end
        #5 op1 = 32'hFFFF0000; op2 = 32'h0000FFFF; cin = 1'b0;
        #5 op1 = 32'hFFFF0000; op2 = 32'h0000FFFF; cin = 1'b1;
        #5 ;
    end

    AdderRC32bit adder(
        .op1(op1),
        .op2(op2),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        $dumpfile("AdderRC32bit.vcd");
        $dumpvars(0, op1);
        $dumpvars(1, op2);
        $dumpvars(2, cin);
        $dumpvars(3, sum);
        $dumpvars(4, cout);
    end

endmodule