`timescale 1ps/1ps 

`include "RV32I.v"

module Decoder_tb(
    // None
);

    reg  [31:0] instr;
    wire [ 6:0] op;
    wire [ 4:0] rs1, rs2, rd;
    wire [ 9:0] func;
    wire [31:0] imm;
    Decoder decoder(
        .instr(instr),
        .op(op),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .func(func),
        .imm(imm)
    );

    parameter L = 16;
    reg [L*8-1 : 0] mnemonic_p1; 
    reg [L*8-1 : 0] mnemonic_p2;
    function [L*8-1 : 0] prepro;
        input [L*8-1 : 0] mnemonic;
        begin
            for (integer i = 0; i < L; ++i) begin
                if (mnemonic[(L-1)*8-1 : (L-2)*8] == 0) begin
                    mnemonic = mnemonic << 8;
                end else begin
                    return mnemonic;
                end
            end
        end
    endfunction

    integer fd;
    initial begin
        fd = $fopen("prog.mc", "r");
        if (fd == 0) begin
            $display("* WARNING: Test Program is NOT Exist!");
            $display("* SUGGEST: Run \"make prog.mc\" to generate, Please.");
            $finish;
        end
    end

    reg clk; initial clk =1'b0;
    reg [31:0] instruction;
    always #5 clk = ~clk;
    always @(posedge clk) begin
        if ($feof(fd)) begin
            $fclose(fd);
            $finish;
        end else begin
            $fscanf(fd, "%h \t %s \t %s \n", instruction, mnemonic_p1, mnemonic_p2);
            mnemonic_p1 = prepro(mnemonic_p1); 
            mnemonic_p2 = prepro(mnemonic_p2);
            $write("%s:\t %H => ", {mnemonic_p1[15*8-1 : 8*8], mnemonic_p2}, instruction);
            instr = instruction; /* Hint: Dealy for $write(). Otherwise the current result 
            (try it by deleting #5) will be output to the console in the next cycle */ #5;
            case (op)
                `INSTR_TYP_R: begin
                    case (func)
                        `R_TYP_FC_ADD:  $write("ADD with ");
                        `R_TYP_FC_SUB:  $write("SUB with ");
                        `R_TYP_FC_SLL:  $write("SLL with ");
                        `R_TYP_FC_SLT:  $write("SLT with ");
                        `R_TYP_FC_SLTU: $write("SLTU with ");
                        `R_TYP_FC_XOR:  $write("XOR with ");
                        `R_TYP_FC_SRL:  $write("SRL with ");
                        `R_TYP_FC_SRA:  $write("SRA with ");
                        `R_TYP_FC_OR:   $write("OR with ");
                        `R_TYP_FC_AND:  $write("AND with ");
                        default: $write("*[ERROR]@INSTR_TYP_R Func = %b", func);
                    endcase
                    $write("rs1=x%-d, rs2=x%-d, rd=x%-d", rs1, rs2, rd);
                end 
                `INSTR_TYP_I: begin
                    case (func)
                        `I_TYP_FC_ADDI:  $write("ADDI with ");
                        `I_TYP_FC_SLTI:  $write("SLTI with ");
                        `I_TYP_FC_SLTIU: $write("SLTIU with ");
                        `I_TYP_FC_XORI:  $write("XORI with ");
                        `I_TYP_FC_ORI:   $write("ORI with ");
                        `I_TYP_FC_ANDI:  $write("ANDI with ");
                        `I_TYP_FC_SLLI:  $write("SLLI with ");
                        `I_TYP_FC_SRLI:  $write("SRLI with ");
                        `I_TYP_FC_SRAI:  $write("SRAI with ");
                        default: $write("*[ERROR]@INSTR_TYP_I Func=%b", func);
                    endcase
                    $write("rs1=x%-d, rd=x%-d, imm=%-d", rs1, rd, $signed(imm));
                end 
                `INSTR_TYP_S: begin
                    case (func)
                        `S_TYP_FC_SB: $write("SB with ");
                        `S_TYP_FC_SH: $write("SH with ");
                        `S_TYP_FC_SW: $write("SW with ");
                        default: $write("*[ERROR]@INSTR_TYP_S Func=%b", func);
                    endcase
                    $write("rs1=x%-d, rs2=x%-d, imm=%-d", rs1, rs2, $signed(imm));
                end 
                `INSTR_TYP_B: begin
                    case (func)
                        `B_TYP_FC_BEQ:  $write("BEQ with ");
                        `B_TYP_FC_BEN:  $write("BNE with ");
                        `B_TYP_FC_BLT:  $write("BLT with ");
                        `B_TYP_FC_BGE:  $write("BGE with ");
                        `B_TYP_FC_BLTU: $write("BLTU with ");
                        `B_TYP_FC_BGEU: $write("BGEU with ");
                        default: $write("*[ERROR]@INSTR_TYP_B Func=%b", func);
                    endcase
                    $write("rs1=x%-d, rs2=x%-d, imm=%-d", rs1, rs2, $signed(imm));
                end 
                `INSTR_TYP_U: begin
                    $write("LUI with rd=x%-d, imm=0x%05H", rd, $signed(imm[31:12]));
                end 
                `INSTR_TYP_J: begin
                    $write("JAL with rd=x%-d, imm=0x%05H", rd, $signed(imm));
                end 
                `INSTR_TYP_ILD: begin
                    case (func) 
                        `ILD_TYP_FC_LB:  $write("LB with ");
                        `ILD_TYP_FC_LH:  $write("LH with ");
                        `ILD_TYP_FC_LW:  $write("LW with ");
                        `ILD_TYP_FC_LBU: $write("LBU with ");
                        `ILD_TYP_FC_LHU: $write("LHU with ");
                        default: $write("*[ERROR]@INSTR_TYP_ILD Func=%b", func);
                    endcase
                    $write("rs1=x%-d, rd=x%-d, imm=%-d", rs1, rd, $signed(imm));
                end
                `INSTR_TYP_IJR: begin
                    case (func) 
                        `IJR_TYP_FC_JALR: $write("JALR with ");
                        default: $write("*[ERROR]@INSTR_TYP_IJR Func=%b", func);
                    endcase
                    $write("rs1=x%-d, rd=x%-d, imm=%-d", rs1, rd, $signed(imm));
                end
                default: begin
                    $write("*[ERROR] Machine Code is %H, op=%b", instr, op);
                end
            endcase
            $write("\n");
        end
    end

    initial begin
        $dumpfile("Decoder.vcd");
        $dumpvars(0, instr);
        $dumpvars(1, op);
        $dumpvars(2, rs1);
        $dumpvars(3, rs2);
        $dumpvars(4, rd);
        $dumpvars(5, func);
        $dumpvars(6, imms);
        $dumpvars(7, imml);
    end

endmodule