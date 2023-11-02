`timescale 1ps/1ps 

module REGs3P_tb(
    // None
);

    reg         clk;
    reg  [ 7:0] _cnt;

    reg         en4w;
    reg  [ 4:0] addr_r0, addr_r1, addr_w0;
    reg  [31:0] data_i0;
    wire [31:0] data_o0, data_o1;

    initial begin
         clk = 1'b0;
        _cnt = 8'b0;
        data_i0 = 32'b0;
    end

    always #5 clk = ~clk;

    always @(posedge clk) _cnt <= _cnt + 8'b1;

    always @(posedge clk) begin
        if (_cnt < 8'h40) begin
            en4w <= 1'b1;
            addr_w0 <= {_cnt / 8'h02}[4:0];
        end else if ((8'h1F < _cnt) & (_cnt < 8'h50)) begin
            en4w <= 1'b0;
            addr_r0 <= {(_cnt - 8'h40) * 8'h02 + 8'b0}[4:0];
            addr_r1 <= {(_cnt - 8'h40) * 8'h02 + 8'b1}[4:0];
        end else begin
            $finish;
        end
    end

    always @(negedge clk) begin
        if (_cnt % 8'h02 == 8'b1) begin
            data_i0 = 32'b1 << {_cnt / 8'h02}[4:0];
        end
    end

    REGs3P regs(
        .clk(clk),
        .en4w(en4w),
        .addr_w0(addr_w0),
        .data_i0(data_i0),
        .addr_r0(addr_r0),
        .data_o0(data_o0),
        .addr_r1(addr_r1),
        .data_o1(data_o1)
    );

    initial begin
        $dumpfile("REGs3P.vcd");
        $dumpvars(0, clk);
        $dumpvars(1, addr_r0);
        $dumpvars(2, data_o0);
        $dumpvars(3, addr_r1);
        $dumpvars(4, data_o1);
        $dumpvars(5, addr_w1);
        $dumpvars(6, data_i1);
    end

endmodule