module Sub32F_tb (
    // None
);

    integer fd;
    reg  [31:0] op1, op2, chk;
    wire [31:0] diff;

    initial begin
        fd = $fopen("data.tb", "r");
        if (fd == 0) begin
            $display("* WARNING: Test Data is NOT Exist!");
            $display("* SUGGEST: Run \"make c_sim\" to generate, Please.");
            $finish;
        end

        while(!$feof(fd)) begin
            reg  [31:0] a, b, c;
            $fscanf(fd, "%h - %h = %h\n", a, b, c);
            op1 = a; op2 = b; chk = c; #5;
            if (c == diff) begin
                $display("[OK] %h - %H = %h",      op1, op2, diff     );
            end else begin
                $display("[NG] %h - %h = %h (%h)", op1, op2, diff, chk);
            end
        end

        $fclose(fd);
        $finish;
    end

    Sub32F adder(
        .op1(op1),
        .op2(op2),
        .diff(diff)
    );

    initial begin
        $dumpfile("Sub32F.vcd");
        $dumpvars(0, op1);
        $dumpvars(1, op2);
        $dumpvars(3, diff);
    end

endmodule