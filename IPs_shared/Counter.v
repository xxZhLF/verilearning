`ifndef IPs_SHARED_COUNTER_V
`define IPs_SHARED_COUNTER_V

module Counter32(
    input  wire        rst,
    input  wire        clk,
    output wire [31:0] cnt
);

    reg  [31:0] __cnt;
    wire [31:0] ppcnt;
    Add32 adder(
        .op1(32'h00000001),
        .op2(__cnt),
        .sum(ppcnt)
    );

    always @(negedge rst or posedge clk) begin
        if (rst) begin
            __cnt <= 32'hFFFFFFFF;
        end else begin
            __cnt <= ppcnt;
        end
    end

    assign cnt = __cnt; 

endmodule

`endif 