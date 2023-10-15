`include "Shift.v"
`include "Add64.v"
`include "Multiplexer.v"

module Mul32U (
    input  wire        rst,
    input  wire        clk,
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [63:0] res
);

    reg  [ 4:0] mux_idx;
    reg  [31:0] mux_set;
    wire        mux_ele;
    MUX32to1 mux(
        .idx(mux_idx),
        .set(mux_set),
        .ele(mux_ele)
    );

    reg  [ 7:0] shift_n;
    reg  [63:0] shift_in;
    wire [63:0] shift_out;
    ShiftL64 shift(
        .n(shift_n),
        .in(shift_in),
        .out(shift_out)
    );

    reg  [63:0] adder_op1;
    reg  [63:0] adder_op2;
    wire [63:0] adder_sum;
    Add64 adder(
        .op1(adder_op1),
        .op2(adder_op2),
        .sum(adder_sum)
    );

    reg  [63:0] ppcnt_op1;
    reg  [63:0] ppcnt_op2;
    wire [63:0] ppcnt_sum;
    Add64 ppcnt(
        .op1(ppcnt_op1),
        .op2(ppcnt_op2),
        .sum(ppcnt_sum)
    );

    reg [63:0] cnt, sum, partial;
    reg [63:0] op1EX;
    assign op1EX = {32'h00000000, op1};
    assign res = sum;
    always @(negedge rst or posedge clk) begin
        if (rst) begin
            cnt <= 64'h0000000000000000;
            sum <= 64'h0000000000000000; 
        end else begin
            mux_idx   <= cnt[4:0];
            mux_set   <= op2;
            shift_n   <= mux_ele ^ 1'b0 ? cnt[7:0] : 8'h40;
            shift_in  <= op1EX;
            adder_op1 <= shift_out;
            adder_op2 <= sum;
            sum       <= adder_sum;
            ppcnt_op1 <= 64'h0000000000000001;
            ppcnt_op2 <= cnt;
            cnt       <= ppcnt_sum;
        end
    end

endmodule