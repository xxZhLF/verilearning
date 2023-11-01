`timescale 1ps/1ps    

module Div32U_tb(
    // None
);

    reg  [31:0] dived, divor;
    wire [31:0] quoti, remai;
    initial begin
        dived = 32'h00000000;
        divor = 32'h00000000;
    end

    initial begin
        #5 dived = 32'h00000007; divor = 32'h00000004;
        #5 dived = 32'h00000004; divor = 32'h00000007;
        #5 dived = 32'h00000010; divor = 32'h00000004;
        #5 ;
    end

    Div32U divider(
        .dived(dived),
        .divor(divor),
        .quoti(quoti),
        .remai(remai)
    );

    initial begin
        $dumpfile("Div32U.vcd");
        $dumpvars(0, dived);
        $dumpvars(1, divor);
        $dumpvars(3, quoti);
        $dumpvars(3, remai);
    end

endmodule