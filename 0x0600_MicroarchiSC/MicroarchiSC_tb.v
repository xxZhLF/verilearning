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

    reg         A_EnWR,  B_EnWR;
    reg  [ 1:0]          B_Size;
    reg  [31:0] A_ABus,  B_ABus;
    reg  [31:0] A_DBusWI, B_DBusWI;
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
    reg  [31:0] I_DBus, D_DBusRI;
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
            A_EnWR = `MM_ENB_W; A_ABus = i; A_DBusWI = instr[i]; #20;
        end A_EnWR = `MM_ENB_W; A_ABus = i; A_DBusWI = {16'hFFFF, 16'h0000};
        #10 rst = 1'b0;
    end 

    reg is_Loading;
    reg [31:0] cnt;
    always @(posedge clk_base) begin
        if (rst) begin
            is_Loading <= 1'b1;
            cnt <= 32'b0;
        end else begin
            if (is_Loading) begin
                is_Loading <= 1'b0;
            end else begin
                is_Loading <= is_Loading;
            end
            cnt <= cnt + 32'b1;
        end
    end

    always @(posedge clk_core) begin
        if (rst) begin
        end else begin
            if (is_Loading) begin
            end else begin
                A_EnWR <= `MM_ENB_R;
                A_ABus <= I_ABus;
                I_DBus <= A_DBusRO;
                // $display("[%s]@%08H -> %08H ", B_DBusR == instr[B_ABus] ? "OK" : "NG", B_ABus, B_DBusR);
            end
        end
    end

    always @(posedge clk_core) begin
        if (rst) begin
        end else begin
            B_EnWR <= D_EnWR;
            B_Size <= D_Size;
            B_ABus  <= D_ABus;
            if (D_EnWR) begin
                B_DBusWI <= D_DBusWO;
            end else begin
                D_DBusRI <= B_DBusRO;
            end
        end
    end

    always @(posedge clk_core) begin
        if (rst) begin
        end else begin
            if (cnt > 32'b1 << 7) begin
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