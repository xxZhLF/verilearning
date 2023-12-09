`ifndef PROGRAM_COUNTER_V
`define PROGRAM_COUNTER_V

`include "PCIM.v"
`include "../IPs_shared/universal4inc.v"

module PC (
    input  wire        rst,
    input  wire        clk,
    input  wire [ 1:0] mode,
    input  wire [31:0] offset,
    input  wire [31:0] target,
    output wire [31:0] addr,
    output wire [31:0] addr_ret
);

    reg  [31:0] pc;

    wire [31:0] pcNext;
    Add32 adder (
        .op1(`isEQ(mode, `BRANCH) ? offset : 32'd4),
        .op2(pc),
        .sum(pcNext)
    );

    always @(posedge clk) begin
        if (rst) begin
            pc <= 32'h00000000;
        end else begin
            pc <= `isEQ(mode, `UCJUMP) ? target : pcNext;
        end
    end

    assign addr     = pc;
    assign addr_ret = pcNext;
    
endmodule

`endif 