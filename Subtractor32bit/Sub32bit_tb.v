`timescale 1ps/1ps

// `define SUB_DEBUG_ON

module Sub32bit_tb (
    // None
);
`ifdef SUB_DEBUG_ON
    wire [31:0] debug;
`endif 

    reg  [31:0] op1, op2;
    reg         cin;
    wire [31:0] diff;
    wire        cout;
    initial begin
        op1 = 32'h00000000;
        op2 = 32'h00000000;
        cin =  1'b0;
    end

    Sub32bit sub32bit(
        .op1(op1),
        .op2(op2),
        .cin(cin),
        .diff(diff),
        .cout(cout)
`ifdef SUB_DEBUG_ON
      , .debug(debug)
`endif     );

    initial begin
        #5 op1 = 32'h00000007; op2 = 32'h00000004; cin = 1'b0;  /*  7 - 4 with cin = 0 */
        #5 op1 = 32'h00000007; op2 = 32'h00000004; cin = 1'b1;  /*  7 - 4 with cin = 1 */
        #5 op1 = 32'h00000004; op2 = 32'h00000007; cin = 1'b0;  /*  4 - 7 with cin = 0 */
        #5 op1 = 32'h00000004; op2 = 32'h00000007; cin = 1'b1;  /*  4 - 7 with cin = 1 */
        #5 op1 = 32'h80000007; op2 = 32'h00000004; cin = 1'b0;  /* -7 - 4 with cin = 0 */
        #5 op1 = 32'h80000007; op2 = 32'h00000004; cin = 1'b1;  /* -7 - 4 with cin = 1 */
        #5 ;
    end

    initial begin
        $dumpfile("Sub32bit.vcd");
        $dumpvars(0, op1);
        $dumpvars(1, op2);
        $dumpvars(2, cin);
        $dumpvars(3, diff);
        $dumpvars(4, cout);
`ifdef SUB_DEBUG_ON
        $dumpvars(5, debug);
`endif 
    end

endmodule