`ifndef MICROARCHITECTURE_SINGLE_CYCLE_V
`define MICROARCHITECTURE_SINGLE_CYCLE_V

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

    wire        rf_en4w;
    wire [ 4:0] rf_wa, rf_r0a, rf_r1a;
    wire [31:0] rf_wd, rf_r0d, rf_r1d;
    REGs3P rf(
        .clk(clk),
        .en4w(rf_en4w),
        .addr_w(rf_wa),
        .data_i(rf_wd),
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
            pc_mode     <= `UCJUMP;
            pc_target   <= 32'b0;
        end else begin
            mem_A_EnWR <= `ENB_R;
            mem_A_ABus <= pc_addr;
            decoder_instr <= mem_A_DBusR;
            case (decoder_op)
                `INSTR_TYP_R: begin
                    pc_mode <= `NORMAL;
                    case (decoder_func)
                        `R_TYP_FC_ADD: begin
                        end
                        `R_TYP_FC_SUB: begin
                        end
                        `R_TYP_FC_SLL: begin
                        end
                        `R_TYP_FC_SLT: begin
                        end
                        `R_TYP_FC_SLTU: begin 
                        end
                        `R_TYP_FC_XOR: begin
                        end
                        `R_TYP_FC_SRL: begin
                        end
                        `R_TYP_FC_SRA: begin
                        end
                        `R_TYP_FC_OR: begin
                        end
                        `R_TYP_FC_AND: begin
                        end
                        `R_TYP_FC_MUL: begin
                        end
                        `R_TYP_FC_MULH: begin
                        end
                        `R_TYP_FC_MULHSU: begin
                        end
                        `R_TYP_FC_MULHU: begin
                        end
                        `R_TYP_FC_DIV: begin
                        end
                        `R_TYP_FC_DIVU: begin
                        end
                        `R_TYP_FC_REM: begin
                        end
                        `R_TYP_FC_REMU: begin
                        end
                        default: ;
                    endcase
                end 
                `INSTR_TYP_I: begin
                    pc_mode <= `NORMAL;
                    case (decoder_func)
                        `I_TYP_FC_ADDI: begin
                        end
                        `I_TYP_FC_SLTI: begin 
                        end
                        `I_TYP_FC_SLTIU: begin
                        end
                        `I_TYP_FC_XORI: begin
                        end
                        `I_TYP_FC_ORI: begin
                        end
                        `I_TYP_FC_ANDI: begin
                        end
                        `I_TYP_FC_SLLI: begin
                        end
                        `I_TYP_FC_SRLI: begin
                        end
                        `I_TYP_FC_SRAI: begin
                        end
                        default: ;
                    endcase
                end
                `INSTR_TYP_S: begin
                    pc_mode <= `NORMAL;
                    case (decoder_func)
                        `S_TYP_FC_SB: begin
                        end
                        `S_TYP_FC_SH: begin
                        end
                        `S_TYP_FC_SW: begin
                        end
                        default: ;
                    endcase
                end
                `INSTR_TYP_B: begin
                    pc_mode <= `BRANCH;
                    case (decoder_func)
                        `B_TYP_FC_BEQ: begin
                        end
                        `B_TYP_FC_BEN: begin
                        end
                        `B_TYP_FC_BLT: begin
                        end
                        `B_TYP_FC_BGE: begin
                        end
                        `B_TYP_FC_BLTU: begin
                        end
                        `B_TYP_FC_BGEU: begin
                        end
                        default: ;
                    endcase
                end
                `INSTR_TYP_U: begin
                    pc_mode <= `NORMAL;
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
            DBG_detail_of_instr_exec(decoder_op, decoder_func, decoder_imm, decoder_rs1, 32'b0, decoder_rs2, 32'b0, decoder_rd, 32'b0);
        end
    end
    
    task DBG_detail_of_instr_exec(
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
                    `R_TYP_FC_ADD:      $display("ADD:    rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_SUB:      $display("SUB:    rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_SLL:      $display("SLL:    rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_SLT:      $display("SLT:    rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_SLTU:     $display("SLTU:   rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_XOR:      $display("XOR:    rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_SRL:      $display("SRL:    rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_SRA:      $display("SRA:    rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_OR:       $display("OR:     rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_AND:      $display("AND:    rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_MUL:      $display("MUL:    rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_MULH:     $display("MULH:   rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_MULHSU:   $display("MULHSU: rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_MULHU:    $display("MULHU:  rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_DIV:      $display("DIV:    rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_DIVU:     $display("DIVU:   rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_REM:      $display("REM:    rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    `R_TYP_FC_REMU:     $display("REMU:   rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, rd  is x%-2d=%08X", rs1_addr, rs1_data, rs2_addr, rs2_data, rd_addr, rd_data);
                    default: $display("*[ERROR]@INSTR_TYP_R Func=%b ", func);
                endcase
            end 
            `INSTR_TYP_I: begin
                case (func)
                    `I_TYP_FC_ADDI:     $display("ADDI:   rs1 is x%-2d=%08X, rd  is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I_TYP_FC_SLTI:     $display("SLTI:   rs1 is x%-2d=%08X, rd  is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I_TYP_FC_SLTIU:    $display("SLTIU:  rs1 is x%-2d=%08X, rd  is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I_TYP_FC_XORI:     $display("XORI:   rs1 is x%-2d=%08X, rd  is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I_TYP_FC_ORI:      $display("ORI:    rs1 is x%-2d=%08X, rd  is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I_TYP_FC_ANDI:     $display("ANDI:   rs1 is x%-2d=%08X, rd  is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I_TYP_FC_SLLI:     $display("SLLI:   rs1 is x%-2d=%08X, rd  is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I_TYP_FC_SRLI:     $display("SRLI:   rs1 is x%-2d=%08X, rd  is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I_TYP_FC_SRAI:     $display("SRAI:   rs1 is x%-2d=%08X, rd  is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    default: $display("*[ERROR]@INSTR_TYP_I Func=%b ", func);
                endcase
            end 
            `INSTR_TYP_S: begin
                case (func)
                    `S_TYP_FC_SB:       $display("SB:     rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    `S_TYP_FC_SH:       $display("SH:     rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    `S_TYP_FC_SW:       $display("SW:     rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    default: $display("*[ERROR]@INSTR_TYP_S Func=%b ", func);
                endcase
            end 
            `INSTR_TYP_B: begin
                case (func)
                    `B_TYP_FC_BEQ:      $display("BEQ:    rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    `B_TYP_FC_BEN:      $display("BNE:    rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    `B_TYP_FC_BLT:      $display("BLT:    rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    `B_TYP_FC_BGE:      $display("BGE:    rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    `B_TYP_FC_BLTU:     $display("BLTU:   rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    `B_TYP_FC_BGEU:     $display("BGEU:   rs1 is x%-2d=%08X, rs2 is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rs2_addr, rs2_data, $signed(imm));
                    default: $display("*[ERROR]@INSTR_TYP_B Func=%b ", func);
                endcase
            end 
            `INSTR_TYP_U: begin
                $display("LUI:    rd  is x%-2d=%08X, imm is 0x%05H", rd_addr, rd_data, $signed(imm[31:12]));
            end 
            `INSTR_TYP_J: begin
                $display("JAL:    rd  is x%-2d=%08X, imm is 0x%05H", rd_addr, rd_data, $signed(imm[31:12]));
            end 
            `INSTR_TYP_I12LD: begin
                case (func) 
                    `I12LD_TYP_FC_LB:   $display("LB:     rs1 is x%-2d=%08X, rd  is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I12LD_TYP_FC_LH:   $display("LH:     rs1 is x%-2d=%08X, rd  is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I12LD_TYP_FC_LW:   $display("LW:     rs1 is x%-2d=%08X, rd  is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I12LD_TYP_FC_LBU:  $display("LBU:    rs1 is x%-2d=%08X, rd  is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    `I12LD_TYP_FC_LHU:  $display("LHU:    rs1 is x%-2d=%08X, rd  is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    default: $display("*[ERROR]@INSTR_TYP_I12LD Func=%b ", func);
                endcase
            end
            `INSTR_TYP_I12JR: begin
                case (func) 
                    `I12JR_TYP_FC_JALR: $display("JALR:   rs1 is x%-2d=%08X, rd  is x%-2d=%08X, imm is %-d", rs1_addr, rs1_data, rd_addr, rd_data, $signed(imm));
                    default: $display("*[ERROR]@INSTR_TYP_I12JR Func=%b ", func);
                endcase
            end
            `INSTR_TYP_I20PC: begin
                $display("AUIPC:  rd  is x%-2d=%08X, imm is 0x%05H", rd_addr, rd_data, $signed(imm[31:12]));
            end
            default: begin
                $display("*[ERROR] Machine Code is op=%b ", op);
            end
        endcase
    end endtask

endmodule

`endif 