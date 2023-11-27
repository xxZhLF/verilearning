`ifndef MEMORY_4K_V
`define MEMORY_4K_V

`define WENB 1'b0
`define RENB 1'b1

module Mem4K ( input wire clk,
    /* Port A for instration */ input  wire        A_EnWR,
    /* Port A for instration */ input  wire [31:0] A_ABus,
    /* Port A for instration */ input  wire [31:0] A_DBusW,
    /* Port A for instration */ output wire [31:0] A_DBusR,
    /* Port B for data       */ input  wire        B_EnWR,
    /* Port B for data       */ input  wire [31:0] B_ABus,
    /* Port B for data       */ input  wire [31:0] B_DBusW,
    /* Port B for data       */ output wire [31:0] B_DBusR
);

    reg [31:0] BytesA [3:0];
    reg USELESS4A[4-1 : 0];
    AdderLC32bit adderA0 (
        .op1(A_ABus),
        .op2(32'b0),
        .cin(1'b0),
        .sum(BytesA[0]),
        .cout(USELESS4A[0])
    ), adderA1 (
        .op1(A_ABus),
        .op2(32'b0),
        .cin(1'b0),
        .sum(BytesA[1]),
        .cout(USELESS4A[1])
    ), adderA2 (
        .op1(A_ABus),
        .op2(32'b0),
        .cin(1'b0),
        .sum(BytesA[2]),
        .cout(USELESS4A[2])
    ), adderA3 (
        .op1(A_ABus),
        .op2(32'b0),
        .cin(1'b0),
        .sum(BytesA[3]),
        .cout(USELESS4A[3])
    );

    reg [31:0] BytesB [3:0];
    reg USELESS4B[4-1 : 0];
    AdderLC32bit adderB0 (
        .op1(B_ABus),
        .op2(32'b0),
        .cin(1'b0),
        .sum(BytesB[0]),
        .cout(USELESS4B[0])
    ), adderB1 (
        .op1(B_ABus),
        .op2(32'b0),
        .cin(1'b0),
        .sum(BytesB[1]),
        .cout(USELESS4B[1])
    ), adderB2 (
        .op1(B_ABus),
        .op2(32'b0),
        .cin(1'b0),
        .sum(BytesB[2]),
        .cout(USELESS4B[2])
    ), adderB3 (
        .op1(B_ABus),
        .op2(32'b0),
        .cin(1'b0),
        .sum(BytesB[3]),
        .cout(USELESS4B[3])
    );

    reg [ 7:0] mem [4*1204 : 0];

    reg [31:0] Word4A, Word4B;
    always @(posedge clk) begin
        if (A_EnWR) begin
            Word4A <= {mem[BytesA[3]], mem[BytesA[2]], mem[BytesA[1]], mem[BytesA[0]]};
        end else begin
            {mem[BytesA[3]], mem[BytesA[2]], mem[BytesA[1]], mem[BytesA[0]]} <= A_DBusW;
        end
        if (B_EnWR) begin
            Word4B <= {mem[BytesB[3]], mem[BytesB[2]], mem[BytesB[1]], mem[BytesB[0]]};
        end else begin
            {mem[BytesB[3]], mem[BytesB[2]], mem[BytesB[1]], mem[BytesB[0]]} <= B_DBusW;
        end
    end

    assign A_DBusR = Word4A;
    assign B_DBusR = Word4B;

endmodule

`endif 