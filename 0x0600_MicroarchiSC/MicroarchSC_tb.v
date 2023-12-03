`timescale 1ps/1ps 

module MicroarchSC_tb(
    // None
);

    reg rst, clk;
    initial begin
        {rst, clk} = 2'b10;
    end

    MicroarchSC core(
        .rst(rst),
        .clk(clk)
    );

    always #5 clk = ~clk;
    always @(negedge rst or posedge clk) begin
        if (rst) begin
        end else begin
        end
    end

    initial begin
        $dumpfile("MicroarchSC.vcd");
        $dumpvars(0, rst);
        $dumpvars(1, clk);
    end

endmodule