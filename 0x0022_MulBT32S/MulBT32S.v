`ifndef MUL_BOOTH_32BIT_SIGNED_V
`define MUL_BOOTH_32BIT_SIGNED_V

`include "../IPs_shared/universal4inc.v"

`define WALLACE

module MulBT32S(
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [63:0] res
);

    generate
        wire [63:0] PPs [15:0];
        for (genvar i = 0; i < 16; ++i) begin
            if (i == 0) begin
                BoothEncoding be(
                    .grp({op2[1:0], 1'b0}),
                    .gid(i),
                    .op1(op1),
                    .pp(PPs[i])
                );
            end else begin
                BoothEncoding be(
                    .grp(op2[2*i + 1 : 2*i - 1]),
                    .gid(i),
                    .op1(op1),
                    .pp(PPs[i])
                );
            end
        end
    endgenerate

`ifndef WALLACE

    generate
        wire [63:0] sum [16-2-1:0], carry[16-2-1:0];
        for (genvar i = 0; i < 16 - 2; ++i) begin
            if (i == 0) begin
                AddCS64 adderCS(
                    .op1(PPs[0]),
                    .op2(PPs[1]),
                    .op3(PPs[2]),
                    .sum(sum[0]),
                    .carry(carry[0])
                );
            end else begin
                AddCS64 adderCS(
                    .op1({carry[i-1][62:0], 1'b0}),
                    .op2(sum[i-1]),
                    .op3(PPs[i+2]),
                    .sum(sum[i]),
                    .carry(carry[i])
                );
            end
        end
    endgenerate
    AddLC64 adderLC(
        .op1({carry[16-2-1][62:0], 1'b0}),
        .op2(sum[16-2-1]),
        .sum(res)
    );

`else

    wire [63:0] sumL1[4:0], carryL1[4:0];
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
    ), adderCS_L0_2(
        .op1(PPs[6]),
        .op2(PPs[7]),
        .op3(PPs[8]),
        .sum(sumL1[2]),
        .carry(carryL1[2])
    ), adderCS_L0_3(
        .op1(PPs[ 9]),
        .op2(PPs[10]),
        .op3(PPs[11]),
        .sum(sumL1[3]),
        .carry(carryL1[3])
    ), adderCS_L0_4(
        .op1(PPs[12]),
        .op2(PPs[13]),
        .op3(PPs[14]),
        .sum(sumL1[4]),
        .carry(carryL1[4])
    );

    wire [63:0] sumL2[2:0], carryL2[2:0];
    AddCS64 adderCS_L2_0(
        .op1(sumL1[0]),
        .op2({carryL1[0][62:0], 1'b0}),
        .op3(sumL1[1]),
        .sum(sumL2[0]),
        .carry(carryL2[0])
    ), adderCS_L2_1(
        .op1({carryL1[1][62:0], 1'b0}),
        .op2(sumL1[2]),
        .op3({carryL1[2][62:0], 1'b0}),
        .sum(sumL2[1]),
        .carry(carryL2[1])
    ), adderCS_L2_2(
        .op1(sumL1[3]),
        .op2({carryL1[3][62:0], 1'b0}),
        .op3(sumL1[4]),
        .sum(sumL2[2]),
        .carry(carryL2[2])
    );

    wire [63:0] sumL3[1:0], carryL3[1:0];
    AddCS64 adderCS_L3_0(
        .op1(sumL2[0]),
        .op2({carryL2[0][62:0], 1'b0}),
        .op3(sumL2[1]),
        .sum(sumL3[0]),
        .carry(carryL3[0])
    ), adderCS_L3_1(
        .op1({carryL2[1][62:0], 1'b0}),
        .op2(sumL2[2]),
        .op3({carryL2[2][62:0], 1'b0}),
        .sum(sumL3[1]),
        .carry(carryL3[1])
    );

    wire [63:0] sumL4[1:0], carryL4[1:0];
    AddCS64 adderCS_L4_0(
        .op1(sumL3[0]),
        .op2({carryL3[0][62:0], 1'b0}),
        .op3(sumL3[1]),
        .sum(sumL4[0]),
        .carry(carryL4[0])
    ),  adderCS_L4_1(
        .op1({carryL3[1][62:0], 1'b0}),
        .op2({carryL1[4][62:0], 1'b0}),
        .op3(PPs[15]),
        .sum(sumL4[1]),
        .carry(carryL4[1])
    );

    wire [63:0] sumL5, carryL5;
    AddCS64 adderCS_L5_0(
        .op1(sumL4[0]),
        .op2({carryL4[0][62:0], 1'b0}),
        .op3(sumL4[1]),
        .sum(sumL5),
        .carry(carryL5)
    );

    wire [63:0] sumL6, carryL6;
    AddCS64 adderCS_L6_0(
        .op1(sumL5),
        .op2({carryL5   [62:0], 1'b0}),
        .op3({carryL4[1][62:0], 1'b0}),
        .sum(sumL6),
        .carry(carryL6)
    );

    AddLC64 adderLC(
        .op1(sumL6),
        .op2({carryL6[62:0], 1'b0}),
        .sum(res)
    );

`endif 

endmodule

module BoothEncoding (
    input  wire[ 2:0] grp,  // 3-Bit Group  
    input  wire[ 3:0] gid,  // Index of Group
    input  wire[31:0] op1,  // Multiplier
    output wire[63:0] pp    // Partial Product
);

    wire [63:0] op1EX; // Symbol Expansion
    assign op1EX = {{32{op1[31]}}, op1};

    wire        sb;  // sign of partial product
    wire [ 7:0] nb;  // bits to be shift
    /* Booth Loopup Table                                                        i        +/-     2i    */
    assign {sb, nb} = ((`isEQ(grp, 3'b000) | `isEQ(grp, 3'b111)) & `isEQ(gid, 4'h00)) ? {1'b0, 8'hFF} : /* NOP ; shift  */
                      ((`isEQ(grp, 3'b000) | `isEQ(grp, 3'b111)) & `isEQ(gid, 4'h01)) ? {1'b0, 8'hFF} : /* NOP ; will   */
                      ((`isEQ(grp, 3'b000) | `isEQ(grp, 3'b111)) & `isEQ(gid, 4'h02)) ? {1'b0, 8'hFF} : /* NOP ; return */
                      ((`isEQ(grp, 3'b000) | `isEQ(grp, 3'b111)) & `isEQ(gid, 4'h03)) ? {1'b0, 8'hFF} : /* NOP ; 64'h00 */
                      ((`isEQ(grp, 3'b000) | `isEQ(grp, 3'b111)) & `isEQ(gid, 4'h04)) ? {1'b0, 8'hFF} : /* NOP ; if     */
                      ((`isEQ(grp, 3'b000) | `isEQ(grp, 3'b111)) & `isEQ(gid, 4'h05)) ? {1'b0, 8'hFF} : /* NOP ; n      */
                      ((`isEQ(grp, 3'b000) | `isEQ(grp, 3'b111)) & `isEQ(gid, 4'h06)) ? {1'b0, 8'hFF} : /* NOP ; is     */
                      ((`isEQ(grp, 3'b000) | `isEQ(grp, 3'b111)) & `isEQ(gid, 4'h07)) ? {1'b0, 8'hFF} : /* NOP ;  8'hFF */
                      ((`isEQ(grp, 3'b000) | `isEQ(grp, 3'b111)) & `isEQ(gid, 4'h08)) ? {1'b0, 8'hFF} : /* NOP ; */
                      ((`isEQ(grp, 3'b000) | `isEQ(grp, 3'b111)) & `isEQ(gid, 4'h09)) ? {1'b0, 8'hFF} : /* NOP ; */
                      ((`isEQ(grp, 3'b000) | `isEQ(grp, 3'b111)) & `isEQ(gid, 4'h0A)) ? {1'b0, 8'hFF} : /* NOP ; */
                      ((`isEQ(grp, 3'b000) | `isEQ(grp, 3'b111)) & `isEQ(gid, 4'h0B)) ? {1'b0, 8'hFF} : /* NOP ; */
                      ((`isEQ(grp, 3'b000) | `isEQ(grp, 3'b111)) & `isEQ(gid, 4'h0C)) ? {1'b0, 8'hFF} : /* NOP ; */
                      ((`isEQ(grp, 3'b000) | `isEQ(grp, 3'b111)) & `isEQ(gid, 4'h0D)) ? {1'b0, 8'hFF} : /* NOP ; */
                      ((`isEQ(grp, 3'b000) | `isEQ(grp, 3'b111)) & `isEQ(gid, 4'h0E)) ? {1'b0, 8'hFF} : /* NOP ; */
                      ((`isEQ(grp, 3'b000) | `isEQ(grp, 3'b111)) & `isEQ(gid, 4'h0F)) ? {1'b0, 8'hFF} : /* NOP ; */
                      ((`isEQ(grp, 3'b001) | `isEQ(grp, 3'b010)) & `isEQ(gid, 4'h00)) ? {1'b0, 8'h00} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      ((`isEQ(grp, 3'b001) | `isEQ(grp, 3'b010)) & `isEQ(gid, 4'h01)) ? {1'b0, 8'h02} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      ((`isEQ(grp, 3'b001) | `isEQ(grp, 3'b010)) & `isEQ(gid, 4'h02)) ? {1'b0, 8'h04} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      ((`isEQ(grp, 3'b001) | `isEQ(grp, 3'b010)) & `isEQ(gid, 4'h03)) ? {1'b0, 8'h06} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      ((`isEQ(grp, 3'b001) | `isEQ(grp, 3'b010)) & `isEQ(gid, 4'h04)) ? {1'b0, 8'h08} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      ((`isEQ(grp, 3'b001) | `isEQ(grp, 3'b010)) & `isEQ(gid, 4'h05)) ? {1'b0, 8'h0A} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      ((`isEQ(grp, 3'b001) | `isEQ(grp, 3'b010)) & `isEQ(gid, 4'h06)) ? {1'b0, 8'h0C} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      ((`isEQ(grp, 3'b001) | `isEQ(grp, 3'b010)) & `isEQ(gid, 4'h07)) ? {1'b0, 8'h0E} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      ((`isEQ(grp, 3'b001) | `isEQ(grp, 3'b010)) & `isEQ(gid, 4'h08)) ? {1'b0, 8'h10} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      ((`isEQ(grp, 3'b001) | `isEQ(grp, 3'b010)) & `isEQ(gid, 4'h09)) ? {1'b0, 8'h12} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      ((`isEQ(grp, 3'b001) | `isEQ(grp, 3'b010)) & `isEQ(gid, 4'h0A)) ? {1'b0, 8'h14} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      ((`isEQ(grp, 3'b001) | `isEQ(grp, 3'b010)) & `isEQ(gid, 4'h0B)) ? {1'b0, 8'h16} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      ((`isEQ(grp, 3'b001) | `isEQ(grp, 3'b010)) & `isEQ(gid, 4'h0C)) ? {1'b0, 8'h18} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      ((`isEQ(grp, 3'b001) | `isEQ(grp, 3'b010)) & `isEQ(gid, 4'h0D)) ? {1'b0, 8'h1A} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      ((`isEQ(grp, 3'b001) | `isEQ(grp, 3'b010)) & `isEQ(gid, 4'h0E)) ? {1'b0, 8'h1C} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      ((`isEQ(grp, 3'b001) | `isEQ(grp, 3'b010)) & `isEQ(gid, 4'h0F)) ? {1'b0, 8'h1E} : /*  1 * (op1 << 2i) = op1 <<  2i */
                      ((`isEQ(grp, 3'b011)                     ) & `isEQ(gid, 4'h00)) ? {1'b0, 8'h01} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b011)                     ) & `isEQ(gid, 4'h01)) ? {1'b0, 8'h03} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b011)                     ) & `isEQ(gid, 4'h02)) ? {1'b0, 8'h05} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b011)                     ) & `isEQ(gid, 4'h03)) ? {1'b0, 8'h07} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b011)                     ) & `isEQ(gid, 4'h04)) ? {1'b0, 8'h09} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b011)                     ) & `isEQ(gid, 4'h05)) ? {1'b0, 8'h0B} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b011)                     ) & `isEQ(gid, 4'h06)) ? {1'b0, 8'h0D} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b011)                     ) & `isEQ(gid, 4'h07)) ? {1'b0, 8'h0F} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b011)                     ) & `isEQ(gid, 4'h08)) ? {1'b0, 8'h11} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b011)                     ) & `isEQ(gid, 4'h09)) ? {1'b0, 8'h13} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b011)                     ) & `isEQ(gid, 4'h0A)) ? {1'b0, 8'h15} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b011)                     ) & `isEQ(gid, 4'h0B)) ? {1'b0, 8'h17} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b011)                     ) & `isEQ(gid, 4'h0C)) ? {1'b0, 8'h19} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b011)                     ) & `isEQ(gid, 4'h0D)) ? {1'b0, 8'h1B} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b011)                     ) & `isEQ(gid, 4'h0E)) ? {1'b0, 8'h1D} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b011)                     ) & `isEQ(gid, 4'h0F)) ? {1'b0, 8'h1F} : /*  2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b100)                     ) & `isEQ(gid, 4'h00)) ? {1'b1, 8'h01} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b100)                     ) & `isEQ(gid, 4'h01)) ? {1'b1, 8'h03} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b100)                     ) & `isEQ(gid, 4'h02)) ? {1'b1, 8'h05} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b100)                     ) & `isEQ(gid, 4'h03)) ? {1'b1, 8'h07} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b100)                     ) & `isEQ(gid, 4'h04)) ? {1'b1, 8'h09} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b100)                     ) & `isEQ(gid, 4'h05)) ? {1'b1, 8'h0B} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b100)                     ) & `isEQ(gid, 4'h06)) ? {1'b1, 8'h0D} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b100)                     ) & `isEQ(gid, 4'h07)) ? {1'b1, 8'h0F} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b100)                     ) & `isEQ(gid, 4'h08)) ? {1'b1, 8'h11} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b100)                     ) & `isEQ(gid, 4'h09)) ? {1'b1, 8'h13} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b100)                     ) & `isEQ(gid, 4'h0A)) ? {1'b1, 8'h15} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b100)                     ) & `isEQ(gid, 4'h0B)) ? {1'b1, 8'h17} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b100)                     ) & `isEQ(gid, 4'h0C)) ? {1'b1, 8'h19} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b100)                     ) & `isEQ(gid, 4'h0D)) ? {1'b1, 8'h1B} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b100)                     ) & `isEQ(gid, 4'h0E)) ? {1'b1, 8'h1D} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b100)                     ) & `isEQ(gid, 4'h0F)) ? {1'b1, 8'h1F} : /* -2 * (op1 << 2i) = op1 << (2i + 1) */
                      ((`isEQ(grp, 3'b101) | `isEQ(grp, 3'b110)) & `isEQ(gid, 4'h00)) ? {1'b1, 8'h00} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      ((`isEQ(grp, 3'b101) | `isEQ(grp, 3'b110)) & `isEQ(gid, 4'h01)) ? {1'b1, 8'h02} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      ((`isEQ(grp, 3'b101) | `isEQ(grp, 3'b110)) & `isEQ(gid, 4'h02)) ? {1'b1, 8'h04} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      ((`isEQ(grp, 3'b101) | `isEQ(grp, 3'b110)) & `isEQ(gid, 4'h03)) ? {1'b1, 8'h06} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      ((`isEQ(grp, 3'b101) | `isEQ(grp, 3'b110)) & `isEQ(gid, 4'h04)) ? {1'b1, 8'h08} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      ((`isEQ(grp, 3'b101) | `isEQ(grp, 3'b110)) & `isEQ(gid, 4'h05)) ? {1'b1, 8'h0A} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      ((`isEQ(grp, 3'b101) | `isEQ(grp, 3'b110)) & `isEQ(gid, 4'h06)) ? {1'b1, 8'h0C} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      ((`isEQ(grp, 3'b101) | `isEQ(grp, 3'b110)) & `isEQ(gid, 4'h07)) ? {1'b1, 8'h0E} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      ((`isEQ(grp, 3'b101) | `isEQ(grp, 3'b110)) & `isEQ(gid, 4'h08)) ? {1'b1, 8'h10} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      ((`isEQ(grp, 3'b101) | `isEQ(grp, 3'b110)) & `isEQ(gid, 4'h09)) ? {1'b1, 8'h12} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      ((`isEQ(grp, 3'b101) | `isEQ(grp, 3'b110)) & `isEQ(gid, 4'h0A)) ? {1'b1, 8'h14} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      ((`isEQ(grp, 3'b101) | `isEQ(grp, 3'b110)) & `isEQ(gid, 4'h0B)) ? {1'b1, 8'h16} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      ((`isEQ(grp, 3'b101) | `isEQ(grp, 3'b110)) & `isEQ(gid, 4'h0C)) ? {1'b1, 8'h18} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      ((`isEQ(grp, 3'b101) | `isEQ(grp, 3'b110)) & `isEQ(gid, 4'h0D)) ? {1'b1, 8'h1A} : /* -1 * (op1 << 2i) = op1 <<  2i*/
                      ((`isEQ(grp, 3'b101) | `isEQ(grp, 3'b110)) & `isEQ(gid, 4'h0E)) ? {1'b1, 8'h1C} : /* -1 * (op1 << 2i) = op1 <<  2i*/ // Dead Branch
                      ((`isEQ(grp, 3'b101) | `isEQ(grp, 3'b110)) & `isEQ(gid, 4'h0F)) ? {1'b1, 8'h1E} : /* -1 * (op1 << 2i) = op1 <<  2i*/ {1'bZ, 8'hZZ};

    wire [63:0] shout;
    ShiftL64U shift(
        .n(nb),
        .in(op1EX),
        .out(shout)
    );

    wire [63:0] negsh;
    Sub64 negativer(
        .op1(64'b0),
        .op2(shout),
        .diff(negsh)
    );

    assign pp = sb ? negsh : shout;

endmodule

`endif 