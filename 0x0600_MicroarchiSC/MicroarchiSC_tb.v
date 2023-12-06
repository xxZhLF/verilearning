`timescale 1ps/1ps 

`include "../0x0500_Mem/MemIO.v"

module MicroarchiSC_tb(
    // None
);

    reg rst, clk;
    initial begin
        {rst, clk} = 2'b10; 
    end

    reg                 D_EnWR;
    reg  [ 1:0]         D_Size;
    reg  [31:0] I_ABus, D_ABus;
    reg  [31:0]         D_DBusW;
    wire [31:0] I_DBus, D_DBusR;
    MicroarchiSC core(
        .rst(rst),
        .clk(clk),
        .instr(I_DBus),
        .dataI(D_DBusR),
        .dataO(D_DBusW),
        .store_or_load(D_EnWR),
        .width_of_data(D_Size),
        .locat_of_data(D_ABus),
        .where_is_instr(I_ABus)
    );

    reg         A_EnWR,  B_EnWR;
    reg  [ 1:0]          B_Size;
    reg  [31:0] A_ABus,  B_ABus;
    reg  [31:0] A_DBusW, B_DBusW;
    wire [31:0] A_DBusR, B_DBusR;
    Mem4K memory (
        .clk(clk),
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