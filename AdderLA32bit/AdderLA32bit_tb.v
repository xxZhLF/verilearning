module AdderLA32bit_tb(
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
        repeat(10) begin
            #5 op1 = 32'h00000007; op2 = 32'h00000007; cin = 1'b0;
            #5 op1 = 32'h00000007; op2 = 32'h00000007; cin = 1'b1;
            #5 op1 = 32'hF0F0F0F0; op2 = 32'h0F0F0F0F; cin = 1'b1;
            #5 ;
        end
    end

    AdderLA32bit adder(
        .op1(op1),
        .op2(op2),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        $dumpfile("AdderLA32bit.vcd");
        $dumpvars(0, op1);
        $dumpvars(1, op2);
        $dumpvars(2, cin);
        $dumpvars(3, sum);
        $dumpvars(4, cout);
    end

endmodule