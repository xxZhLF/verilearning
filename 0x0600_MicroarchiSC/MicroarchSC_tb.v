`timescale 1ps/1ps 

module MicroarchSC_tb(
    // None
);

    reg rst, clk;
    initial begin
        {rst, clk} = 2'b10; 
    end

    reg [31:0] addr;
    reg [31:0] data;
    MicroarchSC core(
        .rst(rst),
        .clk(clk),
        .LoadProg_addr(addr),
        .LoadProg_data(data)
    );

    reg [31:0] instr[1023:0];
    initial begin 
        integer fd = $fopen("prog.mc", "r");
        if (fd == 0) begin
            $display("* WARNING: Test Program is NOT Exist!");
            $display("* SUGGEST: Run \"make prog.mc\" to generate, Please.");
            $finish;
        end 
        for (integer i = 0; !$feof(fd); i += 4) begin
            addr = i; $fscanf(fd, "%h\n", data); #10;
        end #10 rst = 1'b0;
        $finish();
    end 

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