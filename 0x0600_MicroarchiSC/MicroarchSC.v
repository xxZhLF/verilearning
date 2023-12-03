`ifndef MICROARCHITECTURE_SINGLE_CYCLE_V
`define MICROARCHITECTURE_SINGLE_CYCLE_V

`include "../0x0500_Mem/MemIO.v"

module MicroarchSC (
    input wire        rst,
    input wire        clk,
    input wire [31:0] LoadProg_addr,
    input wire [31:0] LoadProg_data
);

    wire [ 1:0] pc_mode;
    wire [31:0] pc_offset;
    wire [31:0] pc_target;
    wire [31:0] pc_addr;
    wire [31:0] pc_addr_nxt;
    PC pc(
        .rst(rst),
        .clk(clk),
        .mode(pc_mode),
        .offset(pc_offset),
        .target(pc_target),
        .addr(pc_addr),
        .addr_ret(pc_addr_nxt)
    );

    wire        rf_en4w;
    wire [ 4:0] rf_wa, rf_r0a, rf_r1a;
    wire [31:0] rf_wd, rf_r0d, rf_r1d;
    REGs3P rf(
        .clk(clk),
        .en4w(rf_en4w),
        .addr_w0(rf_wa),
        .data_i0(rf_wd),
        .addr_r0(rf_r0a),
        .data_o0(rf_r0d),
        .addr_r1(rf_r1a),
        .data_o1(rf_r1d)
    );

    wire [15:0] alu_ctl;
    wire [31:0] alu_op1;
    wire [31:0] alu_op2;
    wire [31:0] alu_res;
    ALU32FF alu(
        .ctl(alu_ctl),
        .op1(alu_op1),
        .op2(alu_op2),
        .res(alu_res)
    );

    wire [31:0] decoder_instr;
    wire [ 6:0] decoder_op;
    wire [ 4:0] decoder_rs1;
    wire [ 4:0] decoder_rs2;
    wire [ 4:0] decoder_rd;
    wire [ 9:0] decoder_func;
    wire [31:0] decoder_imm;
    Decoder decoder(
        .instr(decoder_instr),
        .op(decoder_op),
        .rs1(decoder_rs1),
        .rs2(decoder_rs2),
        .rd(decoder_rd),
        .func(decoder_func),
        .imm(decoder_imm)
    );

    reg         mem_A_EnWR,  mem_B_EnWR;
    reg  [31:0] mem_A_ABus,  mem_B_ABus;
    reg  [31:0] mem_A_DBusW, mem_B_DBusW;
    wire [31:0] mem_A_DBusR, mem_B_DBusR;
    Mem4K mem(
        .clk(clk),
        .A_EnWR(mem_A_EnWR),
        .A_ABus(mem_A_ABus),
        .A_DBusW(mem_A_DBusW),
        .A_DBusR(mem_A_DBusR),
        .B_EnWR(mem_B_EnWR),
        .B_ABus(mem_B_ABus),
        .B_DBusW(mem_B_DBusW),
        .B_DBusR(mem_B_DBusR)
    );

    always @(negedge rst or posedge clk) begin
        if (rst) begin
            mem_A_EnWR  <= `ENB_W;
            mem_A_ABus  <= LoadProg_addr;
            mem_A_DBusW <= LoadProg_data;
        end else begin
        end
    end
    
endmodule

`endif 