`timescale 1ps/1ps 

`include "../0x0500_Mem/MemIO.v"

module MicroarchiMC_tb(
    // None
);

    reg rst;
    initial rst = 1'b1; 

    reg clk;
    initial clk = 1'b0;
    always #10 clk = ~clk; 

    wire        A_EnWR,  B_EnWR;
    wire [ 1:0]          B_Size;
    wire [31:0] A_ABus,  B_ABus;
    wire [31:0] A_DBusWI, B_DBusWI;
    wire [31:0] A_DBusRO, B_DBusRO;
    Mem4K memory (
        .clk(clk),
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

    reg [31:0] cnt;
    always @(posedge clk) 
        cnt <= rst ? 32'b0 
                   : cnt + 32'b1;

    wire                D_EnWR;
    wire [ 1:0]         D_Size;
    wire [31:0] I_ABus, D_ABus;
    wire [31:0]         D_DBusWO;
    wire [31:0] I_DBus, D_DBusRI;
    MicroarchiMC core(
        .rst(rst),
        .clk(clk),
        .cnt(cnt),
        .instr(I_DBus),
        .dataI(D_DBusRI),
        .dataO(D_DBusWO),
        .store_or_load(D_EnWR),
        .width_of_data(D_Size),
        .locat_of_data(D_ABus),
        .where_is_instr(I_ABus)
    );

    reg        A_EnWRex;
    reg [31:0] A_ABusEX, A_DBusEX;
    initial begin 
        integer f = $fopen("prog.rv", "r");
        if (f == 0) begin
            $display("* WARNING: Test Program is NOT Exist!");
            $display("* SUGGEST: Run \"make prog.rv\" to generate, Please.");
            $finish;
        end A_EnWRex = `MM_ENB_W;
        for (integer i = 2048; !$feof(f); i += 4) begin
            reg [16*8-1 : 0] mnemonic_p1, mnemonic_p2; A_ABusEX = i; $fscanf(
            f, "%h \t %s \t %s \n", A_DBusEX, mnemonic_p1, mnemonic_p2); #20;
        end $fclose(f); 
        #30 rst = 1'b0; A_EnWRex = `MM_ENB_R;
    end 

    assign A_EnWR = A_EnWRex;
    assign A_ABus = rst ? A_ABusEX : I_ABus;
    assign A_DBusWI = A_DBusEX;
    assign I_DBus   = A_DBusRO;

    assign B_EnWR = D_EnWR;
    assign B_Size = D_Size;
    assign B_ABus = D_ABus;
    assign B_DBusWI = D_DBusWO;
    assign D_DBusRI = B_DBusRO;

    reg isFinished; integer f;
    initial isFinished = 1'b0;
    always @(posedge clk) begin
        if (rst & ~isFinished) begin
        end else begin
            if ((cnt > {32'b1 << 32'd12})
                || (I_ABus == {32{1'b0}})) begin
                {rst, cnt} <= {1'b1, 32'd4};
                f = $fopen("RAM.dump", "w");
                A_ABusEX <= 32'b00;
                isFinished <= 1'b1;
            end else if (isFinished) begin
                if (cnt < 32'd04096) begin
                    A_ABusEX <= cnt;
                    $fdisplay(f, "@[%08H] %08H %s", A_ABus, A_DBusRO, A_DBusRO != 32'b0 ? "*" : " ");
                end else begin
                    $fdisplay(f, "@[%08H] %08H %s", A_ABus, A_DBusRO, A_DBusRO != 32'b0 ? "*" : " ");
                    $finish;
                end cnt <= cnt + 32'd4;
            end else begin
            end
        end
    end

    initial begin
        $dumpfile("MicroarchiMC.vcd");
        $dumpvars(0, rst);
        $dumpvars(1, clk);
        $dumpvars(2, cnt);
    end

endmodule