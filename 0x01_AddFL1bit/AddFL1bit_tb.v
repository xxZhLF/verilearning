`timescale 10ps/1ps    

module AddFL1bit_tb(
    // None
);

    reg  op1, op2, cin;
    wire sum, cout;
    initial begin
        op1 = 1'b0;
        op2 = 1'b0;
        cin = 1'b0;
    end

    initial begin
        repeat(10) begin
            #5 op1 = 1'b0; op2 = 1'b0; cin = 1'b0;
            #5 op1 = 1'b0; op2 = 1'b0; cin = 1'b1;
            #5 op1 = 1'b0; op2 = 1'b1; cin = 1'b0;
            #5 op1 = 1'b0; op2 = 1'b1; cin = 1'b1;
            #5 op1 = 1'b1; op2 = 1'b0; cin = 1'b0;
            #5 op1 = 1'b1; op2 = 1'b0; cin = 1'b1;
            #5 op1 = 1'b1; op2 = 1'b1; cin = 1'b0;
            #5 op1 = 1'b1; op2 = 1'b1; cin = 1'b1;
            #5 ;
        end
    end

    AddFL1bit adder(
        .op1(op1),
        .op2(op2),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        $dumpfile("AddFL1bit.vcd");
        $dumpvars(0, op1);
        $dumpvars(1, op2);
        $dumpvars(2, cin);
        $dumpvars(3, sum);
        $dumpvars(4, cout);
    end

endmodule