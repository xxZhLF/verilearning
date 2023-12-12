`timescale 1ps/1ps 

`include "../0x0500_Mem/MemIO.v"

module MicroarchiSC_tb(
    // None
);

    reg rst;
    initial rst = 1'b1; 

    reg clk_base;
    initial clk_base = 1'b0;
    always #10 clk_base = ~clk_base;

    wire        A_EnWR,  B_EnWR;
    wire [ 1:0]          B_Size;
    wire [31:0] A_ABus,  B_ABus;
    wire [31:0] A_DBusWI, B_DBusWI;
    wire [31:0] A_DBusRO, B_DBusRO;
    Mem4K memory (
        .clk(clk_base),
        .A_EnWR(A_EnWR),
        .A_ABus(A_ABus),
        .A_DBusW(A_DBusWI),
        .A_DBusR(A_DBusRO),
        .B_EnWR(B_EnWR),
        .B_Size(B_Size),
        .B_ABus(B_ABus),
        .B_DBusW(B_DBusWI),
        .B_DBusR(B_DBusRO)
    );

    reg clk_core;
    initial clk_core = 1'b0;
    always @(posedge clk_base) 
        clk_core <= ~clk_core;

    wire                D_EnWR;
    wire [ 1:0]         D_Size;
    wire [31:0] I_ABus, D_ABus;
    wire [31:0]         D_DBusWO;
    wire [31:0] I_DBus, D_DBusRI;
    MicroarchiSC core(
        .rst(rst),
        .clk_LF(clk_core),
        .clk_HF(clk_base),
        .instr(I_DBus),
        .dataI(D_DBusRI),
        .dataO(D_DBusWO),
        .store_or_load(D_EnWR),
        .width_of_data(D_Size),
        .locat_of_data(D_ABus),
        .where_is_instr(I_ABus)
    );

    reg [31:0] instr[1023:0];
    reg [31:0] A_ABusEX, A_DBusEX;
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
            A_ABusEX = i; A_DBusEX = instr[i]; #20;
        end A_ABusEX = i; A_DBusEX = {16'hFFFF, 16'h0000};
        #20 rst = 1'b0;
    end 

    assign A_EnWR = rst ? `MM_ENB_W : `MM_ENB_R;
    assign A_ABus = rst ?  A_ABusEX :  I_ABus;
    assign A_DBusWI = A_DBusEX;
    assign I_DBus   = A_DBusRO;

    assign B_EnWR = D_EnWR;
    assign B_Size = D_Size;
    assign B_ABus = D_ABus;
    assign B_DBusWI = D_DBusWO;
    assign D_DBusRI = B_DBusRO;

    reg [31:0] cnt;
    always @(posedge clk_core) 
        cnt <= rst ? 32'b0 : cnt + 32'b1;

    always @(posedge clk_core) begin
        if (rst) begin
        end else begin
            if (cnt > {32'b1 << 32'd9}) begin
                $finish;
            end else begin
            end
            if (I_DBus == 32'h00008067) begin
                $finish;
            end else begin
            end
        end
    end

    initial begin
        $dumpfile("MicroarchiSC.vcd");
        $dumpvars(0, rst);
        $dumpvars(1, clk_base);
        $dumpvars(2, clk_core);
        $dumpvars(3, cnt);
    end

endmodule