`ifndef MUL_32BIT_UNSIGNED_V_SEQUENTIAL
`define MUL_32BIT_UNSIGNED_V_SEQUENTIAL

`include "../IPs_shared/Shift.v"
`include "../IPs_shared/Add64.v"
`include "../IPs_shared/Counter.v"
`include "../IPs_shared/Multiplexer.v"

module Mul32U (
    input  wire        rst,
    input  wire        clk,
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [63:0] res
);

    wire [31:0] cnt;
    Counter32 counter(
        .rst(rst),
        .clk(clk),
        .cnt(cnt)
    );

    wire flg;
    MUX32to1 mux(
        .idx(cnt[4:0]),
        .set(op2),
        .ele(flg)
    );

    wire [63:0] itm;
    ShiftL64 shift(
        .n(flg ^ 1'b0 ? cnt[7:0] : 8'h40),
        .in({32'h00000000, op1}),
        .out(itm)
    );

    reg [63:0] sum, tmp;
    AddLC64 adder(
        .op1(itm),
        .op2(sum),
        .sum(tmp)
    );

    always @(negedge rst or posedge clk) begin
        if (rst) begin
            sum <= 64'h0000000000000000; 
        end else begin
            sum <= tmp;
        end
    end

    assign res = sum;

endmodule

`endif 