`timescale 1ps/1ps

// `define SUB_DEBUG_ON

module Sub32_tb (
    // None
);
`ifdef SUB_DEBUG_ON
    wire [31:0] debug;
`endif 

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
`ifdef SUB_DEBUG_ON
      , .debug(debug)
`endif     
    );

    initial begin
        #5 op1 = 32'h00000004; op2 = 32'h00000007;  /*  4 -  7 */
        #5 op1 = 32'h00000004; op2 = 32'h80000007;  /*  4 - -7 */
        #5 op1 = 32'h80000004; op2 = 32'h00000007;  /* -4 -  7 */
        #5 op1 = 32'h80000004; op2 = 32'h80000007;  /* -4 - -7 */
        #5 op1 = 32'h00000007; op2 = 32'h00000004;  /*  7 -  4 */
        #5 op1 = 32'h80000007; op2 = 32'h00000004;  /* -7 -  4 */
        #5 op1 = 32'h00000007; op2 = 32'h80000004;  /*  7 - -4 */
        #5 op1 = 32'h80000007; op2 = 32'h80000004;  /* -7 - -4 */
        #5 ;
    end

    initial begin
        $dumpfile("Sub32.vcd");
        $dumpvars(0, op1);
        $dumpvars(1, op2);
        $dumpvars(2, diff);
`ifdef SUB_DEBUG_ON
        $dumpvars(3, debug);
`endif 
    end

endmodule