`ifndef DECODER_V
`define DECODER_V

`include "../IPs_shared/MacroFunc.v"

`define DTYP_R 7'b0110011
`define DTYP_I 7'b0010011
`define DTYP_S 7'b0100011
`define DTYP_B 7'b1100011
`define DTYP_U 7'b0110111
`define DTYP_J 7'b1101111

module Decoder (
    input  wire [31:0] instr,
    output wire [ 6:0] op,
    output wire [ 4:0] rs1,
    output wire [ 4:0] rs2,
    output wire [ 4:0] rd,
    output wire [ 9:0] func,
    output wire [11:0] imms,
    output wire [19:0] imml
);

    assign {rs1, rs2, rd, func, imms, imml} = `isEQ(instr[6:0], `DTYP_R) ? {rt_rs1, rt_rs2, rt_rd, rt_func,  12'b0,  20'b0} :
                                              `isEQ(instr[6:0], `DTYP_I) ? {it_rs1,   5'b0, it_rd, it_func, it_imm,  20'b0} :
                                              `isEQ(instr[6:0], `DTYP_S) ? {st_rs1, st_rs2,  5'b0, st_func, st_imm,  20'b0} :
                                              `isEQ(instr[6:0], `DTYP_B) ? {bt_rs1, bt_rs2,  5'b0, bt_func, bt_imm,  20'b0} :
                                              `isEQ(instr[6:0], `DTYP_U) ? {  5'b0,   5'b0, ut_rd,   10'b0,  12'b0, ut_imm} :
                                              `isEQ(instr[6:0], `DTYP_J) ? {  5'b0,   5'b0, jt_rd,   10'b0,  12'b0, jt_imm} : 57'b0;

    wire [ 4:0] rt_rs1, rt_rs2, rt_rd;
    wire [ 9:0] rt_func;
    RT_decoder rt (
        .body(instr[31:7]),
        .rs1(rt_rs1),
        .rs2(rt_rs2),
        .rd(rt_rd),
        .func(rt_func)
    );

    wire [ 4:0] it_rs1, it_rd;
    wire [ 9:0] it_func;
    wire [11:0] it_imm;
    IT_decoder it (
        .body(instr[31:7]),
        .rs1(it_rs1),
        .rd(it_rd),
        .func(it_func),
        .imm(it_imm)
    );

    wire [ 4:0] st_rs1, st_rs2;
    wire [ 9:0] st_func;
    wire [11:0] st_imm;
    ST_decoder st (
        .body(instr[31:7]),
        .rs1(st_rs1),
        .rs2(st_rs2),
        .func(st_func),
        .imm(st_imm)
    );

    wire [ 4:0] bt_rs1, bt_rs2;
    wire [ 9:0] bt_func;
    wire [11:0] bt_imm;
    BT_decoder bt (
        .body(instr[31:7]),
        .rs1(bt_rs1),
        .rs2(bt_rs2),
        .func(bt_func),
        .imm(bt_imm)
    );

    wire [ 4:0] ut_rd;
    wire [19:0] ut_imm;
    UT_decoder ut (
        .body(instr[31:7]),
        .rd(ut_rd),
        .imm(ut_imm)
    );

    wire [ 4:0] jt_rd;
    wire [19:0] jt_imm;
    JT_decoder jt (
        .body(instr[31:7]),
        .rd(jt_rd),
        .imm(jt_imm)
    );

endmodule

module RT_decoder (
    input  wire [24:0] body,
    output wire [ 4:0] rs1,
    output wire [ 4:0] rs2,
    output wire [ 4:0] rd,
    output wire [ 9:0] func
);

    assign func = {body[24:18], 
                   body[ 7: 5]};
    assign rs1  =  body[12: 8];
    assign rs2  =  body[17:13];
    assign rd   =  body[ 4: 0];

endmodule

module IT_decoder (
    input  wire [24:0] body,
    output wire [ 4:0] rs1,
    output wire [ 4:0] rd,
    output wire [ 9:0] func,
    output wire [11:0] imm
);

    assign func = {7'b0, 
                   body[ 7: 5]};
    assign rs1  =  body[12: 8];
    assign rd   =  body[ 4: 0];
    assign imm  =  body[24:13];

endmodule

module ST_decoder (
    input  wire [24:0] body,
    output wire [ 4:0] rs1,
    output wire [ 4:0] rs2,
    output wire [ 9:0] func,
    output wire [11:0] imm
);

    assign func = {7'b0, 
                   body[ 7: 5]};
    assign rs1  =  body[12: 8];
    assign rs2  =  body[17:13];
    assign imm  = {body[24:18], 
                   body[ 4: 0]};

endmodule

module BT_decoder (
    input  wire [24:0] body,
    output wire [ 4:0] rs1,
    output wire [ 4:0] rs2,
    output wire [ 9:0] func,
    output wire [11:0] imm
);

    assign func = {7'b0,
                   body[ 7: 5]};
    assign rs1  =  body[12: 8];
    assign rs2  =  body[17:13];
    assign imm  = {body[24], 
                   body[ 0], 
                   body[23:18], 
                   body[ 4: 1]};

endmodule

module UT_decoder(
    input  wire [24:0] body,
    output wire [ 4:0] rd,
    output wire [19:0] imm
);

    assign rd   =  body[ 4:0];
    assign imm  =  body[19:0];

endmodule

module JT_decoder (
    input  wire [24:0] body,
    output wire [ 4:0] rd,
    output wire [19:0] imm
);

    assign rd   =  body[ 4:0];
    assign imm  = {body[24],
                   body[12: 5],
                   body[13],
                   body[23:14]};

endmodule

`endif