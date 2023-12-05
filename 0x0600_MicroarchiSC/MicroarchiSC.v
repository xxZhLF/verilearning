`ifndef MICROARCHITECTURE_SINGLE_CYCLE_V
`define MICROARCHITECTURE_SINGLE_CYCLE_V

`include "../IPs_shared/universal4inc.v"
`include "../0x0101_ALU32FF/CtlALU.v"
`include "../0x0300_PC/PCIM.v"
`include "../0x0400_Decoder/RV32I.v"
`include "../0x0400_Decoder/RV32M.v"
`include "../0x0500_Mem/MemIO.v"

module MicroarchiSC (
    input wire        rst,
    input wire        clk,
    input wire [31:0] LoadProg_addr,
    input wire [31:0] LoadProg_data
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

    reg         mem_A_EnWR,  mem_B_EnWR;
    reg  [ 1:0]              mem_B_Size;
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
        .B_Size(mem_B_Size),
        .B_ABus(mem_B_ABus),
        .B_DBusW(mem_B_DBusW),
        .B_DBusR(mem_B_DBusR)
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

    always @(negedge rst or posedge clk) begin
        if (rst) begin
            mem_A_EnWR  <= `MM_ENB_W;
            mem_A_ABus  <= LoadProg_addr;
            mem_A_DBusW <= LoadProg_data;
            pc_mode     <= `UCJUMP;
            pc_target   <= LoadProg_addr;
        end else begin
            mem_A_EnWR <= `MM_ENB_R;
            mem_A_ABus <= pc_addr;
            decoder_instr <= mem_A_DBusR;
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
                    mem_B_EnWR  <= `MM_ENB_W;
                    mem_B_ABus  <= alu_res;
                    mem_B_DBusW <= rf_r1D;
                    case (decoder_func)
                        `S_TYP_FC_SB: begin
                            mem_B_Size  <= `MW_Byte;
                        end
                        `S_TYP_FC_SH: begin
                            mem_B_Size  <= `MW_Half;
                        end
                        `S_TYP_FC_SW: begin
                            mem_B_Size  <= `MW_Word;
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
                    rf_en4w <= `MM_ENB_W;
                    rf_wA   <= decoder_rd;
                    rf_wD   <= decoder_imm;
                end
                `INSTR_TYP_J: begin
                    pc_mode <= `UCJUMP;
                end
                `INSTR_TYP_I12LD: begin
                    pc_mode <= `NORMAL;
                    case (decoder_func) 
                        `I12LD_TYP_FC_LB: begin
                        end
                        `I12LD_TYP_FC_LH: begin
                        end
                        `I12LD_TYP_FC_LW: begin
                        end
                        `I12LD_TYP_FC_LBU: begin
                        end
                        `I12LD_TYP_FC_LHU: begin
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