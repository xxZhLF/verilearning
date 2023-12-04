`ifndef REGISTER_FILE_3_PORTs_V
`define REGISTER_FILE_3_PORTs_V

`include "../IPs_shared/universal4inc.v"

module REGs3P (
    input  wire        clk,
    input  wire        en4w,
    input  wire [ 4:0] addr_w,
    input  wire [31:0] data_i,
    input  wire [ 4:0] addr_r0,
    output wire [31:0] data_o0,
    input  wire [ 4:0] addr_r1,
    output wire [31:0] data_o1
) ;

    reg [31:0] RF [31:0];
    initial begin
        integer i;
        for (i = 0; i < 4096; ++i) begin
            RF[i] = 32'h0;
        end
    end

    always RF[0] = 32'h0;

    always @(posedge clk) begin
        if (~`isZERO(addr_w) & en4w) begin
            RF[addr_w] <= data_i;
        end else begin
        end
    end
    
    assign data_o0 = RF[addr_r0];
    assign data_o1 = RF[addr_r1];

endmodule

`endif 