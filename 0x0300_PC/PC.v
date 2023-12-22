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

    always @(negedge rst or posedge clk) begin
        if (rst) begin
            pc <= target;
        end else begin
            // pc <= `isEQ(mode, `UCJUMP) ? target : pcNext;
            case (mode)
                `NORMAL,
                `BRANCH: pc <= pcNext;
                `UCJUMP: pc <= target;
                `STOP_C: pc <= pc;
                default: pc <= 32'b0;
            endcase
        end
    end

    assign addr     = pc;
    assign addr_ret = pcNext;
    
endmodule

`endif 