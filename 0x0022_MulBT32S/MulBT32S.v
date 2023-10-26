`ifndef MUL_BOOTH_32BIT_SIGNED_V
`define MUL_BOOTH_32BIT_SIGNED_V

`include "../IPs_shared/Add64.v"
`include "../IPs_shared/Shift.v"
`include "../IPs_shared/TC_converter.v"

`define WALLACE

module MulBT32S(
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [63:0] res
);

    reg [2:0] ids [7:0];
    always ids[0] = 3'd0;
    always ids[1] = 3'd1;
    always ids[2] = 3'd2;
    always ids[3] = 3'd3;
    always ids[4] = 3'd4;
    always ids[5] = 3'd5;
    always ids[6] = 3'd6;
    always ids[7] = 3'd7;

    generate
        wire [63:0] PPs [7:0];
        for (genvar i = 0; i < 8; ++i) begin
            if (i == 0) begin
                BoothEncoding be(
                    .grp({op2[1:0], 1'b0}),
                    .gid(ids[i]),
                    .op1(op1),
                    .pp(PPs[i])
                );
            end else begin
                BoothEncoding be(
                    .grp(op2[2*i + 1 : 2*i - 1]),
                    .gid(ids[i]),
                    .op1(op1),
                    .pp(PPs[i])
                );
            end
        end
    endgenerate

`ifndef WALLACE

    wire [63:0] sum [8:0], carry[8:0];
    AddCS64 adderCS_0(
        .op1(PPs[0]),
        .op2(PPs[1]),
        .op3(PPs[2]),
        .sum(sum[0]),
        .carry(carry[0])
    ), adderCS_1(
        .op1({carry[0][62:0], 1'b0}),
        .op2(sum[0]),
        .op3(PPs[3]),
        .sum(sum[1]),
        .carry(carry[1])
    ), adderCS_2(
        .op1({carry[1][62:0], 1'b0}),
        .op2(sum[1]),
        .op3(PPs[4]),
        .sum(sum[2]),
        .carry(carry[2])
    ), adderCS_3(
        .op1({carry[2][62:0], 1'b0}),
        .op2(sum[2]),
        .op3(PPs[5]),
        .sum(sum[3]),
        .carry(carry[3])
    ), adderCS_4(
        .op1({carry[3][62:0], 1'b0}),
        .op2(sum[3]),
        .op3(PPs[6]),
        .sum(sum[4]),
        .carry(carry[4])
    ), adderCS_5(
        .op1({carry[4][62:0], 1'b0}),
        .op2(sum[4]),
        .op3(PPs[7]),
        .sum(sum[5]),
        .carry(carry[5])
    );

    AddLC64 adderLC(
        .op1({carry[5][62:0], 1'b0}),
        .op2(sum[5]),
        .sum(res)
    );

`else

    wire [63:0] sumL1[1:0], carryL1[1:0];
    AddCS64 adderCS_L0_0(
        .op1(PPs[0]),
        .op2(PPs[1]),
        .op3(PPs[2]),
        .sum(sumL1[0]),
        .carry(carryL1[0])
    ), adderCS_L0_1(
        .op1(PPs[3]),
        .op2(PPs[4]),
        .op3(PPs[5]),
        .sum(sumL1[1]),
        .carry(carryL1[1])
    );

    wire [63:0] sumL2[1:0], carryL2[1:0];
    AddCS64 adderCS_L2_0(
        .op1(sumL1[0]),
        .op2({carryL1[0][62:0], 1'b0}),
        .op3(sumL1[1]),
        .sum(sumL2[0]),
        .carry(carryL2[0])
    ), adderCS_L2_1(
        .op1({carryL1[1][62:0], 1'b0}),
        .op2(PPs[6]),
        .op3(PPs[7]),
        .sum(sumL2[1]),
        .carry(carryL2[1])
    );

    wire [63:0] sumL3, carryL3;
    AddCS64 adderCS_L3_0(
        .op1(sumL2[0]),
        .op2({carryL2[0][62:0], 1'b0}),
        .op3(sumL2[1]),
        .sum(sumL3),
        .carry(carryL3)
    );

    wire [63:0] sumL4, carryL4;
    AddCS64 adderCS_L4_0(
        .op1(sumL3),
        .op2({carryL3   [62:0], 1'b0}),
        .op3({carryL2[1][62:0], 1'b0}),
        .sum(sumL4),
        .carry(carryL4)
    );

    AddLC64 adderLC(
        .op1(sumL4),
        .op2({carryL4[62:0], 1'b0}),
        .sum(res)
    );

`endif 

endmodule

module BoothEncoding (
    input  wire[ 2:0] grp,  // 3-Bit Group  
    input  wire[ 2:0] gid,  // Index of Group
    input  wire[31:0] op1,  // Multiplier
    output wire[63:0] pp    // Partial Product
);

    wire [63:0] op1EX; // Symbol Expansion
    assign op1EX = {op1[31] ? 32'hFFFFFFFF : 32'h00000000, op1};

    wire        sb;  // sign of partial product
    wire [ 7:0] nb;  // bits to be shift
    /* Booth Loopup Table                                                       i        +/-     2i    */
    assign {sb, nb} = (((~|{grp ^ 3'b000}) | (~|{grp ^ 3'b111})) & (~|{gid ^ 3'd0})) ? {1'b0, 8'hFF} : /* NOP ; shift  */
                      (((~|{grp ^ 3'b000}) | (~|{grp ^ 3'b111})) & (~|{gid ^ 3'd1})) ? {1'b0, 8'hFF} : /* NOP ; will   */
                      (((~|{grp ^ 3'b000}) | (~|{grp ^ 3'b111})) & (~|{gid ^ 3'd2})) ? {1'b0, 8'hFF} : /* NOP ; return */
                      (((~|{grp ^ 3'b000}) | (~|{grp ^ 3'b111})) & (~|{gid ^ 3'd3})) ? {1'b0, 8'hFF} : /* NOP ; 64'h00 */
                      (((~|{grp ^ 3'b000}) | (~|{grp ^ 3'b111})) & (~|{gid ^ 3'd4})) ? {1'b0, 8'hFF} : /* NOP ; if     */
                      (((~|{grp ^ 3'b000}) | (~|{grp ^ 3'b111})) & (~|{gid ^ 3'd5})) ? {1'b0, 8'hFF} : /* NOP ; n      */
                      (((~|{grp ^ 3'b000}) | (~|{grp ^ 3'b111})) & (~|{gid ^ 3'd6})) ? {1'b0, 8'hFF} : /* NOP ; is     */
                      (((~|{grp ^ 3'b000}) | (~|{grp ^ 3'b111})) & (~|{gid ^ 3'd7})) ? {1'b0, 8'hFF} : /* NOP ;  8'hFF */
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd0})) ? {1'b0, 8'h00} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd1})) ? {1'b0, 8'h02} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd2})) ? {1'b0, 8'h04} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd3})) ? {1'b0, 8'h06} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd4})) ? {1'b0, 8'h08} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd5})) ? {1'b0, 8'h0A} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd6})) ? {1'b0, 8'h0C} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd7})) ? {1'b0, 8'h0E} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd0})) ? {1'b0, 8'h01} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd1})) ? {1'b0, 8'h03} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd2})) ? {1'b0, 8'h05} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd3})) ? {1'b0, 8'h07} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd4})) ? {1'b0, 8'h09} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd5})) ? {1'b0, 8'h0B} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd6})) ? {1'b0, 8'h0D} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd7})) ? {1'b0, 8'h0F} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd0})) ? {1'b1, 8'h01} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd1})) ? {1'b1, 8'h03} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd2})) ? {1'b1, 8'h05} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd3})) ? {1'b1, 8'h07} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd4})) ? {1'b1, 8'h09} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd5})) ? {1'b1, 8'h0B} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd6})) ? {1'b1, 8'h0D} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd7})) ? {1'b1, 8'h1F} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      (((~|{grp ^ 3'b101}) | (~|{grp ^ 3'b110})) & (~|{gid ^ 3'd0})) ? {1'b1, 8'h00} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      (((~|{grp ^ 3'b101}) | (~|{grp ^ 3'b110})) & (~|{gid ^ 3'd1})) ? {1'b1, 8'h02} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      (((~|{grp ^ 3'b101}) | (~|{grp ^ 3'b110})) & (~|{gid ^ 3'd2})) ? {1'b1, 8'h04} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      (((~|{grp ^ 3'b101}) | (~|{grp ^ 3'b110})) & (~|{gid ^ 3'd3})) ? {1'b1, 8'h06} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      (((~|{grp ^ 3'b101}) | (~|{grp ^ 3'b110})) & (~|{gid ^ 3'd4})) ? {1'b1, 8'h08} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      (((~|{grp ^ 3'b101}) | (~|{grp ^ 3'b110})) & (~|{gid ^ 3'd5})) ? {1'b1, 8'h0A} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      (((~|{grp ^ 3'b101}) | (~|{grp ^ 3'b110})) & (~|{gid ^ 3'd6})) ? {1'b1, 8'h0C} : /* -1 * (op1 << 2i) = op1 <<  2i*/ // Dead Branch
                      (((~|{grp ^ 3'b101}) | (~|{grp ^ 3'b110})) & (~|{gid ^ 3'd7})) ? {1'b1, 8'h0E} : /* -1 * (op1 << 2i) = op1 <<  2i*/ {1'bZ, 8'hZZ};

    wire [63:0] shout;
    ShiftL64 shift(
        .n(nb),
        .in(op1EX),
        .out(shout)
    );

    wire [63:0] t2cout;
    TCC64 t2c( // True Code　↓
        .T({sb, shout[62:0]}), 
        .C(t2cout) // 2's Comp
    );

    assign pp = ~sb ? {sb, shout[62:0]} : {sb, t2cout[62:0]};
    
endmodule

`endif 