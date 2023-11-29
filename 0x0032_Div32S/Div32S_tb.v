`timescale 1ps/1ps    

module Div32S_tb(
    // None
);

    reg  [31:0] dived, divor;
    wire [31:0] quoti, remai;
    initial begin
        dived = 32'h00000000;
        divor = 32'h00000000;
    end

    initial begin
        #5 dived =  32'd7;  divor =  32'd4;
        #5 dived = -32'd4;  divor =  32'd7;
        #5 dived =  32'd16; divor = -32'd4;
        #5 ;
    end

    Div32S divider(
        .dived(dived),
        .divor(divor),
        .quoti(quoti),
        .remai(remai)
    );

    initial begin
        $dumpfile("Div32S.vcd");
        $dumpvars(0, dived);
        $dumpvars(1, divor);
        $dumpvars(3, quoti);
        $dumpvars(3, remai);
    end

endmodule