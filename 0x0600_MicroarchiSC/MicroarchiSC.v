`ifndef MICROARCHITECTURE_SINGLE_CYCLE_V
`define MICROARCHITECTURE_SINGLE_CYCLE_V

`include "../IPs_shared/universal4inc.v"
`include "../0x0101_ALU32FF/CtlALU.v"
`include "../0x0300_PC/PCIM.v"
`include "../0x0400_Decoder/RV32I.v"
`include "../0x0400_Decoder/RV32M.v"
`include "../0x0500_Mem/MemIO.v"

`define DATA_ST `MM_ENB_W
`define DATA_LD `MM_ENB_R

module MicroarchiSC (
    input  wire        rst,
    input  wire        clk,
    input  wire [31:0] instr,
    input  wire [31:0] dataI,
    output reg  [31:0] dataO,
    output reg         store_or_load,
    output reg  [ 1:0] width_of_data,
    output reg  [31:0] locat_of_data,
    output reg  [31:0] where_is_instr
);

    reg  [ 1:0] pc_mode;
    reg  [31:0] pc_offset;
    reg  [31:0] pc_target;
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

    reg         rf_en4w;
    reg  [ 4:0] rf_wA;
    reg  [31:0] rf_wD;
    reg  [ 4:0] rf_r0A, rf_r1A;
    wire [31:0] rf_r0D, rf_r1D;
    REGs3P rf(
        .clk(clk),
        .en4w(rf_en4w),
        .addr_w(rf_wA),
        .data_i(rf_wD),
        .addr_r0(rf_r0A),
        .data_o0(rf_r0D),
        .addr_r1(rf_r1A),
        .data_o1(rf_r1D)
    );

    reg  [15:0] alu_ctl;
    reg  [31:0] alu_op1;
    reg  [31:0] alu_op2;
    wire [31:0] alu_res;
    ALU32FF alu(
        .ctl(alu_ctl),
        .op1(alu_op1),
        .op2(alu_op2),
        .res(alu_res)
    );

    reg  [31:0] decoder_instr;
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

    reg  [31:0] c2t_1C, c2t_2C;
    wire [31:0] c2t_1T, c2t_2T;
    CTC32 c2t_1(
        .C(c2t_1C),
        .T(c2t_1T)
    ), c2t_2(
        .C(c2t_2C),
        .T(c2t_2T)
    );

    reg  [31:0] t2c_T;
    wire [31:0] t2c_C;
    TCC32 t2c(
        .T(t2c_T),
        .C(t2c_C)
    );

    assign rf_r0A = decoder_rs1;
    assign rf_r1A = decoder_rs2;
    assign rf_wA  = decoder_rd;

    assign c2t_1C = rf_r0D;
    assign c2t_2C = rf_r1D;
    assign t2c_T  = {rf_r0D[31] ^ rf_r1D[31], alu_res[30:0]};

    always @(negedge rst or posedge clk) begin
        where_is_instr <= pc_addr;
        if (rst) begin
            pc_mode   <= `UCJUMP;
            pc_target <= 32'd2048;
        end else begin
            decoder_instr <= instr;
            case (decoder_op)
                `INSTR_TYP_R: begin
                    pc_mode <= `NORMAL;
                    rf_r0A  <= decoder_rs1;
                    rf_r1A  <= decoder_rs2;
                    rf_wA   <= decoder_rd;
                    rf_en4w <= 1'b1;
                    case (decoder_func)
                        `R_TYP_FC_ADD: begin
                            alu_ctl <= `ALU_CTL_ADD;
                            alu_op1 <= rf_r0D;
                            alu_op2 <= rf_r1D;
                            rf_wD   <= alu_res;
                        end
                        `R_TYP_FC_SUB: begin
                            alu_ctl <= `ALU_CTL_SUB;
                            alu_op1 <= rf_r0D;
                            alu_op2 <= rf_r1D;
                            rf_wD   <= alu_res;
                        end
                        `R_TYP_FC_SLL: begin
                            alu_ctl <= `ALU_CTL_SLL;
                            alu_op1 <= rf_r0D;
                            alu_op2 <= rf_r1D;
                            rf_wD   <= alu_res;
                        end
                        `R_TYP_FC_SRL: begin
                            alu_ctl <= `ALU_CTL_SRL;
                            alu_op1 <= rf_r0D;
                            alu_op2 <= rf_r1D;
                            rf_wD   <= alu_res;
                        end
                        `R_TYP_FC_SRA: begin
                            alu_ctl <= `ALU_CTL_SRA;
                            alu_op1 <= rf_r0D;
                            alu_op2 <= rf_r1D;
                            rf_wD   <= alu_res;
                        end
                        `R_TYP_FC_SLT: begin
                            alu_ctl <= `ALU_CTL_SLT;
                            alu_op1 <= rf_r0D;
                            alu_op2 <= rf_r1D;
                            rf_wD   <= alu_res;
                        end
                        `R_TYP_FC_SLTU: begin 
                            alu_ctl <= `ALU_CTL_SLTU;
                            alu_op1 <= rf_r0D;
                            alu_op2 <= rf_r1D;
                            rf_wD   <= alu_res;
                        end
                        `R_TYP_FC_AND: begin
                            alu_ctl <= `ALU_CTL_AND;
                            alu_op1 <= rf_r0D;
                            alu_op2 <= rf_r1D;
                            rf_wD   <= alu_res;
                        end
                        `R_TYP_FC_OR: begin
                            alu_ctl <= `ALU_CTL_OR;
                            alu_op1 <= rf_r0D;
                            alu_op2 <= rf_r1D;
                            rf_wD   <= alu_res;
                        end
                        `R_TYP_FC_XOR: begin
                            alu_ctl <= `ALU_CTL_XOR;
                            alu_op1 <= rf_r0D;
                            alu_op2 <= rf_r1D;
                            rf_wD   <= alu_res;
                        end
                        `R_TYP_FC_MUL: begin
                            alu_ctl <= `ALU_CTL_MUL;
                            alu_op1 <= rf_r0D;
                            alu_op2 <= rf_r1D;
                            rf_wD   <= alu_res;
                        end
                        `R_TYP_FC_MULH: begin
                            alu_ctl <= `ALU_CTL_MULH;
                            alu_op1 <= rf_r0D;
                            alu_op2 <= rf_r1D;
                            rf_wD   <= alu_res;
                        end
                        `R_TYP_FC_MULHU: begin
                            alu_ctl <= `ALU_CTL_MULH;
                            alu_op1 <= rf_r0D;
                            alu_op2 <= rf_r1D;
                            rf_wD   <= alu_res;
                        end
                        `R_TYP_FC_MULHSU: begin
                            alu_ctl <= `ALU_CTL_MULH;
                            alu_op1 <= rf_r0D;
                            alu_op2 <= rf_r1D;
                            rf_wD   <= alu_res;
                        end
                        `R_TYP_FC_DIV: begin
                            alu_ctl <= `ALU_CTL_DIV;
                            c2t_1C  <= rf_r0D;
                            c2t_2C  <= rf_r1D;
                            alu_op1 <= {1'b0, c2t_1T[30:0]};
                            alu_op2 <= {1'b0, c2t_2T[30:0]};
                            t2c_T   <= {rf_r0D[31] ^ rf_r1D[31], alu_res[30:0]};
                            rf_wD   <= t2c_C;
                        end
                        `R_TYP_FC_REM: begin
                            alu_ctl <= `ALU_CTL_REM;
                            c2t_1C  <= rf_r0D;
                            c2t_2C  <= rf_r1D;
                            alu_op1 <= {1'b0, c2t_1T[30:0]};
                            alu_op2 <= {1'b0, c2t_2T[30:0]};
                            t2c_T   <= {rf_r0D[31] ^ rf_r1D[31], alu_res[30:0]};
                            rf_wD   <= t2c_C;
                        end
                        `R_TYP_FC_DIVU: begin
                            alu_ctl <= `ALU_CTL_DIV;
                            alu_op1 <= rf_r0D;
                            alu_op2 <= rf_r1D;
                            rf_wD   <= alu_res;
                        end
                        `R_TYP_FC_REMU: begin
                            alu_ctl <= `ALU_CTL_REM;
                            alu_op1 <= rf_r0D;
                            alu_op2 <= rf_r1D;
                            rf_wD   <= alu_res;
                        end
                        default: ;
                    endcase
                end 
                `INSTR_TYP_I: begin
                    pc_mode <= `NORMAL;
                    rf_r0A  <= decoder_rs1;
                    alu_op1 <= rf_r0D;
                    alu_op2 <= decoder_imm;
                    rf_wA   <= decoder_rd;
                    rf_wD   <= alu_res;
                    rf_en4w <= 1'b1;
                    case (decoder_func)
                        `I_TYP_FC_ADDI: begin
                            alu_ctl <= `ALU_CTL_ADD;
                        end
                        `I_TYP_FC_SLTI: begin 
                            alu_ctl <= `ALU_CTL_SLT;
                        end
                        `I_TYP_FC_SLTIU: begin
                            alu_ctl <= `ALU_CTL_SLTU;
                        end
                        `I_TYP_FC_ANDI: begin
                            alu_ctl <= `ALU_CTL_AND;
                        end
                        `I_TYP_FC_ORI: begin
                            alu_ctl <= `ALU_CTL_OR;
                        end
                        `I_TYP_FC_XORI: begin
                            alu_ctl <= `ALU_CTL_XOR;
                        end
                        `I_TYP_FC_SLLI: begin
                            alu_ctl <= `ALU_CTL_SLL;
                        end
                        `I_TYP_FC_SRLI: begin
                            alu_ctl <= `ALU_CTL_SRL;
                        end
                        `I_TYP_FC_SRAI: begin
                            alu_ctl <= `ALU_CTL_SRA;
                        end
                        default: ;
                    endcase
                end
                `INSTR_TYP_S: begin
                    pc_mode <= `NORMAL;
                    alu_ctl <= `ALU_CTL_ADD;
                    rf_r0A  <= decoder_rs1;
                    alu_op1 <= rf_r0D;
                    alu_op2 <= decoder_imm;
                    rf_r1A  <= decoder_rs2;
                    store_or_load <= `DATA_ST;
                    locat_of_data <= alu_res;
                    dataO <= rf_r1D;
                    case (decoder_func)
                        `S_TYP_FC_SB: begin
                            width_of_data  <= `MW_Byte;
                        end
                        `S_TYP_FC_SH: begin
                            width_of_data  <= `MW_Half;
                        end
                        `S_TYP_FC_SW: begin
                            width_of_data  <= `MW_Word;
                        end
                        default: ;
                    endcase
                end
                `INSTR_TYP_B: begin
                    pc_mode <= `BRANCH;
                    rf_r0A  <= decoder_rs1;
                    rf_r1A  <= decoder_rs2;
                    alu_op1 <= rf_r0D;
                    alu_op2 <= rf_r1D;
                    case (decoder_func)
                        `B_TYP_FC_BEQ: begin
                            pc_offset <= `isEQ(rf_r0D, rf_r1D) ? decoder_imm : 32'd4;
                        end
                        `B_TYP_FC_BEN: begin
                            pc_offset <= `isEQ(rf_r0D, rf_r1D) ? 32'd4 : decoder_imm;
                        end
                        `B_TYP_FC_BLT: begin
                            alu_ctl   <= `ALU_CTL_SLT;
                            pc_offset <= alu_res[0] ? decoder_imm : 32'd4;
                        end
                        `B_TYP_FC_BGE: begin
                            alu_ctl   <= `ALU_CTL_SLT;
                            pc_offset <= alu_res[0] ? 32'd4 : decoder_imm;
                        end
                        `B_TYP_FC_BLTU: begin
                            alu_ctl   <= `ALU_CTL_SLTU;
                            pc_offset <= alu_res[0] ? decoder_imm : 32'd4;
                        end
                        `B_TYP_FC_BGEU: begin
                            alu_ctl   <= `ALU_CTL_SLTU;
                            pc_offset <= alu_res[0] ? 32'd4 : decoder_imm;
                        end
                        default: ;
                    endcase
                end
                `INSTR_TYP_U: begin
                    pc_mode <= `NORMAL;
                    rf_en4w <= 1'b0;
                    rf_wA   <= decoder_rd;
                    rf_wD   <= decoder_imm;
                end
                `INSTR_TYP_J: begin
                    pc_mode   <= `UCJUMP;
                    alu_ctl   <= `ALU_CTL_ADD;
                    alu_op1   <= pc_addr;
                    alu_op2   <= decoder_imm;
                    pc_target <= alu_res;
                end
                `INSTR_TYP_I12LD: begin
                    pc_mode <= `NORMAL;
                    alu_ctl <= `ALU_CTL_ADD;
                    rf_r0A  <= decoder_rs1;
                    alu_op1 <= rf_r0D;
                    alu_op2 <= decoder_imm;
                    rf_wA   <= decoder_rd;
                    store_or_load <= `DATA_LD;
                    locat_of_data <= alu_res;
                    case (decoder_func) 
                        `I12LD_TYP_FC_LB: begin
                            width_of_data  <= `MW_Byte;
                            rf_wD <= {{24{dataI[7]}}, dataI[ 7:0]};
                        end
                        `I12LD_TYP_FC_LH: begin
                            width_of_data  <= `MW_Half;
                            rf_wD <= {{16{dataI[7]}}, dataI[15:0]};
                        end
                        `I12LD_TYP_FC_LW: begin
                            width_of_data  <= `MW_Word;
                            rf_wD <= dataI;
                        end
                        `I12LD_TYP_FC_LBU: begin
                            width_of_data  <= `MW_Byte;
                            rf_wD <= {24'b0, dataI[ 7:0]};
                        end
                        `I12LD_TYP_FC_LHU: begin
                            width_of_data  <= `MW_Half;
                            rf_wD <= {16'b0, dataI[15:0]};
                        end
                        default: ;
                    endcase
                end
                `INSTR_TYP_I12JR: begin
                    pc_mode <= `UCJUMP;
                    case (decoder_func) 
                        `I12JR_TYP_FC_JALR: begin
                        end
                        default: ;
                    endcase
                end
                `INSTR_TYP_I20PC: begin
                end
                default: ;
            endcase
            DBG_detail_of_instr_exec(decoder_instr, 
                                     decoder_op, 
                                     decoder_func, 
                                     decoder_imm, 
                                     rf_r0A, rf_r0D, 
                                     rf_r1A, rf_r0D, 
                                     rf_wA,  rf_wD);
        end
    end
    
    function [31:0] ALU_MUX_OP1;
        input [31:0] regT;
        input [31:0] regC;
        input [31:0] pc;
    begin
    end 
    endfunction

    task DBG_detail_of_instr_exec(
        input [31:0] instr,
        input [ 6:0] op,
        input [ 9:0] func,
        input [31:0] imm,
        input [ 4:0] rs1_addr,
        input [31:0] rs1_data,
        input [ 4:0] rs2_addr, 
        input [31:0] rs2_data,
        input [ 4:0]  rd_addr,
        input [31:0]  rd_data
    ); begin
        case (op)
            `INSTR_TYP_R: begin
                case (func)
                    `R_TYP_FC_ADD:      $display("ADD:    rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_SUB:      $display("SUB:    rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_SLL:      $display("SLL:    rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_SLT:      $display("SLT:    rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_SLTU:     $display("SLTU:   rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_XOR:      $display("XOR:    rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_SRL:      $display("SRL:    rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_SRA:      $display("SRA:    rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_OR:       $display("OR:     rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_AND:      $display("AND:    rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_MUL:      $display("MUL:    rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_MULH:     $display("MULH:   rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_MULHSU:   $display("MULHSU: rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_MULHU:    $display("MULHU:  rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_DIV:      $display("DIV:    rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_DIVU:     $display("DIVU:   rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_REM:      $display("REM:    rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_REMU:     $display("REMU:   rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, rd  is x%-2d=%08H", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    default: $display("*[ERROR]@INSTR_TYP_R Func=%b ", func);
                endcase
            end 
            `INSTR_TYP_I: begin
                case (func)
                    `I_TYP_FC_ADDI:     $display("ADDI:   rs1 is x%-2d=%08H, rd  is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I_TYP_FC_SLTI:     $display("SLTI:   rs1 is x%-2d=%08H, rd  is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I_TYP_FC_SLTIU:    $display("SLTIU:  rs1 is x%-2d=%08H, rd  is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I_TYP_FC_XORI:     $display("XORI:   rs1 is x%-2d=%08H, rd  is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I_TYP_FC_ORI:      $display("ORI:    rs1 is x%-2d=%08H, rd  is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I_TYP_FC_ANDI:     $display("ANDI:   rs1 is x%-2d=%08H, rd  is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I_TYP_FC_SLLI:     $display("SLLI:   rs1 is x%-2d=%08H, rd  is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I_TYP_FC_SRLI:     $display("SRLI:   rs1 is x%-2d=%08H, rd  is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I_TYP_FC_SRAI:     $display("SRAI:   rs1 is x%-2d=%08H, rd  is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    default: $display("*[ERROR]@INSTR_TYP_I Func=%b ", func);
                endcase
            end 
            `INSTR_TYP_S: begin
                case (func)
                    `S_TYP_FC_SB:       $display("SB:     rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    `S_TYP_FC_SH:       $display("SH:     rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    `S_TYP_FC_SW:       $display("SW:     rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    default: $display("*[ERROR]@INSTR_TYP_S Func=%b ", func);
                endcase
            end 
            `INSTR_TYP_B: begin
                case (func)
                    `B_TYP_FC_BEQ:      $display("BEQ:    rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    `B_TYP_FC_BEN:      $display("BNE:    rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    `B_TYP_FC_BLT:      $display("BLT:    rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    `B_TYP_FC_BGE:      $display("BGE:    rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    `B_TYP_FC_BLTU:     $display("BLTU:   rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    `B_TYP_FC_BGEU:     $display("BGEU:   rs1 is x%-2d=%08H, rs2 is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    default: $display("*[ERROR]@INSTR_TYP_B Func=%b ", func);
                endcase
            end 
            `INSTR_TYP_U: begin
                $display("LUI:    rd  is x%-2d=%08X, imm is 0x%05H", rd_addr, rd_data, $signed(imm));
            end 
            `INSTR_TYP_J: begin
                $display("JAL:    rd  is x%-2d=%08X, imm is 0x%05H", rd_addr, rd_data, $signed(imm));
            end 
            `INSTR_TYP_I12LD: begin
                case (func) 
                    `I12LD_TYP_FC_LB:   $display("LB:     rs1 is x%-2d=%08H, rd  is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I12LD_TYP_FC_LH:   $display("LH:     rs1 is x%-2d=%08H, rd  is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I12LD_TYP_FC_LW:   $display("LW:     rs1 is x%-2d=%08H, rd  is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I12LD_TYP_FC_LBU:  $display("LBU:    rs1 is x%-2d=%08H, rd  is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I12LD_TYP_FC_LHU:  $display("LHU:    rs1 is x%-2d=%08H, rd  is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    default: $display("*[ERROR]@INSTR_TYP_I12LD Func=%b ", func);
                endcase
            end
            `INSTR_TYP_I12JR: begin
                case (func) 
                    `I12JR_TYP_FC_JALR: $display("JALR:   rs1 is x%-2d=%08H, rd  is x%-2d=%08H, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    default: $display("*[ERROR]@INSTR_TYP_I12JR Func=%b ", func);
                endcase
            end
            `INSTR_TYP_I20PC: begin
                $display("AUIPC:  rd  is x%-2d=%08H, imm is 0x%05H", rd_addr, rd_data, $signed(imm));
            end
            default: begin
                $display("*[ERROR] Machine Code is instr=%08H, op=%b ", instr, op);
            end
        endcase
    end endtask

endmodule

`endif 