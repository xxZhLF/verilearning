`ifndef IPs_SHARED_COMPARATOR_V
`define IPs_SHARED_COMPARATOR_V

`include "MacroFunc.v"

`define OP1_GT_OP2 2'b01
`define OP1_LT_OP2 2'b10
`define OP1_EQ_OP2 2'b11

module Cmp64U (
    input  wire [63:0] op1,
    input  wire [63:0] op2,
    output wire [ 1:0] res
);

    assign res = op1[63] ^ op2[63] ? (`isEQ(op1[63], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[62] ^ op2[62] ? (`isEQ(op1[62], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[61] ^ op2[61] ? (`isEQ(op1[61], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[60] ^ op2[60] ? (`isEQ(op1[60], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[59] ^ op2[59] ? (`isEQ(op1[59], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[58] ^ op2[58] ? (`isEQ(op1[58], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[57] ^ op2[57] ? (`isEQ(op1[57], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[56] ^ op2[56] ? (`isEQ(op1[56], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[55] ^ op2[55] ? (`isEQ(op1[55], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[54] ^ op2[54] ? (`isEQ(op1[54], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[53] ^ op2[53] ? (`isEQ(op1[53], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[52] ^ op2[52] ? (`isEQ(op1[52], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[51] ^ op2[51] ? (`isEQ(op1[51], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[50] ^ op2[50] ? (`isEQ(op1[50], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[49] ^ op2[49] ? (`isEQ(op1[49], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[48] ^ op2[48] ? (`isEQ(op1[48], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[47] ^ op2[47] ? (`isEQ(op1[47], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[46] ^ op2[46] ? (`isEQ(op1[46], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[45] ^ op2[45] ? (`isEQ(op1[45], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[44] ^ op2[44] ? (`isEQ(op1[44], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[43] ^ op2[43] ? (`isEQ(op1[43], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[42] ^ op2[42] ? (`isEQ(op1[42], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[41] ^ op2[41] ? (`isEQ(op1[41], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[40] ^ op2[40] ? (`isEQ(op1[40], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[39] ^ op2[39] ? (`isEQ(op1[39], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[38] ^ op2[38] ? (`isEQ(op1[38], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[37] ^ op2[37] ? (`isEQ(op1[37], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[36] ^ op2[36] ? (`isEQ(op1[36], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[35] ^ op2[35] ? (`isEQ(op1[35], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[34] ^ op2[34] ? (`isEQ(op1[34], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[33] ^ op2[33] ? (`isEQ(op1[33], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[32] ^ op2[32] ? (`isEQ(op1[32], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[31] ^ op2[31] ? (`isEQ(op1[31], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[30] ^ op2[30] ? (`isEQ(op1[30], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[29] ^ op2[29] ? (`isEQ(op1[29], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[28] ^ op2[28] ? (`isEQ(op1[28], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[27] ^ op2[27] ? (`isEQ(op1[27], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[26] ^ op2[26] ? (`isEQ(op1[26], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[25] ^ op2[25] ? (`isEQ(op1[25], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[24] ^ op2[24] ? (`isEQ(op1[24], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[23] ^ op2[23] ? (`isEQ(op1[23], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[22] ^ op2[22] ? (`isEQ(op1[22], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[21] ^ op2[21] ? (`isEQ(op1[21], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[20] ^ op2[20] ? (`isEQ(op1[20], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[19] ^ op2[19] ? (`isEQ(op1[19], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[18] ^ op2[18] ? (`isEQ(op1[18], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[17] ^ op2[17] ? (`isEQ(op1[17], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[16] ^ op2[16] ? (`isEQ(op1[16], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[15] ^ op2[15] ? (`isEQ(op1[15], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[14] ^ op2[14] ? (`isEQ(op1[14], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[13] ^ op2[13] ? (`isEQ(op1[13], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[12] ^ op2[12] ? (`isEQ(op1[12], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[11] ^ op2[11] ? (`isEQ(op1[11], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[10] ^ op2[10] ? (`isEQ(op1[10], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 9] ^ op2[ 9] ? (`isEQ(op1[ 9], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 8] ^ op2[ 8] ? (`isEQ(op1[ 8], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 7] ^ op2[ 7] ? (`isEQ(op1[ 7], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 6] ^ op2[ 6] ? (`isEQ(op1[ 6], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 5] ^ op2[ 5] ? (`isEQ(op1[ 5], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 4] ^ op2[ 4] ? (`isEQ(op1[ 4], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 3] ^ op2[ 3] ? (`isEQ(op1[ 3], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 2] ^ op2[ 2] ? (`isEQ(op1[ 2], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 1] ^ op2[ 1] ? (`isEQ(op1[ 1], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 0] ^ op2[ 0] ? (`isEQ(op1[ 0], 1'b1) ? `OP1_GT_OP2 : `OP1_LT_OP2) : `OP1_EQ_OP2;

endmodule

`endif