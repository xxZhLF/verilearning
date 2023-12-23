`ifndef MICROARCHITECTURE_SINGLE_CYCLE_V
`define MICROARCHITECTURE_SINGLE_CYCLE_V

`include "../IPs_shared/universal4inc.v"
`include "../0x0101_ALU32FF/ALU1HotCtl.v"
`include "../0x0200_REGs3P/RegName.v"
`include "../0x0300_PC/PCIM.v"
`include "../0x0400_Decoder/RV32I.v"
`include "../0x0400_Decoder/RV32M.v"
`include "../0x0500_Mem/MemIO.v"

`define START_POINT_at(sp) (sp - 32'd8)

`define DATA_ST `MM_ENB_W
`define DATA_LD `MM_ENB_R

module MicroarchiSC (
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
    wire [ 4:0] rf_wA;
    wire [31:0] rf_wD;
    wire [ 4:0] rf_r0A, rf_r1A;
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

    assign decoder_instr  = instr;
    assign where_is_instr = rst ? 32'd2048 : pc_addr;

    assign c2t_r0DC  = rf_r0D;
    assign c2t_r1DC  = rf_r1D;
    assign c2t_immC  = decoder_imm;
    assign rf_r0A    = decoder_rs1;
    assign rf_r1A    = decoder_rs2;
    assign rf_wA     = decoder_rd;

    assign {
        alu_ctl,
        alu_op1,
        alu_op2
    } = `isEQ(decoder_op, `INSTR_TYP_R)     ? `isEQ(decoder_func, `R_TYP_FC_ADD)      ? {`ALU_CTL_ADD,  rf_r0D,                 rf_r1D                    } :
                                              `isEQ(decoder_func, `R_TYP_FC_SUB)      ? {`ALU_CTL_SUB,  rf_r0D,                 rf_r1D                    } : 
                                              `isEQ(decoder_func, `R_TYP_FC_SLL)      ? {`ALU_CTL_SLL,  rf_r0D,                 rf_r1D                    } : 
                                              `isEQ(decoder_func, `R_TYP_FC_SRL)      ? {`ALU_CTL_SRL,  rf_r0D,                 rf_r1D                    } : 
                                              `isEQ(decoder_func, `R_TYP_FC_SRA)      ? {`ALU_CTL_SRA,  rf_r0D,                 rf_r1D                    } : 
                                              `isEQ(decoder_func, `R_TYP_FC_SLT)      ? {`ALU_CTL_SLT,  c2t_r0DT,               c2t_r1DT                  } : 
                                              `isEQ(decoder_func, `R_TYP_FC_SLTU)     ? {`ALU_CTL_SLTU, rf_r0D,                 rf_r1D                    } : 
                                              `isEQ(decoder_func, `R_TYP_FC_AND)      ? {`ALU_CTL_AND,  rf_r0D,                 rf_r1D                    } : 
                                              `isEQ(decoder_func, `R_TYP_FC_OR)       ? {`ALU_CTL_OR,   rf_r0D,                 rf_r1D                    } : 
                                              `isEQ(decoder_func, `R_TYP_FC_XOR)      ? {`ALU_CTL_XOR,  rf_r0D,                 rf_r1D                    } : 
                                              `isEQ(decoder_func, `R_TYP_FC_MUL)      ? {`ALU_CTL_MUL,  rf_r0D,                 rf_r1D                    } : 
                                              `isEQ(decoder_func, `R_TYP_FC_MULH)     ? {`ALU_CTL_MUL,  rf_r0D,                 rf_r1D                    } : 
                                              `isEQ(decoder_func, `R_TYP_FC_MULHU)    ? {`ALU_CTL_MUL,  rf_r0D,                 rf_r1D                    } : 
                                              `isEQ(decoder_func, `R_TYP_FC_MULHSU )  ? {`ALU_CTL_MUL,  rf_r0D,                 rf_r1D                    } : 
                                              `isEQ(decoder_func, `R_TYP_FC_DIV)      ? {`ALU_CTL_DIV,  {1'b0, c2t_r0DT[30:0]}, {1'b0, c2t_r1DT[30:0]}    } : 
                                              `isEQ(decoder_func, `R_TYP_FC_REM)      ? {`ALU_CTL_REM,  {1'b0, c2t_r0DT[30:0]}, {1'b0, c2t_r1DT[30:0]}    } : 
                                              `isEQ(decoder_func, `R_TYP_FC_DIVU)     ? {`ALU_CTL_DIV,  rf_r0D,                 rf_r1D                    } : 
                                              `isEQ(decoder_func, `R_TYP_FC_REMU)     ? {`ALU_CTL_REM,  rf_r0D,                 rf_r1D                    } : {80{1'bZ}} :
                                            /* ======================================================================================================================================= */
        `isEQ(decoder_op, `INSTR_TYP_I)     ? `isEQ(decoder_func, `I_TYP_FC_ADDI)     ? {`ALU_CTL_ADD,  rf_r0D,                 decoder_imm               } : 
                                              `isEQ(decoder_func, `I_TYP_FC_SLTI)     ? {`ALU_CTL_SLT,  c2t_r0DT,               c2t_immT                  } : 
                                              `isEQ(decoder_func, `I_TYP_FC_SLTIU)    ? {`ALU_CTL_SLTU, rf_r0D,                 decoder_imm               } : 
                                              `isEQ(decoder_func, `I_TYP_FC_ANDI)     ? {`ALU_CTL_AND,  rf_r0D,                 decoder_imm               } : 
                                              `isEQ(decoder_func, `I_TYP_FC_ORI)      ? {`ALU_CTL_OR,   rf_r0D,                 decoder_imm               } : 
                                              `isEQ(decoder_func, `I_TYP_FC_XORI)     ? {`ALU_CTL_XOR,  rf_r0D,                 decoder_imm               } : 
                                              `isEQ(decoder_func, `I_TYP_FC_SLLI)     ? {`ALU_CTL_SLL,  rf_r0D,                 decoder_imm               } : 
                                              `isEQ(decoder_func, `I_TYP_FC_SRLI)     ? {`ALU_CTL_SRL,  rf_r0D,                 decoder_imm               } : 
                                              `isEQ(decoder_func, `I_TYP_FC_SRAI)     ? {`ALU_CTL_SRA,  rf_r0D,                 decoder_imm               } : {80{1'bZ}} :
                                            /* ======================================================================================================================================= */
        `isEQ(decoder_op, `INSTR_TYP_S)     ? `isEQ(decoder_func, `S_TYP_FC_SB)       ? {`ALU_CTL_ADD,  rf_r0D,                 decoder_imm               } : 
                                              `isEQ(decoder_func, `S_TYP_FC_SH)       ? {`ALU_CTL_ADD,  rf_r0D,                 decoder_imm               } : 
                                              `isEQ(decoder_func, `S_TYP_FC_SW)       ? {`ALU_CTL_ADD,  rf_r0D,                 decoder_imm               } : {80{1'bZ}} :
                                            /* ======================================================================================================================================= */
        `isEQ(decoder_op, `INSTR_TYP_B)     ? `isEQ(decoder_func, `B_TYP_FC_BEQ)      ? {{16{1'bZ}},    {32{1'bZ}},             {32{1'bZ}}                } : 
                                              `isEQ(decoder_func, `B_TYP_FC_BEN)      ? {{16{1'bZ}},    {32{1'bZ}},             {32{1'bZ}}                } : 
                                              `isEQ(decoder_func, `B_TYP_FC_BLT)      ? {`ALU_CTL_SLT,  c2t_r0DT,               c2t_r1DT                  } : 
                                              `isEQ(decoder_func, `B_TYP_FC_BGE)      ? {`ALU_CTL_SLT,  c2t_r0DT,               c2t_r1DT                  } : 
                                              `isEQ(decoder_func, `B_TYP_FC_BLTU)     ? {`ALU_CTL_SLTU, rf_r0D,                 rf_r1D                    } : 
                                              `isEQ(decoder_func, `B_TYP_FC_BGEU)     ? {`ALU_CTL_SLTU, rf_r0D,                 rf_r1D                    } : {80{1'bZ}} :
                                            /* ======================================================================================================================================= */
        `isEQ(decoder_op, `INSTR_TYP_U)     ?                                    1'b1 ? {{16{1'bZ}},    {32{1'bZ}},             {32{1'bZ}}                } : {80{1'bZ}} :
                                            /* ======================================================================================================================================= */
        `isEQ(decoder_op, `INSTR_TYP_J)     ?                                    1'b1 ? {`ALU_CTL_ADD,  pc_addr,                decoder_imm               } : {80{1'bZ}} :
                                            /* ======================================================================================================================================= */
        `isEQ(decoder_op, `INSTR_TYP_I12LD) ? `isEQ(decoder_func, `I12LD_TYP_FC_LB)   ? {`ALU_CTL_ADD,  rf_r0D,                 decoder_imm               } : 
                                              `isEQ(decoder_func, `I12LD_TYP_FC_LH)   ? {`ALU_CTL_ADD,  rf_r0D,                 decoder_imm               } : 
                                              `isEQ(decoder_func, `I12LD_TYP_FC_LW)   ? {`ALU_CTL_ADD,  rf_r0D,                 decoder_imm               } : 
                                              `isEQ(decoder_func, `I12LD_TYP_FC_LBU)  ? {`ALU_CTL_ADD,  rf_r0D,                 decoder_imm               } : 
                                              `isEQ(decoder_func, `I12LD_TYP_FC_LHU)  ? {`ALU_CTL_ADD,  rf_r0D,                 decoder_imm               } : {80{1'bZ}} :
                                            /* ======================================================================================================================================= */
        `isEQ(decoder_op, `INSTR_TYP_I12JR) ? `isEQ(decoder_func, `I12JR_TYP_FC_JALR) ? {`ALU_CTL_ADD,  rf_r0D,                 decoder_imm               } : {80{1'bZ}} :
                                            /* ======================================================================================================================================= */
        `isEQ(decoder_op, `INSTR_TYP_I20PC) ?                                    1'b1 ? {`ALU_CTL_ADD,  pc_addr,                {decoder_imm[19:0], 12'b0}} : {80{1'bZ}} : {80{1'bZ}};
                                            /* ======================================================================================================================================= */

    assign {
        store_or_load,
        width_of_data,
        locat_of_data,
        dataO
    } = `isEQ(decoder_op, `INSTR_TYP_S)     ? `isEQ(decoder_func,     `S_TYP_FC_SB)  ? {`DATA_ST, `MW_Byte, alu_res,     rf_r1D} : 
                                              `isEQ(decoder_func,     `S_TYP_FC_SH)  ? {`DATA_ST, `MW_Half, alu_res,     rf_r1D} : 
                                              `isEQ(decoder_func,     `S_TYP_FC_SW)  ? {`DATA_ST, `MW_Word, alu_res,     rf_r1D} : {67{1'bZ}} : 
        `isEQ(decoder_op, `INSTR_TYP_I12LD) ? `isEQ(decoder_func, `I12LD_TYP_FC_LB) |
                                              `isEQ(decoder_func, `I12LD_TYP_FC_LBU) ? {`DATA_LD, `MW_Byte, alu_res, {32{1'bZ}}} : 
                                              `isEQ(decoder_func, `I12LD_TYP_FC_LH) |
                                              `isEQ(decoder_func, `I12LD_TYP_FC_LHU) ? {`DATA_LD, `MW_Half, alu_res, {32{1'bZ}}} : 
                                              `isEQ(decoder_func, `I12LD_TYP_FC_LW)  ? {`DATA_LD, `MW_Word, alu_res, {32{1'bZ}}} : {67{1'bZ}} : {67{1'bZ}};

    assign {
        rf_en4w,
        rf_wD
    } = `isEQ(decoder_op, `INSTR_TYP_R) ? {1'b1, `isEQ(decoder_func, `R_TYP_FC_DIV) ? t2c_resC : alu_res} : 
        `isEQ(decoder_op, `INSTR_TYP_I) | 
        `isEQ(decoder_op, `INSTR_TYP_I20PC) ? {1'b1,     alu_res} :
        `isEQ(decoder_op, `INSTR_TYP_J) | 
        `isEQ(decoder_op, `INSTR_TYP_I12JR) ? {1'b1, pc_addr_nxt} :
        `isEQ(decoder_op, `INSTR_TYP_U)     ? {1'b1, decoder_imm} :
        `isEQ(decoder_op, `INSTR_TYP_I12LD) ? {1'b1,       dataI} : {33{1'bZ}};

    assign {
        pc_mode,
        pc_offset,
        pc_target
    } = rst ? {`UCJUMP, {32{1'bZ}}, goto} :
        `isEQ(decoder_op,   `INSTR_TYP_B) ? `isEQ(decoder_func, `B_TYP_FC_BEQ)  ? {`BRANCH, `isEQ(rf_r0D, rf_r1D) ? decoder_imm : 32'd4, {32{1'bZ}}} : 
                                            `isEQ(decoder_func, `B_TYP_FC_BEN)  ? {`BRANCH, `isEQ(rf_r0D, rf_r1D) ? 32'd4 : decoder_imm, {32{1'bZ}}} : 
                                            `isEQ(decoder_func, `B_TYP_FC_BLT)  ? {`BRANCH,            alu_res[0] ? decoder_imm : 32'd4, {32{1'bZ}}} : 
                                            `isEQ(decoder_func, `B_TYP_FC_BGE)  ? {`BRANCH,            alu_res[0] ? 32'd4 : decoder_imm, {32{1'bZ}}} : 
                                            `isEQ(decoder_func, `B_TYP_FC_BLTU) ? {`BRANCH,            alu_res[0] ? decoder_imm : 32'd4, {32{1'bZ}}} : 
                                            `isEQ(decoder_func, `B_TYP_FC_BGEU) ? {`BRANCH,            alu_res[0] ? 32'd4 : decoder_imm, {32{1'bZ}}} : {66{1'bZ}} :
        `isEQ(decoder_op,   `INSTR_TYP_J) ?       {`UCJUMP, {32{1'bZ}},    alu_res} : 
        `isEQ(decoder_op,   `INSTR_TYP_I12JR)   & 
        `isEQ(decoder_func, `I12JR_TYP_FC_JALR) ? {`UCJUMP, {32{1'bZ}},    alu_res} 
                                                : {`NORMAL, {32{1'bZ}}, {32{1'bZ}}};

    reg [31:0] goto;
    always @(negedge rst or posedge clk) begin
        if (rst) begin
            goto <= `START_POINT_at(32'd2048);
        end else begin
        end
    end

`define DEBUG_TRACE_LOG_ENABLE
`ifndef DEBUG_TRACE_LOG_ENABLE
`else

    always @(posedge clk) begin
        if (rst) begin
        end else begin
            DEBUG_detail_of_instr_exec(instr,
                                       pc_addr,
                                       decoder_op,
                                       decoder_func,
                                       decoder_imm,
                                       rf_r0A, rf_r0D,
                                       rf_r1A, rf_r1D,
                                       rf_wA,  rf_wD);
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