`ifndef DECODER_V
`define DECODER_V

`include "RV32I.v"
`include "../IPs_shared/universal4inc.v"

module Decoder (
    input  wire [31:0] instr,
    output wire [ 6:0] op,
    output wire [ 4:0] rs1,
    output wire [ 4:0] rs2,
    output wire [ 4:0] rd,
    output wire [ 9:0] func,
    output wire [31:0] imm
);

    assign op = instr[6:0];

    assign {rs1, rs2, rd, func, imm} = `isEQ(instr[6:0], `INSTR_TYP_R) ? {rt_rs1, rt_rs2, rt_rd, rt_func,  32'b0 } :
                                       `isEQ(instr[6:0], `INSTR_TYP_ILD) |
                                       `isEQ(instr[6:0], `INSTR_TYP_IJR) |
                                       `isEQ(instr[6:0], `INSTR_TYP_I) ? {it_rs1,   5'b0, it_rd, it_func, it_imm } :
                                       `isEQ(instr[6:0], `INSTR_TYP_S) ? {st_rs1, st_rs2,  5'b0, st_func, st_imm } :
                                       `isEQ(instr[6:0], `INSTR_TYP_B) ? {bt_rs1, bt_rs2,  5'b0, bt_func, bt_imm } :
                                       `isEQ(instr[6:0], `INSTR_TYP_U) ? {  5'b0,   5'b0, ut_rd,   10'b0, ut_imm } :
                                       `isEQ(instr[6:0], `INSTR_TYP_J) ? {  5'b0,   5'b0, jt_rd,   10'b0, jt_imm } : 57'b0;

    wire [ 4:0] rt_rs1, rt_rs2, rt_rd;
    wire [ 9:0] rt_func;
    RT_decoder rt (
        .instr(instr),
        .rs1(rt_rs1),
        .rs2(rt_rs2),
        .rd(rt_rd),
        .func(rt_func)
    );

    wire [ 4:0] it_rs1, it_rd;
    wire [ 9:0] it_func;
    wire [31:0] it_imm;
    IT_decoder it (
        .instr(instr),
        .rs1(it_rs1),
        .rd(it_rd),
        .func(it_func),
        .imm(it_imm)
    );

    wire [ 4:0] st_rs1, st_rs2;
    wire [ 9:0] st_func;
    wire [31:0] st_imm;
    ST_decoder st (
        .instr(instr),
        .rs1(st_rs1),
        .rs2(st_rs2),
        .func(st_func),
        .imm(st_imm)
    );

    wire [ 4:0] bt_rs1, bt_rs2;
    wire [ 9:0] bt_func;
    wire [31:0] bt_imm;
    BT_decoder bt (
        .instr(instr),
        .rs1(bt_rs1),
        .rs2(bt_rs2),
        .func(bt_func),
        .imm(bt_imm)
    );

    wire [ 4:0] ut_rd;
    wire [31:0] ut_imm;
    UT_decoder ut (
        .instr(instr),
        .rd(ut_rd),
        .imm(ut_imm)
    );

    wire [ 4:0] jt_rd;
    wire [31:0] jt_imm;
    JT_decoder jt (
        .instr(instr),
        .rd(jt_rd),
        .imm(jt_imm)
    );

endmodule

module RT_decoder (
    input  wire [31:0] instr,
    output wire [ 4:0] rs1,
    output wire [ 4:0] rs2,
    output wire [ 4:0] rd,
    output wire [ 9:0] func
);

    assign func = {instr[31:25], 
                   instr[14:12]};
    assign rs1  =  instr[19:15];
    assign rs2  =  instr[24:20];
    assign rd   =  instr[11: 7];

endmodule

module IT_decoder (
    input  wire [31:0] instr,
    output wire [ 4:0] rs1,
    output wire [ 4:0] rd,
    output wire [ 9:0] func,
    output wire [31:0] imm
);

    assign rs1 = instr[19:15];
    assign rd  = instr[11: 7];
    assign {func, imm} = `isEQ(instr[14:12], 3'b001) | 
                         `isEQ(instr[14:12], 3'b101) ? {
                            /* func */ {instr[31:25], instr[14:12]},
                            /* imm  */ {27'b0, instr[24:20]}
                         } : {
                            /* func */ { 7'b0, instr[14:12]}, 
                            /* imm  */ {{20{instr[31]}}, instr[31:20]}
                         };

endmodule

module ST_decoder (
    input  wire [31:0] instr,
    output wire [ 4:0] rs1,
    output wire [ 4:0] rs2,
    output wire [ 9:0] func,
    output wire [31:0] imm
);

    assign func = {7'b0, 
                   instr[14:12]};
    assign rs1  =  instr[19:15];
    assign rs2  =  instr[24:20];
    assign imm  = {{20{instr[31]}},
                   instr[31:25], 
                   instr[11: 7]};

endmodule

module BT_decoder (
    input  wire [31:0] instr,
    output wire [ 4:0] rs1,
    output wire [ 4:0] rs2,
    output wire [ 9:0] func,
    output wire [31:0] imm
);

    assign func = {7'b0,
                   instr[14:12]};
    assign rs1  =  instr[19:15];
    assign rs2  =  instr[24:20];
    assign imm  = {{19{instr[31]}},
                   instr[31], 
                   instr[ 7], 
                   instr[30:25], 
                   instr[11: 8],
                    1'b0};

endmodule

module UT_decoder(
    input  wire [31:0] instr,
    output wire [ 4:0] rd,
    output wire [31:0] imm
);

    assign rd   =  instr[11: 7];
    assign imm  = {instr[31:12], 
                   12'h000};

endmodule

module JT_decoder (
    input  wire [31:0] instr,
    output wire [ 4:0] rd,
    output wire [31:0] imm
);

    assign rd   =  instr[11: 7];
    assign imm  = {{11{instr[31]}},
                   instr[31],
                   instr[19:12],
                   instr[20],
                   instr[30:21],
                    1'b0};

endmodule

`endif