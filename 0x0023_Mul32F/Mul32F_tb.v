module Mul32F_tb (
    // None
);

    integer fd;
    reg  [31:0] op1, op2, chk;
    wire [31:0] res;

    initial begin
        fd = $fopen("data.tb", "r");
        if (fd == 0) begin
            $display("* WARNING: Test Data is NOT Exist!");
            $display("* SUGGEST: Run \"make c_sim\" to generate, Please.");
            $finish;
        end

        while(!$feof(fd)) begin
            reg  [31:0] a, b, c;
            $fscanf(fd, "%h * %h = %h\n", a, b, c);
            op1 = a; op2 = b; chk = c; #5;
            if (c == res) begin
                $display("[OK] %h * %H = %h",      op1, op2, res     );
            end else begin
                $display("[NG] %h * %h = %h (%h)", op1, op2, res, chk);
            end
        end

        $fclose(fd);
        $finish;
    end

    Mul32F multipiler(
        .op1(op1),
        .op2(op2),
        .res(res)
    );

    initial begin
        $dumpfile("Mul32F.vcd");
        $dumpvars(0, op1);
        $dumpvars(1, op2);
        $dumpvars(3, res);
    end

endmodule