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

`ifdef MUTLI_CYCLE
`else
`define START_POINT_at(sp) (sp - 32'd4)
`endif 

`define MUTLI_CYCLE

module MicroarchiMC (
    input  wire        rst,
    input  wire        clk,
    input  wire [31:0] cnt,
    input  wire [31:0] instr,
    input  wire [31:0] dataI,
`ifndef MUTLI_CYCLE
    output wire [31:0] dataO,
    output wire        store_or_load,
    output wire [ 1:0] width_of_data,
    output wire [31:0] locat_of_data,
    output wire [31:0] where_is_instr
`else
    output reg  [31:0] dataO,
    output reg         store_or_load,
    output reg  [ 1:0] width_of_data,
    output reg  [31:0] locat_of_data,
    output reg  [31:0] where_is_instr
`endif
);

`ifdef MUTLI_CYCLE
    reg  [ 1:0] pc_mode;
    reg  [31:0] pc_offset;
    reg  [31:0] pc_target;
`else
    wire [ 1:0] pc_mode;
    wire [31:0] pc_offset;
    wire [31:0] pc_target;
`endif
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

`ifdef MUTLI_CYCLE
    reg         rf_en4w;
    reg  [ 4:0] rf_wA;
    reg  [31:0] rf_wD;
    reg  [ 4:0] rf_r0A, rf_r1A;
`else
    wire        rf_en4w;
    wire [ 4:0] rf_wA;
    wire [31:0] rf_wD;
    wire [ 4:0] rf_r0A, rf_r1A;
`endif
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

`ifdef MUTLI_CYCLE
    reg   [15:0] alu_ctl;
    reg   [31:0] alu_op1;
    reg   [31:0] alu_op2;
`else
    wire  [15:0] alu_ctl;
    wire  [31:0] alu_op1;
    wire  [31:0] alu_op2;
`endif
    wire [31:0] alu_res;
    ALU32FF alu(
        .ctl(alu_ctl),
        .op1(alu_op1),
        .op2(alu_op2),
        .res(alu_res)
    );

`ifdef MUTLI_CYCLE
    reg   [31:0] decoder_instr;
`else
    wire  [31:0] decoder_instr;
`endif
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
        .T({c2t_r0DT[31] ^ c2t_r1DT[31], t2c_resT[30:0]}),
        .C(t2c_resC)
    );

`ifdef MUTLI_CYCLE
`else 
    assign decoder_instr  = instr;
    assign where_is_instr = rst ? 32'd2048 : pc_addr;
