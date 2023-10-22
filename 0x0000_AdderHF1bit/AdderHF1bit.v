`ifndef ADDER_HF_1BIT_V
`define ADDER_HF_1BIT_V

module AdderHF1bit (
     input wire in1,
     input wire in2,
    output wire out
);
    assign out = in1 ^ in2;
endmodule

`endif 