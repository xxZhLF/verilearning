`timescale 1ps/1ps

// `define SUB_DEBUG_ON

module SubBR32bit_tb (
    // None
);
`ifdef SUB_DEBUG_ON
    wire [31:0] debug;
`endif 

    reg  [31:0] op1, op2;
    reg         bo;
    wire [31:0] diff;
    wire        bi;
    initial begin
        op1 = 32'h00000000;
        op2 = 32'h00000000;
        bo =  1'b0;
    end

    SubBR32bit substractor(
        .op1(op1),
        .op2(op2),
        .bo(bo),
        .diff(diff),
        .bi(bi)
`ifdef SUB_DEBUG_ON
      , .debug(debug)
`endif     );

    initial begin
        #5 op1 = 32'h00000007; op2 = 32'h00000004; bo = 1'b0;  /*  7 - 4 with bo = 0 */
        #5 op1 = 32'h00000007; op2 = 32'h00000004; bo = 1'b1;  /*  7 - 4 with bo = 1 */
        #5 op1 = 32'h00000004; op2 = 32'h00000007; bo = 1'b0;  /*  4 - 7 with bo = 0 */
        #5 op1 = 32'h00000004; op2 = 32'h00000007; bo = 1'b1;  /*  4 - 7 with bo = 1 */
        #5 op1 = 32'h80000007; op2 = 32'h00000004; bo = 1'b0;  /* -7 - 4 with bo = 0 */
        #5 op1 = 32'h80000007; op2 = 32'h00000004; bo = 1'b1;  /* -7 - 4 with bo = 1 */
        #5 ;
    end

    initial begin
        $dumpfile("SubBR32bit.vcd");
        $dumpvars(0, op1);
        $dumpvars(1, op2);
        $dumpvars(2, bo);
        $dumpvars(3, diff);
        $dumpvars(4, bi);
`ifdef SUB_DEBUG_ON
        $dumpvars(5, debug);
`endif 
    end

endmodule