`endif 

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
            default: return {16{1'bZ}};
        endcase
    end
    endfunction

    function [31:0] MUX_of_ALU_op1;
        input [ 6:0] op;
        input [ 9:0] func;
        input [31:0] op1;
        input [31:0] op1T;
        input [31:0] pcCrt;
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
            {`INSTR_TYP_I20PC, {10{1'b?}}}:    return pcCrt;
            default: return {32{1'bZ}};
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
            {`INSTR_TYP_R,     {10{1'b?}}},
            {`INSTR_TYP_B,     {10{1'b?}}}:     return op2;
            {`INSTR_TYP_I,     {10{1'b?}}},
            {`INSTR_TYP_S,     {10{1'b?}}},
            {`INSTR_TYP_J,     {10{1'b?}}},
            {`INSTR_TYP_I12LD, {10{1'b?}}},
            {`INSTR_TYP_I12JR, {10{1'b?}}}:     return imm;
            {`INSTR_TYP_R,     `R_TYP_FC_SLT},
            {`INSTR_TYP_B,     `B_TYP_FC_BLT},
            {`INSTR_TYP_B,     `B_TYP_FC_BGE}:  return op2T;
            {`INSTR_TYP_R,     `R_TYP_FC_DIV}, 
            {`INSTR_TYP_R,     `R_TYP_FC_REM}:  return {1'b0, op2T[30:0]};
            {`INSTR_TYP_I,     `I_TYP_FC_SLTI}: return immT;
            {`INSTR_TYP_I20PC, {10{1'b?}}}:     return {decoder_imm[19:0], 12'b0};
            default: return {32{1'bZ}};
        endcase
    end
    endfunction

    function [31:0] MUX_of_RF;
        input [ 6:0] op;
        input [ 9:0] func;
        input [31:0] res;
        input [31:0] resT;
        input [31:0] imm;
        input [31:0] pcNxt;
        input [31:0] fromMem;
    begin
        casez({op, func})
            {`INSTR_TYP_R,     {10{1'b?}}},
            {`INSTR_TYP_I,     {10{1'b?}}},
            {`INSTR_TYP_I20PC, {10{1'b?}}}:    return res;
            {`INSTR_TYP_R,     `R_TYP_FC_DIV}: return resT;
            {`INSTR_TYP_U,     {10{1'b?}}}:    return imm;
            {`INSTR_TYP_J,     {10{1'b?}}},
            {`INSTR_TYP_I12JR, {10{1'b?}}}:    return pcNxt;
            {`INSTR_TYP_I12LD, {10{1'b?}}}:    return fromMem;
            default: return {32{1'bZ}};
        endcase
    end
    endfunction

    function [1:0] MUX_of_PC;
        input [ 6:0] op;
        input [ 9:0] func;
        input [31:0] rs1;
        input [31:0] rs2;
        input [31:0] res;
    begin
        if (`isEQ(op, `INSTR_TYP_B)) begin
            case (func)
                `B_TYP_FC_BEQ:  return `isEQ(rs1, rs2) ? `BRANCH : `NORMAL;   
                `B_TYP_FC_BEN:  return `isEQ(rs1, rs2) ? `NORMAL : `BRANCH;
                `B_TYP_FC_BLT,
                `B_TYP_FC_BLTU: return      alu_res[0] ? `BRANCH : `NORMAL; 
                `B_TYP_FC_BGE,
                `B_TYP_FC_BGEU: return      alu_res[0] ? `NORMAL : `BRANCH; 
                default: return 2'b00;
            endcase
        end else if (`isEQ(op, `INSTR_TYP_J) | (
                     `isEQ(op, `INSTR_TYP_I12JR) & `isEQ(func, `I12JR_TYP_FC_JALR))
                    ) begin
            return `UCJUMP;
        end else begin
            return `NORMAL;
        end
    end
    endfunction

`ifdef MUTLI_CYCLE
`else
    assign alu_ctl = MUX_of_ALU_ctl(decoder_op, decoder_func);
    assign alu_op1 = MUX_of_ALU_op1(decoder_op, decoder_func,
                                    rf_r0D, c2t_r0DT, pc_addr);
    assign alu_op2 = MUX_of_ALU_op2(decoder_op, decoder_func,
                                    rf_r1D, c2t_r1DT, decoder_imm, c2t_immT);

    assign rf_en4w = `isEQ(decoder_op, `INSTR_TYP_R) |
                     `isEQ(decoder_op, `INSTR_TYP_I) |
                     `isEQ(decoder_op, `INSTR_TYP_U) |
                     `isEQ(decoder_op, `INSTR_TYP_J) |
                     `isEQ(decoder_op, `INSTR_TYP_I12LD) |
                     `isEQ(decoder_op, `INSTR_TYP_I12JR) |
                     `isEQ(decoder_op, `INSTR_TYP_I20PC) ? 1'b1 : 1'b0;
    assign rf_wD = MUX_of_RF(decoder_op, decoder_func,
                             alu_res, t2c_resC, decoder_imm, pc_addr_nxt, dataI);

    assign store_or_load = `isEQ(decoder_op,   `INSTR_TYP_S) ? `DATA_ST : `DATA_LD;
    assign width_of_data = `isEQ(decoder_func, `S_TYP_FC_SB) ? `MW_Byte : 
                           `isEQ(decoder_func, `S_TYP_FC_SH) ? `MW_Half :
                           `isEQ(decoder_func, `S_TYP_FC_SW) ? `MW_Word : 2'b00;
    assign locat_of_data = alu_res;
    assign dataO = rf_r1D;

    assign pc_mode   = rst ? `UCJUMP : MUX_of_PC(decoder_op, decoder_func,
                                                 rf_r0D, rf_r1D, alu_res);
    assign pc_target = rst ? goto : alu_res;
    assign pc_offset = decoder_imm;
`endif

`ifdef MUTLI_CYCLE
`else
    reg [31:0] goto;
`endif 
    reg [ 2:0] stat;
    always @(negedge rst or posedge clk) begin
        if (rst) begin
            stat <= `STAT_HALT;
`ifdef MUTLI_CYCLE
            where_is_instr <= 32'd2048;
`else
            goto <= `START_POINT_at(32'd2048);
`endif
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

`ifdef MUTLI_CYCLE
    always @(posedge clk) begin
        if (`isEQ(stat, `STAT_HALT)) begin
            pc_mode   <= `UCJUMP;
            pc_target <= `START_POINT_at(32'd2048);
        end else if (`isEQ(stat, `STAT_IF)) begin
            where_is_instr <= pc_addr;
        end else if (`isEQ(stat, `STAT_ID)) begin
            decoder_instr <= instr;
        end else if (`isEQ(stat, `STAT_EX)) begin
            alu_ctl <= MUX_of_ALU_ctl(decoder_op, decoder_func);
            alu_op1 <= MUX_of_ALU_op1(decoder_op, decoder_func,
                                      rf_r0D, c2t_r0DT, pc_addr);
            alu_op2 <= MUX_of_ALU_op2(decoder_op, decoder_func,
                                      rf_r1D, c2t_r1DT, decoder_imm, c2t_immT);
        end else if (`isEQ(stat, `STAT_MM)) begin
            rf_en4w       <= `isEQ(decoder_op, `INSTR_TYP_R) |
                             `isEQ(decoder_op, `INSTR_TYP_I) |
                             `isEQ(decoder_op, `INSTR_TYP_U) |
                             `isEQ(decoder_op, `INSTR_TYP_J) |
                             `isEQ(decoder_op, `INSTR_TYP_I12LD) |
                             `isEQ(decoder_op, `INSTR_TYP_I12JR) |
                             `isEQ(decoder_op, `INSTR_TYP_I20PC) ? 1'b1 : 1'b0;
            store_or_load <= `isEQ(decoder_op,   `INSTR_TYP_S) ? `DATA_ST : `DATA_LD;
            width_of_data <= `isEQ(decoder_func, `S_TYP_FC_SB) ? `MW_Byte : 
                             `isEQ(decoder_func, `S_TYP_FC_SH) ? `MW_Half :
                             `isEQ(decoder_func, `S_TYP_FC_SW) ? `MW_Word : 2'b00;
            pc_mode       <= MUX_of_PC(decoder_op, decoder_func,
                                       rf_r0D, rf_r1D, alu_res);
            locat_of_data <= alu_res;
        end else if (`isEQ(stat, `STAT_WB)) begin
            dataO     <= rf_r1D;
            rf_wD     <= MUX_of_RF(decoder_op, decoder_func,
                                   alu_res, t2c_resC, decoder_imm, pc_addr_nxt, dataI);
            pc_offset <= decoder_imm;
            pc_target <= alu_res;
        end else begin
        end
    end
`endif 

`define DEBUG_TRACE_LOG_ENABLE
`ifndef DEBUG_TRACE_LOG_ENABLE
`else

    always @(posedge clk) begin
        if (rst) begin
        end else begin
        end
    end

`endif /* DEBUG_TRACE_LOG_ENABLE */

endmodule

`endif 