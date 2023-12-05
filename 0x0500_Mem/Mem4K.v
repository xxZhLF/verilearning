`ifndef MEMORY_4K_V
`define MEMORY_4K_V

`include "MemIO.v"

module Mem4K ( input wire clk,
    /* Port A for instration */ input  wire        A_EnWR,
    /* Port A for instration */ input  wire [31:0] A_ABus,
    /* Port A for instration */ input  wire [31:0] A_DBusW,
    /* Port A for instration */ output wire [31:0] A_DBusR,
    /* Port B for data       */ input  wire        B_EnWR,
    /* Port B for data       */ input  wire [ 1:0] B_Size,
    /* Port B for data       */ input  wire [31:0] B_ABus,
    /* Port B for data       */ input  wire [31:0] B_DBusW,
    /* Port B for data       */ output wire [31:0] B_DBusR
);

    reg [31:0] BytesA [3:0];
    Add32 adderA0 (
        .op1(A_ABus),
        .op2(32'd0),
        .sum(BytesA[0])
    ), adderA1 (
        .op1(A_ABus),
        .op2(32'd1),
        .sum(BytesA[1])
    ), adderA2 (
        .op1(A_ABus),
        .op2(32'd2),
        .sum(BytesA[2])
    ), adderA3 (
        .op1(A_ABus),
        .op2(32'd3),
        .sum(BytesA[3])
    );

    reg [31:0] BytesB [3:0];
    Add32 adderB0 (
        .op1(B_ABus),
        .op2(32'd0),
        .sum(BytesB[0])
    ), adderB1 (
        .op1(B_ABus),
        .op2(32'd1),
        .sum(BytesB[1])
    ), adderB2 (
        .op1(B_ABus),
        .op2(32'd2),
        .sum(BytesB[2])
    ), adderB3 (
        .op1(B_ABus),
        .op2(32'd3),
        .sum(BytesB[3])
    );

    reg [ 7:0] mem [4*1024-1 : 0];
    initial begin
        integer i;
        for (i = 0; i < 4096; ++i) begin
            mem[i] = 8'h0;
        end
    end

    reg [31:0] Word4A, Word4B;
    always @(posedge clk) begin
        if (A_EnWR) begin
            {mem[BytesA[3]], mem[BytesA[2]], mem[BytesA[1]], mem[BytesA[0]]} <= A_DBusW;
        end else begin
            Word4A <= {mem[BytesA[3]], mem[BytesA[2]], mem[BytesA[1]], mem[BytesA[0]]};
        end
        if (B_EnWR) begin
            case (B_Size)
                `MW_Byte: {mem[BytesB[0]]} <= B_DBusW[7:0];
                `MW_Half: {mem[BytesB[1]], mem[BytesB[0]]} <= B_DBusW[15:0];
                `MW_Word: {mem[BytesB[3]], mem[BytesB[2]], mem[BytesB[1]], mem[BytesB[0]]} <= B_DBusW[31:0];
                default: ;
            endcase
        end else begin
            case (B_Size)
                `MW_Byte: Word4B[ 7:0] <= {mem[BytesB[0]]};
                `MW_Half: Word4B[15:0] <= {mem[BytesB[1]], mem[BytesB[0]]};
                `MW_Word: Word4B[31:0] <= {mem[BytesB[3]], mem[BytesB[2]], mem[BytesB[1]], mem[BytesB[0]]};
                default: ;
            endcase
        end
    end

    assign A_DBusR = Word4A;
    assign B_DBusR = Word4B;

endmodule

`endif 