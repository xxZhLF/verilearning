`timescale 1ps/1ps 

`include "CtlALU.v"

module ALU32FF_tb (
    // None
);

    reg  [63:0] tmp [2:0]; 

    reg  [23:0] ctl;
    reg  [31:0] op1, op2;
    wire [31:0] res;

    ALU32FF alu(
        .ctl(ctl),
        .op1(op1),
        .op2(op2),
        .res(res)
    );

    initial begin

        ctl = `ALU_CTL_ADD; op1 = 32'h0097423B; op2 = 32'h014872C1; #5;
        if (res == op1 + op2) begin 
            $display("[OK] ALU_CTL_ADD"); 
        end else begin
            $display("[NG] ALU_CTL_ADD: 0x%08X + 0x%08X = 0x%08X (0x%08X)", op1, op2, res, op1 + op2);
        end

        ctl = `ALU_CTL_SUB; op1 = 32'h0135721D; op2 = 32'h0086FC98; #5;
        if (res == op1 - op2) begin 
            $display("[OK] ALU_CTL_SUB"); 
        end else begin
            $display("[NG] ALU_CTL_SUB: 0x%08X - 0x%08X = 0x%08X (0x%08X)", op1, op2, res,op1 - op2);
        end

        ctl = `ALU_CTL_MUL; op1 = 32'h8CBDA0FC; op2 = 32'h0012300F; #5;
        if (res == op1 * op2) begin 
            $display("[OK] ALU_CTL_MUL"); 
        end else begin
            $display("[NG] ALU_CTL_MUL: 0x%08X * 0x%08X = 0x%08X (0x%08X)", op1, op2, res, op1 * op2);
        end

        ctl = `ALU_CTL_DIV; op1 = 32'h0AE02023; op2 = 32'h80000A12; #5;
        if (res == op1 / op2) begin 
            $display("[OK] ALU_CTL_DIV"); 
        end else begin
            $display("[NG] ALU_CTL_DIV: 0x%08X / 0x%08X = 0x%08X (0x%08X)", op1, op2, res, op1 / op2);
        end

        ctl = `ALU_CTL_REM; op1 = 32'h0AE02023; op2 = 32'h80000A12; #5;
        if (res == op1 % op2) begin 
            $display("[OK] ALU_CTL_REM"); 
        end else begin
            $display("[NG] ALU_CTL_REM: 0x%08X %% 0x%08X = 0x%08X (0x%08X)", op1, op2, res, op1 % op2);
        end

        ctl = `ALU_CTL_DIVU; op1 = 32'h0AE02023; op2 = 32'h80000A12; #5;
        if (res == op1 / op2) begin 
            $display("[OK] ALU_CTL_DIVU"); 
        end else begin
            $display("[NG] ALU_CTL_DIVU: 0x%08X / 0x%08X = 0x%08X (0x%08X)", op1, op2, res, op1 / op2);
        end

        ctl = `ALU_CTL_REMU; op1 = 32'h0AE02023; op2 = 32'h80000A12; #5;
        if (res == op1 % op2) begin 
            $display("[OK] ALU_CTL_REMU"); 
        end else begin
            $display("[NG] ALU_CTL_REMU: 0x%08X %% 0x%08X = 0x%08X (0x%08X)", op1, op2, res, op1 % op2);
        end

        ctl = `ALU_CTL_MULH; op1 = 32'h0012300F; op2 = 32'h8CBDA0FC; #5;
        tmp[0] = {{32{op1[31]}}, op1} * {{32{op2[31]}}, op2}; 
        if (res == tmp[0][63:32]) begin 
            $display("[OK] ALU_CTL_MULH"); 
        end else begin
            $display("[NG] ALU_CTL_MULH: 0x%08X * 0x%08X = 0x%08X (0x%016X)", op1, op2, res, tmp[0][63:32]);
        end

        ctl = `ALU_CTL_MULHU; op1 = 32'h8CBDA0FC; op2 = 32'h0712300F; #5;
        tmp[1] = {32'b0, op1} * {32'b0, op2}; 
        if (res == tmp[1][63:32]) begin 
            $display("[OK] ALU_CTL_MULHU");
        end else begin
            $display("[NG] ALU_CTL_MULHU: 0x%08X * 0x%08X = 0x%08X (0x%016X)", op1, op2, res, tmp[1][63:32]);
        end

    end

    initial begin
        $dumpfile("ALU32FF.vcd");
        $dumpvars(0, ctl);
        $dumpvars(1, op1);
        $dumpvars(2, op2);
        $dumpvars(3, res);
    end

endmodule