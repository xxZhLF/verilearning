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
            __cnt <= 32'h00000000;
        end else begin
            __cnt <= ppcnt;
        end
    end

    assign cnt = __cnt; 

endmodule