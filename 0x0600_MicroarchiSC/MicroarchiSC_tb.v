`timescale 1ps/1ps 

`include "../0x0500_Mem/MemIO.v"

module MicroarchiSC_tb(
    // None
);

    reg rst;
    initial rst = 1'b1; 

    // initial begin 
    //     integer fd = $fopen("prog.mc", "r");
    //     if (fd == 0) begin
    //         $display("* WARNING: Test Program is NOT Exist!");
    //         $display("* SUGGEST: Run \"make prog.mc\" to generate, Please.");
    //         $finish;
    //     end 
    //     for (integer i = 2048; !$feof(fd); i += 4) begin
    //         reg [16*8-1 : 0] mnemonic_p1, mnemonic_p2; 
    //         addr = i; $fscanf(fd, "%h \t %s \t %s \n", data, mnemonic_p1, mnemonic_p2); #20;
    //     end #20 rst = 1'b0;
    // end 

    reg [31:0] instr[1023:0];
    initial begin 
        integer  i = 0;
        integer fd = $fopen("prog.mc", "r");
        if (fd == 0) begin
            $display("* WARNING: Test Program is NOT Exist!");
            $display("* SUGGEST: Run \"make prog.mc\" to generate, Please.");
            $finish;
        end
        for (i = 2048; !$feof(fd); i += 4) begin
            reg [16*8-1 : 0] mnemonic_p1, mnemonic_p2; 
            $fscanf(fd, "%h \t %s \t %s \n", instr[i], mnemonic_p1, mnemonic_p2);
            A_EnWR = `MM_ENB_W; A_ABus = i; A_DBusW = instr[i]; #20;
        end A_EnWR = `MM_ENB_W; A_ABus = i; A_DBusW = 32'hFFFF; #20;
        #10 rst = 1'b0;
    end 

    reg clkMEM;
    initial clkMEM = 1'b0;
    always #10 clkMEM = ~clkMEM;

    reg         A_EnWR,  B_EnWR;
    reg  [ 1:0]          B_Size;
    reg  [31:0] A_ABus,  B_ABus;
    reg  [31:0] A_DBusW, B_DBusW;
    wire [31:0] A_DBusR, B_DBusR;
    Mem4K memory (
        .clk(clkMEM),
        .A_EnWR(A_EnWR),
        .A_ABus(A_ABus),
        .A_DBusW(A_DBusW),
        .A_DBusR(A_DBusR),
        .B_EnWR(B_EnWR),
        .B_Size(B_Size),
        .B_ABus(B_ABus),
        .B_DBusW(B_DBusW),
        .B_DBusR(B_DBusR)
    );

    reg [31:0] cntMEM;
    always @(negedge rst or posedge clkMEM) begin
        if (rst) begin
            cntMEM <= 32'b0;
        end else begin
            if (cntMEM == 32'b1 << 9) begin
                $finish;
            end else begin
                cntMEM <= cntMEM + 1;
            end
        end
    end

    reg clkCPU;
    initial clkCPU = 1'b0;
    always @(posedge clkMEM) clkCPU <= ~clkCPU;

    reg                 D_EnWR;
    reg  [ 1:0]         D_Size;
    reg  [31:0] I_ABus, D_ABus;
    reg  [31:0]         D_DBusW;
    wire [31:0] I_DBus, D_DBusR;
    MicroarchiSC core(
        .rst(rst),
        .clk(clkCPU),
        .instr(I_DBus),
        .dataI(D_DBusR),
        .dataO(D_DBusW),
        .store_or_load(D_EnWR),
        .width_of_data(D_Size),
        .locat_of_data(D_ABus),
        .where_is_instr(I_ABus)
    );

    reg [31:0] cntCPU;
    always @(negedge rst or posedge clkCPU) begin
        if (rst) begin
            cntCPU <= 32'b0;
        end else begin
            if (cntCPU == 32'b1 << 9) begin
                $finish;
            end else begin
                cntCPU <= cntCPU + 1;
            end
        end
    end

    initial begin
        $dumpfile("MicroarchiSC.vcd");
        $dumpvars(0, rst);
        $dumpvars(1, clkMEM);
        $dumpvars(2, cntMEM);
        $dumpvars(3, clkCPU);
        $dumpvars(4, cntCPU);
    end

endmodule