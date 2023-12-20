`ifndef MICROARCHITECTURE_MULTI_CYCLE_V
`define MICROARCHITECTURE_MULTI_CYCLE_V

`include "../IPs_shared/universal4inc.v"
`include "../0x0101_ALU32FF/ALU1HotCtl.v"
`include "../0x0200_REGs3P/RegName.v"
`include "../0x0300_PC/PCIM.v"
`include "../0x0400_Decoder/RV32I.v"
`include "../0x0400_Decoder/RV32M.v"
`include "../0x0500_Mem/MemIO.v"

`define STAT_HALT 3'b0
`define STAT_IF 3'b001
`define STAT_ID 3'b010
`define STAT_EX 3'b011
`define STAT_MM 3'b100
`define STAT_WB 3'b101

`define DATA_ST `MM_ENB_W
`define DATA_LD `MM_ENB_R

module MicroarchiMC (
    input  wire        rst,
    input  wire        clk,
    input  wire [31:0] cnt,
    input  wire [31:0] instr,
    input  wire [31:0] dataI,
    output wire [31:0] dataO,
    output wire        store_or_load,
    output wire [ 1:0] width_of_data,
    output wire [31:0] locat_of_data,
    output wire [31:0] where_is_instr
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
    wire [ 9:0] decoder_func;
    wire [ 4:0] decoder_rs1;
    wire [ 4:0] decoder_rs2;
    wire [ 4:0] decoder_rd;
    wire [31:0] decoder_imm;
    Decoder decoder(
        .instr(decoder_instr),
        .op(decoder_op),
        .func(decoder_func),
        .rs1(decoder_rs1),
        .rs2(decoder_rs2),
        .rd(decoder_rd),
        .imm(decoder_imm)
    );

    wire [31:0] c2t_r0DC, c2t_r1DC;
    wire [31:0] c2t_r0DT, c2t_r1DT;
    CTC32 c2t_1(
        .C(c2t_r0DC),
        .T(c2t_r0DT)
    ), c2t_2(
        .C(c2t_r1DC),
        .T(c2t_r1DT)
    );

    wire [31:0] c2t_immC;
    wire [31:0] c2t_immT;
    CTC32 c2t_I(
        .C(c2t_immC),
        .T(c2t_immT)
    );

    wire [31:0] t2c_resT;
    wire [31:0] t2c_resC;
    TCC32 t2c(
        .T(t2c_resT),
        .C(t2c_resC)
    );

    assign c2t_r0DC  = rf_r0D;
    assign c2t_r1DC  = rf_r1D;
    assign c2t_immC  = decoder_imm;
    assign rf_r0A    = decoder_rs1;
    assign rf_r1A    = decoder_rs2;
    assign rf_wA     = decoder_rd;


    function [15:0] MUX_of_ALU_ctl;
        input [6:0] op;
        input [9:0] func;
    begin
        casez ({op, func}) 
            {`INSTR_TYP_R,     `R_TYP_FC_ADD}:      return `ALU_CTL_ADD;
            {`INSTR_TYP_R,     `R_TYP_FC_SUB}:      return `ALU_CTL_SUB;
            {`INSTR_TYP_R,     `R_TYP_FC_SLL}:      return `ALU_CTL_SLL;
            {`INSTR_TYP_R,     `R_TYP_FC_SRL}:      return `ALU_CTL_SRL;
            {`INSTR_TYP_R,     `R_TYP_FC_SRA}:      return `ALU_CTL_SRA;
            {`INSTR_TYP_R,     `R_TYP_FC_SLT}:      return `ALU_CTL_SLT;
            {`INSTR_TYP_R,     `R_TYP_FC_SLTU}:     return `ALU_CTL_SLTU;
            {`INSTR_TYP_R,     `R_TYP_FC_AND}:      return `ALU_CTL_AND;
            {`INSTR_TYP_R,     `R_TYP_FC_OR}:       return `ALU_CTL_OR;
            {`INSTR_TYP_R,     `R_TYP_FC_XOR}:      return `ALU_CTL_XOR;
            {`INSTR_TYP_R,     `R_TYP_FC_MUL}:      return `ALU_CTL_MUL;
            {`INSTR_TYP_R,     `R_TYP_FC_MULH}:     return `ALU_CTL_MUL;
            {`INSTR_TYP_R,     `R_TYP_FC_MULHU}:    return `ALU_CTL_MUL;
            {`INSTR_TYP_R,     `R_TYP_FC_MULHSU}:   return `ALU_CTL_MUL;
            {`INSTR_TYP_R,     `R_TYP_FC_DIV}:      return `ALU_CTL_DIV;
            {`INSTR_TYP_R,     `R_TYP_FC_REM}:      return `ALU_CTL_REM;
            {`INSTR_TYP_R,     `R_TYP_FC_DIVU}:     return `ALU_CTL_DIV;
            {`INSTR_TYP_R,     `R_TYP_FC_REMU}:     return `ALU_CTL_REM;
            {`INSTR_TYP_I,     `I_TYP_FC_ADDI}:     return `ALU_CTL_ADD;
            {`INSTR_TYP_I,     `I_TYP_FC_SLTI}:     return `ALU_CTL_SLT;
            {`INSTR_TYP_I,     `I_TYP_FC_SLTIU}:    return `ALU_CTL_SLT;
            {`INSTR_TYP_I,     `I_TYP_FC_ANDI}:     return `ALU_CTL_AND;
            {`INSTR_TYP_I,     `I_TYP_FC_ORI}:      return `ALU_CTL_OR;
            {`INSTR_TYP_I,     `I_TYP_FC_XORI}:     return `ALU_CTL_XOR;
            {`INSTR_TYP_I,     `I_TYP_FC_SLLI}:     return `ALU_CTL_SLL;
            {`INSTR_TYP_I,     `I_TYP_FC_SRLI}:     return `ALU_CTL_SRL;
            {`INSTR_TYP_I,     `I_TYP_FC_SRAI}:     return `ALU_CTL_SRA;
            {`INSTR_TYP_S,     `S_TYP_FC_SB}:       return `ALU_CTL_ADD;
            {`INSTR_TYP_S,     `S_TYP_FC_SH}:       return `ALU_CTL_ADD;
            {`INSTR_TYP_S,     `S_TYP_FC_SW}:       return `ALU_CTL_ADD;
            {`INSTR_TYP_B,     `B_TYP_FC_BEQ}:      return {16{1'bZ}};
            {`INSTR_TYP_B,     `B_TYP_FC_BEN}:      return {16{1'bZ}};
            {`INSTR_TYP_B,     `B_TYP_FC_BLT}:      return `ALU_CTL_SLT;
            {`INSTR_TYP_B,     `B_TYP_FC_BGE}:      return `ALU_CTL_SLT;
            {`INSTR_TYP_B,     `B_TYP_FC_BLTU}:     return `ALU_CTL_SLTU;
            {`INSTR_TYP_B,     `B_TYP_FC_BGEU}:     return `ALU_CTL_SLTU;
            {`INSTR_TYP_U,     {10{1'b?}}}:         return {16{1'bZ}};
            {`INSTR_TYP_J,     {10{1'b?}}}:         return `ALU_CTL_ADD;
            {`INSTR_TYP_I12LD, `I12LD_TYP_FC_LB}:   return `ALU_CTL_ADD;
            {`INSTR_TYP_I12LD, `I12LD_TYP_FC_LH}:   return `ALU_CTL_ADD;
            {`INSTR_TYP_I12LD, `I12LD_TYP_FC_LW}:   return `ALU_CTL_ADD;
            {`INSTR_TYP_I12LD, `I12LD_TYP_FC_LBU}:  return `ALU_CTL_ADD;
            {`INSTR_TYP_I12LD, `I12LD_TYP_FC_LHU}:  return `ALU_CTL_ADD;
            {`INSTR_TYP_I12JR, `I12JR_TYP_FC_JALR}: return `ALU_CTL_ADD;
            {`INSTR_TYP_I20PC, {10{1'b?}}}:         return `ALU_CTL_ADD;
            default:                                return {16{1'bZ}};
        endcase
    end
    endfunction

    function [31:0] MUX_of_ALU_op1;
        input [ 6:0] op;
        input [ 9:0] func;
        input [31:0] op1;
        input [31:0] op1T;
        input [31:0] pc;
    begin
        casez({op, func})
            {`INSTR_TYP_R,     {10{1'b?}}},
            {`INSTR_TYP_I,     {10{1'b?}}},
            {`INSTR_TYP_S,     {10{1'b?}}},
            {`INSTR_TYP_B,     {10{1'b?}}},
            {`INSTR_TYP_I12LD, {10{1'b?}}}:    return op1;
            {`INSTR_TYP_R,     `R_TYP_FC_SLT},
            {`INSTR_TYP_I,     `I_TYP_FC_SLTI},
            {`INSTR_TYP_B,     `B_TYP_FC_BLT},
            {`INSTR_TYP_B,     `B_TYP_FC_BGE}: return op1T;
            {`INSTR_TYP_R,     `R_TYP_FC_DIV}, 
            {`INSTR_TYP_R,     `R_TYP_FC_REM}: return {1'b0, op1T[30:0]};
            {`INSTR_TYP_J,     {10{1'b?}}},
            {`INSTR_TYP_I20PC, {10{1'b?}}}:    return pc;
            default:                           return {32{1'bZ}};
        endcase
    end
    endfunction

    function [31:0] MUX_of_ALU_op2;
        input [ 6:0] op;
        input [ 9:0] func;
        input [31:0] op2;
        input [31:0] op2T;
        input [31:0] imm;
        input [31:0] immT;
    begin
        casez({op, func})
            default: return {32{1'bZ}};
        endcase
    end
    endfunction

    reg [2:0] stat;
    always @(negedge rst or posedge clk) begin
        if (rst) begin
            stat <= `STAT_HALT;
        end else begin
            case (stat)
                `STAT_HALT: stat <= `STAT_IF;
                `STAT_IF:   stat <= `STAT_ID;
                `STAT_ID:   stat <= `STAT_EX;
                `STAT_EX:   stat <= `STAT_MM;
                `STAT_MM:   stat <= `STAT_WB;
                `STAT_WB:   stat <= `STAT_IF;
                default:;
            endcase
        end
    end

`define DEBUG_TRACE_LOG_ENABLE
`ifndef DEBUG_TRACE_LOG_ENABLE
`else

    always @(posedge clk) begin
        if (rst) begin
        end else begin
        end
    end

    task DEBUG_detail_of_instr_exec;
        input [31:0] instr;
        input [31:0] pc;
        input [ 6:0] op;
        input [ 9:0] func;
        input [31:0] imm;
        input [ 4:0] rs1A;
        input [31:0] rs1D;
        input [ 4:0] rs2A;
        input [31:0] rs2D;
        input [ 4:0] rdA;
        input [31:0] rdD;
    begin
        case (op)
            `INSTR_TYP_R: begin
                case (func)
                    `R_TYP_FC_ADD:      $display("No.%03d ADD:    @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    `R_TYP_FC_SUB:      $display("No.%03d SUB:    @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    `R_TYP_FC_SLL:      $display("No.%03d SLL:    @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    `R_TYP_FC_SLT:      $display("No.%03d SLT:    @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    `R_TYP_FC_SLTU:     $display("No.%03d SLTU:   @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    `R_TYP_FC_XOR:      $display("No.%03d XOR:    @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    `R_TYP_FC_SRL:      $display("No.%03d SRL:    @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    `R_TYP_FC_SRA:      $display("No.%03d SRA:    @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    `R_TYP_FC_OR:       $display("No.%03d OR:     @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    `R_TYP_FC_AND:      $display("No.%03d AND:    @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    `R_TYP_FC_MUL:      $display("No.%03d MUL:    @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    `R_TYP_FC_MULH:     $display("No.%03d MULH:   @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    `R_TYP_FC_MULHSU:   $display("No.%03d MULHSU: @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    `R_TYP_FC_MULHU:    $display("No.%03d MULHU:  @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    `R_TYP_FC_DIV:      $display("No.%03d DIV:    @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    `R_TYP_FC_DIVU:     $display("No.%03d DIVU:   @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    `R_TYP_FC_REM:      $display("No.%03d REM:    @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    `R_TYP_FC_REMU:     $display("No.%03d REMU:   @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, rdA, rdD);
                    default: $display("*[ERROR]@INSTR_TYP_R Func=%b ", func);
                endcase
            end 
            `INSTR_TYP_I: begin
                case (func)
                    `I_TYP_FC_ADDI:     $display("No.%03d ADDI:   @[%08H] rs1 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rdA, rdD, imm);
                    `I_TYP_FC_SLTI:     $display("No.%03d SLTI:   @[%08H] rs1 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rdA, rdD, imm);
                    `I_TYP_FC_SLTIU:    $display("No.%03d SLTIU:  @[%08H] rs1 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rdA, rdD, imm);
                    `I_TYP_FC_XORI:     $display("No.%03d XORI:   @[%08H] rs1 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rdA, rdD, imm);
                    `I_TYP_FC_ORI:      $display("No.%03d ORI:    @[%08H] rs1 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rdA, rdD, imm);
                    `I_TYP_FC_ANDI:     $display("No.%03d ANDI:   @[%08H] rs1 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rdA, rdD, imm);
                    `I_TYP_FC_SLLI:     $display("No.%03d SLLI:   @[%08H] rs1 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rdA, rdD, imm);
                    `I_TYP_FC_SRLI:     $display("No.%03d SRLI:   @[%08H] rs1 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rdA, rdD, imm);
                    `I_TYP_FC_SRAI:     $display("No.%03d SRAI:   @[%08H] rs1 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rdA, rdD, imm);
                    default: $display("*[ERROR]@INSTR_TYP_I Func=%b ", func);
                endcase
            end 
            `INSTR_TYP_S: begin
                case (func)
                    `S_TYP_FC_SB:       $display("No.%03d SB:     @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, imm);
                    `S_TYP_FC_SH:       $display("No.%03d SH:     @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, imm);
                    `S_TYP_FC_SW:       $display("No.%03d SW:     @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, imm);
                    default: $display("*[ERROR]@INSTR_TYP_S Func=%b ", func);
                endcase
            end 
            `INSTR_TYP_B: begin
                case (func)
                    `B_TYP_FC_BEQ:      $display("No.%03d BEQ:    @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, imm);
                    `B_TYP_FC_BEN:      $display("No.%03d BNE:    @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, imm);
                    `B_TYP_FC_BLT:      $display("No.%03d BLT:    @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, imm);
                    `B_TYP_FC_BGE:      $display("No.%03d BGE:    @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, imm);
                    `B_TYP_FC_BLTU:     $display("No.%03d BLTU:   @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, imm);
                    `B_TYP_FC_BGEU:     $display("No.%03d BGEU:   @[%08H] rs1 is x%-2d=>0x%08H, rs2 is x%-2d=>0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rs2A, rs2D, imm);
                    default: $display("*[ERROR]@INSTR_TYP_B Func=%b ", func);
                endcase
            end 
            `INSTR_TYP_U: begin
                                        $display("No.%03d LUI:    @[%08H] rd  is x%-2d<=0x%08H, imm is 0x%08H", cnt, pc, rdA, rdD, imm);
            end 
            `INSTR_TYP_J: begin
                                        $display("No.%03d JAL:    @[%08H] rd  is x%-2d<=0x%08H, imm is 0x%08H", cnt, pc, rdA, rdD, imm);
            end 
            `INSTR_TYP_I12LD: begin
                case (func) 
                    `I12LD_TYP_FC_LB:   $display("No.%03d LB:     @[%08H] rs1 is x%-2d=>0x%08H, rd  is x%-2d=>0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rdA, rdD, imm);
                    `I12LD_TYP_FC_LH:   $display("No.%03d LH:     @[%08H] rs1 is x%-2d=>0x%08H, rd  is x%-2d=>0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rdA, rdD, imm);
                    `I12LD_TYP_FC_LW:   $display("No.%03d LW:     @[%08H] rs1 is x%-2d=>0x%08H, rd  is x%-2d=>0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rdA, rdD, imm);
                    `I12LD_TYP_FC_LBU:  $display("No.%03d LBU:    @[%08H] rs1 is x%-2d=>0x%08H, rd  is x%-2d=>0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rdA, rdD, imm);
                    `I12LD_TYP_FC_LHU:  $display("No.-03d LHU:    @[%08H] rs1 is x%-2d=>0x%08H, rd  is x%-2d=>0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rdA, rdD, imm);
                    default: $display("*[ERROR]@INSTR_TYP_I12LD Func=%b ", func);
                endcase
            end
            `INSTR_TYP_I12JR: begin
                case (func) 
                    `I12JR_TYP_FC_JALR: $display("No.%-3d JALR:   @[%08H] rs1 is x%-2d=>0x%08H, rd  is x%-2d<=0x%08H, imm is 0x%08H", cnt, pc, rs1A, rs1D, rdA, rdD, imm);
                    default: $display("*[ERROR]@INSTR_TYP_I12JR Func=%b ", func);
                endcase
            end
            `INSTR_TYP_I20PC: begin
                                        $display("No.%-3d AUIPC:  @[%08H] rd  is x%-2d<=0x%08H, imm is 0x%08H", cnt, pc, rdA, rdD, imm);
            end
            default: begin
                $display("*[ERROR] Machine Code is instr=%08H, @[%08H]", instr, pc);
            end
        endcase
    end
    endtask

`endif /* DEBUG_TRACE_LOG_ENABLE */

endmodule

`endif 