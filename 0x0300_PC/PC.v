`ifndef PROGRAM_COUNTER_V
`define PROGRAM_COUNTER_V

`include "../0x0003_AdderLC32bit/AdderLC32bit.v"

module PC (
    input  wire        rst,
    input  wire        clk,
    input  wire        jmp,
    input  wire [31:0] dst,
    output wire [31:0] val
);

    reg  [31:0] pc;

    reg         USELESS;
    wire [31:0] pcNext;
    AdderLC32bit adder (
        .op1(pc),
        .op2(32'd4),
        .cin( 1'b0),
        .sum(pcNext),
        .cout(USELESS)
    );

    always @(negedge rst or posedge clk) begin
        if (rst) begin
            pc <= 32'h00000000;
        end else begin
            pc <= jmp ? dst : pcNext;
        end
    end

    assign val = pc;
    
endmodule

`endif 