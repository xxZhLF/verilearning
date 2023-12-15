`timescale 1ps/1ps 

`include "ALU1HotCtl.v"

module ALU32FF_tb (
    // None
);

    reg  [63:0] tmp; 

    reg  [15:0] ctl;
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

        ctl = `ALU_CTL_MULH; op1 = 32'h0012300F; op2 = 32'h8CBDA0FC; #5;
        tmp = {{32{op1[31]}}, op1} * {{32{op2[31]}}, op2}; 
        if (res == tmp[63:32]) begin 
            $display("[OK] ALU_CTL_MULH"); 
        end else begin
            $display("[NG] ALU_CTL_MULH: 0x%08X * 0x%08X = 0x%08X (0x%016X)", op1, op2, res, tmp[63:32]);
        end

        ctl = `ALU_CTL_SLT; op1 = 32'h0012300F; op2 = 32'h8CBDA0FC; #5;
        if (res == {31'b0, op1 < op2}) begin 
            $display("[OK] ALU_CTL_SLT"); 
        end else begin
            $display("[NG] ALU_CTL_SLT: 0x%08X < 0x%08X is %s", op1, op2, res[0] ? "True" : "False");
        end

        ctl = `ALU_CTL_SLTU; op1 = 32'h0012300F; op2 = 32'h8CBDA0FC; #5;
        if (res == {31'b0, op1 < op2}) begin 
            $display("[OK] ALU_CTL_SLTU"); 
        end else begin
            $display("[NG] ALU_CTL_SLTU: 0x%08X < 0x%08X is %s", op1, op2, res[0] ? "True" : "False");
        end

        ctl = `ALU_CTL_SLL; op1 = 32'h0012300F; op2 = 32'h00000007; #5;
        if (res == op1 << op2) begin 
            $display("[OK] ALU_CTL_SLL"); 
        end else begin
            $display("[NG] ALU_CTL_SLL: 0x%08X << %08X = 0x%08X (0x%08X)", op1, op2, res, op1 << op2);
        end

        ctl = `ALU_CTL_SRL; op1 = 32'h0012300F; op2 = 32'h00000007; #5;
        if (res == op1 >> op2) begin 
            $display("[OK] ALU_CTL_SRL"); 
        end else begin
            $display("[NG] ALU_CTL_SRL: 0x%08X >> %08X = 0x%08X (0x%08X)", op1, op2, res, op1 >> op2);
        end

        ctl = `ALU_CTL_SRA; op1 = 32'h8012300F; op2 = 32'h00000007; #5;
        for (integer i = 0; i < op2; ++i) begin
            op1 = op1 >> 1;
            op1[31] = op1[30];
        end
        if (res == op1) begin 
            $display("[OK] ALU_CTL_SRA"); 
        end else begin
            $display("[NG] ALU_CTL_SRA: 0x%08X >> %08X = 0x%08X (0x%08X)", op1, op2, res, op1 >> op2);
        end

        ctl = `ALU_CTL_AND; op1 = 32'h0012300F; op2 = 32'h8CBDA0FC; #5;
        if (res == {op1 & op2}) begin 
            $display("[OK] ALU_CTL_AND"); 
        end else begin
            $display("[NG] ALU_CTL_AND: 0x%08X & %08X = 0x%08X (0x%08X)", op1, op2, res, op1 & op2);
        end

        ctl = `ALU_CTL_OR; op1 = 32'h0012300F; op2 = 32'h8CBDA0FC; #5;
        if (res == {op1 | op2}) begin 
            $display("[OK] ALU_CTL_OR"); 
        end else begin
            $display("[NG] ALU_CTL_OR: 0x%08X | %08X = 0x%08X (0x%08X)", op1, op2, res, op1 | op2);
        end

        ctl = `ALU_CTL_XOR; op1 = 32'h0012300F; op2 = 32'h8CBDA0FC; #5;
        if (res == {op1 ^ op2}) begin 
            $display("[OK] ALU_CTL_XOR"); 
        end else begin
            $display("[NG] ALU_CTL_XOR: 0x%08X ^ %08X = 0x%08X (0x%08X)", op1, op2, res, op1 ^ op2);
        end

        ctl = `ALU_CTL_NOT; op1 = 32'h0012300F; op2 = 32'hZZZZZZZZ; #5;
        if (res == ~op1) begin 
            $display("[OK] ALU_CTL_NOT"); 
        end else begin
            $display("[NG] ALU_CTL_NOT: ~0x%08X = 0x%08X (0x%08X)", op1, res, ~op1);
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