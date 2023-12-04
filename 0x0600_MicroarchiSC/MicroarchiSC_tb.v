`timescale 1ps/1ps 

module MicroarchiSC_tb(
    // None
);

    reg rst, clk;
    initial begin
        {rst, clk} = 2'b10; 
    end

    reg [31:0] addr;
    reg [31:0] data;
    MicroarchiSC core(
        .rst(rst),
        .clk(clk),
        .LoadProg_addr(addr),
        .LoadProg_data(data)
    );

    initial begin 
        integer fd = $fopen("prog.mc", "r");
        if (fd == 0) begin
            $display("* WARNING: Test Program is NOT Exist!");
            $display("* SUGGEST: Run \"make prog.mc\" to generate, Please.");
            $finish;
        end 
        for (integer i = 0; !$feof(fd); i += 4) begin
            reg [16*8-1 : 0] mnemonic_p1, mnemonic_p2; 
            addr = i; $fscanf(fd, "%h \t %s \t %s \n", data, mnemonic_p1, mnemonic_p2); #20;
        end #20 rst = 1'b0;
    end 

    reg [31:0] cnt;
    always #10 clk = ~clk;
    always @(negedge rst or posedge clk) begin
        if (rst) begin
            cnt <= 32'b0;
        end else begin
            if (cnt == 32'b1 << 9) begin
                $finish;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

    initial begin
        $dumpfile("MicroarchiSC.vcd");
        $dumpvars(0, rst);
        $dumpvars(1, clk);
    end

endmodule