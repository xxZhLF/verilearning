`timescale 100ps/1ps    

module AdderHF1bit_tb (
    // None
);

    reg  in1, in2; 
    wire out;
    initial begin
           in1 = 1'b0;
           in2 = 1'b0;
    end

    always begin
        #5 in1 = 1'b0;
        #5 in2 = 1'b1;
        #5 in1 = 1'b1;
        #5 in2 = 1'b0;
        #5 in1 = 1'b1;
        #5 in2 = 1'b1;        
    end

    AdderHF1bit adder(
        .in1(in1), .in2(in2),
        .out(out)
    );

    initial begin
        $display("Finish");
        $dumpfile("AdderHF1bit.vcd");
        $dumpvars(0, in1);
        $dumpvars(1, in2);
        $dumpvars(2, out);
        $finish;
    end

endmodule