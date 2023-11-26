`timescale 1ps/1ps 

`include "RV32I.v"

module Decoder_tb(
    // None
);

    reg  [31:0] instr;
    wire [ 6:0] op;
    wire [ 4:0] rs1, rs2, rd;
    wire [ 9:0] func;
    wire [11:0] imms;
    wire [19:0] imml;
    Decoder decoder(
        .instr(instr),
        .op(op),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .func(func),
        .imms(imms),
        .imml(imml)
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
            (try it by deletint #5) will be output to the console in the next cycle */ #5;
            case (op)
                `ITYP_R: begin
                    case (func)
                        `ITYP_R_FC_ADD:  $write("ADD with ");
                        `ITYP_R_FC_SUB:  $write("SUB with ");
                        `ITYP_R_FC_SLL:  $write("SLL with ");
                        `ITYP_R_FC_SLT:  $write("SLT with ");
                        `ITYP_R_FC_SLTU: $write("SLTU with ");
                        `ITYP_R_FC_XOR:  $write("XOR with ");
                        `ITYP_R_FC_SRL:  $write("SRL with ");
                        `ITYP_R_FC_SRA:  $write("SRA with ");
                        `ITYP_R_FC_OR:   $write("OR with ");
                        `ITYP_R_FC_AND:  $write("AND with ");
                        default: $write("*[ERROR]@ITYP_R Func = %b", func);
                    endcase
                    $write("rs1=x%-d, rs2=x%-d, rd=x%-d", rs1, rs2, rd);
                end 
                `ITYP_I: begin
                    case (func)
                        `ITYP_I_FC_ADDI:  $write("ADDI with ");
                        `ITYP_I_FC_SLTI:  $write("SLTI with ");
                        `ITYP_I_FC_SLTIU: $write("SLTIU with ");
                        `ITYP_I_FC_XORI:  $write("XORI with ");
                        `ITYP_I_FC_ORI:   $write("ORI with ");
                        `ITYP_I_FC_ANDI:  $write("ANDI with ");
                        `ITYP_I_FC_SLLI:  $write("SLLI with ");
                        `ITYP_I_FC_SRLI:  $write("SRLI with ");
                        `ITYP_I_FC_SRAI:  $write("SRAI with ");
                        default: $write("*[ERROR]@ITYP_I Func=%b", func);
                    endcase
                    $write("rs1=x%-d, rd=x%-d, imm=%-d", rs1, rd, imms);
                end 
                `ITYP_S: begin
                    case (func)
                        `ITYP_S_FC_SB:    $write("SB with ");
                        `ITYP_S_FC_SH:    $write("SH with ");
                        `ITYP_S_FC_SW:    $write("SW with ");
                        default: $write("*[ERROR]@ITYP_S Func=%b", func);
                    endcase
                    $write("rs1=x%-d, rs2=x%-d, imm=%-d", rs1, rs2, imms);
                end 
                `ITYP_B: begin
                    case (func)
                        `ITYP_B_FC_BEQ:   $write("BEQ with ");
                        `ITYP_B_FC_BEN:   $write("BNE with ");
                        `ITYP_B_FC_BLT:   $write("BLT with ");
                        `ITYP_B_FC_BGE:   $write("BGE with ");
                        `ITYP_B_FC_BLTU:  $write("BLTU with ");
                        `ITYP_B_FC_BGEU:  $write("BGEU with ");
                        default: $write("*[ERROR]@ITYP_B Func=%b", func);
                    endcase
                    $write("rs1=x%-d, rs2=x%-d, imm=%-d", rs1, rs2, imms);
                end 
                `ITYP_U: begin
                    $write("LUI with imm=%H", imml);
                end 
                `ITYP_J: begin
                    $write("JAL with imm=%H", imml);
                end 
                `ITYP_I_SP: begin
                    case (func) 
                        `ITYP_I_SP_FC_JALR: $write("JALR with ");
                        default: $write("*[ERROR]@ITYP_I_SP Func=%b", func);
                    endcase
                    $write("rs1=x%-d, rd=x%-d, imm=%-d", rs1, rd, imms);
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