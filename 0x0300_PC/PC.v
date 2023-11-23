`ifndef PROGRAM_COUNTER_V
`define PROGRAM_COUNTER_V

`include "../IPs_shared/MacroFunc.v"
`include "../0x0003_AdderLC32bit/AdderLC32bit.v"

`define NORMAL 2'b11
`define BRANCH 2'b01
`define UCJUMP 2'b10

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

    reg         USELESS;
    wire [31:0] pcNext;
    AdderLC32bit adder (
        .op1(`isEQ(mode, `BRANCH) ? offset : 32'd4),
        .op2(pc),
        .cin(1'b0),
        .sum(pcNext),
        .cout(USELESS)
    );

    always @(negedge rst or posedge clk) begin
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