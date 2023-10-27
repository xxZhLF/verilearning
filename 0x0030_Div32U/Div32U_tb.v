`timescale 1ps/1ps

module Div32U_tb(
    // None
);
    reg         off, rst, clk;
    reg  [31:0] cnt;
    reg  [31:0] dived, divor;
    reg  [31:0] quoti, remai;

    initial begin
           off = 1'b1; rst = 1'b1; clk = 1'b0;
        #5 off = 1'b0;
    end

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (off) begin
            {rst, clk} <= 2'b00;
            dived <= 32'h00000000;
            divor <= 32'h00000000;
        end else begin
            case (cnt)
                32'h00000000: begin 
                    rst <= 1'b1; 
                    dived <= 32'h00000007; 
                    divor <= 32'h00000004;
                end
                32'h00000020: begin
                    rst <= 1'b1; 
                    dived <= 32'h00000004; 
                    divor <= 32'h00000007;
                end
                32'h00000040: begin
                    rst <= 1'b1; 
                    dived <= 32'h00000010; 
                    divor <= 32'h00000004;
                end
                32'h00000060: begin
                    rst <= 1'b1;
                    dived <= 32'h00000000; 
                    divor <= 32'h00000000;
                    #10 $finish;
                end
                default: rst <= 1'b0;
            endcase
            cnt <= cnt + 1;
        end
    end

    Div32U divider(
        .rst(rst),
        .clk(clk),
        .dived(dived),
        .divor(divor),
        .quoti(quoti),
        .remai(remai)
    );

    initial begin
        $dumpfile("Div32U.vcd");
        $dumpvars(0, clk);
        $dumpvars(0, rst);
        $dumpvars(2, dived);
        $dumpvars(3, divor);
        $dumpvars(4, quoti);
        $dumpvars(5, remai);
    end

endmodule