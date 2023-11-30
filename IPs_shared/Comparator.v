`ifndef IPs_SHARED_COMPARATOR_V
`define IPs_SHARED_COMPARATOR_V

`include "universal4inc.v"

module Cmp32U (
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [ 1:0] res
);

    assign res = op1[31] ^ op2[31] ? (op1[31] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[30] ^ op2[30] ? (op1[30] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[29] ^ op2[29] ? (op1[29] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[28] ^ op2[28] ? (op1[28] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[27] ^ op2[27] ? (op1[27] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[26] ^ op2[26] ? (op1[26] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[25] ^ op2[25] ? (op1[25] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[24] ^ op2[24] ? (op1[24] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[23] ^ op2[23] ? (op1[23] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[22] ^ op2[22] ? (op1[22] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[21] ^ op2[21] ? (op1[21] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[20] ^ op2[20] ? (op1[20] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[19] ^ op2[19] ? (op1[19] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[18] ^ op2[18] ? (op1[18] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[17] ^ op2[17] ? (op1[17] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[16] ^ op2[16] ? (op1[16] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[15] ^ op2[15] ? (op1[15] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[14] ^ op2[14] ? (op1[14] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[13] ^ op2[13] ? (op1[13] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[12] ^ op2[12] ? (op1[12] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[11] ^ op2[11] ? (op1[11] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[10] ^ op2[10] ? (op1[10] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 9] ^ op2[ 9] ? (op1[ 9] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 8] ^ op2[ 8] ? (op1[ 8] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 7] ^ op2[ 7] ? (op1[ 7] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 6] ^ op2[ 6] ? (op1[ 6] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 5] ^ op2[ 5] ? (op1[ 5] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 4] ^ op2[ 4] ? (op1[ 4] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 3] ^ op2[ 3] ? (op1[ 3] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 2] ^ op2[ 2] ? (op1[ 2] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 1] ^ op2[ 1] ? (op1[ 1] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 0] ^ op2[ 0] ? (op1[ 0] ? `OP1_GT_OP2 : `OP1_LT_OP2) : `OP1_EQ_OP2;

endmodule

module Cmp64U (
    input  wire [63:0] op1,
    input  wire [63:0] op2,
    output wire [ 1:0] res
);

    assign res = op1[63] ^ op2[63] ? (op1[63] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[62] ^ op2[62] ? (op1[62] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[61] ^ op2[61] ? (op1[61] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[60] ^ op2[60] ? (op1[60] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[59] ^ op2[59] ? (op1[59] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[58] ^ op2[58] ? (op1[58] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[57] ^ op2[57] ? (op1[57] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[56] ^ op2[56] ? (op1[56] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[55] ^ op2[55] ? (op1[55] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[54] ^ op2[54] ? (op1[54] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[53] ^ op2[53] ? (op1[53] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[52] ^ op2[52] ? (op1[52] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[51] ^ op2[51] ? (op1[51] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[50] ^ op2[50] ? (op1[50] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[49] ^ op2[49] ? (op1[49] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[48] ^ op2[48] ? (op1[48] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[47] ^ op2[47] ? (op1[47] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[46] ^ op2[46] ? (op1[46] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[45] ^ op2[45] ? (op1[45] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[44] ^ op2[44] ? (op1[44] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[43] ^ op2[43] ? (op1[43] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[42] ^ op2[42] ? (op1[42] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[41] ^ op2[41] ? (op1[41] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[40] ^ op2[40] ? (op1[40] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[39] ^ op2[39] ? (op1[39] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[38] ^ op2[38] ? (op1[38] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[37] ^ op2[37] ? (op1[37] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[36] ^ op2[36] ? (op1[36] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[35] ^ op2[35] ? (op1[35] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[34] ^ op2[34] ? (op1[34] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[33] ^ op2[33] ? (op1[33] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[32] ^ op2[32] ? (op1[32] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[31] ^ op2[31] ? (op1[31] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[30] ^ op2[30] ? (op1[30] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[29] ^ op2[29] ? (op1[29] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[28] ^ op2[28] ? (op1[28] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[27] ^ op2[27] ? (op1[27] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[26] ^ op2[26] ? (op1[26] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[25] ^ op2[25] ? (op1[25] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[24] ^ op2[24] ? (op1[24] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[23] ^ op2[23] ? (op1[23] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[22] ^ op2[22] ? (op1[22] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[21] ^ op2[21] ? (op1[21] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[20] ^ op2[20] ? (op1[20] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[19] ^ op2[19] ? (op1[19] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[18] ^ op2[18] ? (op1[18] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[17] ^ op2[17] ? (op1[17] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[16] ^ op2[16] ? (op1[16] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[15] ^ op2[15] ? (op1[15] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[14] ^ op2[14] ? (op1[14] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[13] ^ op2[13] ? (op1[13] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[12] ^ op2[12] ? (op1[12] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[11] ^ op2[11] ? (op1[11] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[10] ^ op2[10] ? (op1[10] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 9] ^ op2[ 9] ? (op1[ 9] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 8] ^ op2[ 8] ? (op1[ 8] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 7] ^ op2[ 7] ? (op1[ 7] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 6] ^ op2[ 6] ? (op1[ 6] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 5] ^ op2[ 5] ? (op1[ 5] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 4] ^ op2[ 4] ? (op1[ 4] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 3] ^ op2[ 3] ? (op1[ 3] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 2] ^ op2[ 2] ? (op1[ 2] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 1] ^ op2[ 1] ? (op1[ 1] ? `OP1_GT_OP2 : `OP1_LT_OP2) :
                 op1[ 0] ^ op2[ 0] ? (op1[ 0] ? `OP1_GT_OP2 : `OP1_LT_OP2) : `OP1_EQ_OP2;

endmodule

module Cmp32S (
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [ 1:0] res
);

    wire [1:0] res_of_dat_cmp;
    Cmp32U cmp_dat(
        .op1({1'b0, op1[30:0]}),
        .op2({1'b0, op2[30:0]}),
        .res(res_of_dat_cmp)
    );

    assign res =  ~(op1[31]  ^   op2[31]) ? res_of_dat_cmp :
                    op1[31]  & (~op2[31]) ? `OP1_LT_OP2 :
                  (~op1[31]) &   op2[31]  ? `OP1_GT_OP2 : 2'bZZ;

endmodule

module Cmp64S (
    input  wire [63:0] op1,
    input  wire [63:0] op2,
    output wire [ 1:0] res
);

    wire [1:0] res_of_dat_cmp;
    Cmp64U cmp_dat(
        .op1({1'b0, op1[62:0]}),
        .op2({1'b0, op2[62:0]}),
        .res(res_of_dat_cmp)
    );

    assign res =  ~(op1[63]  ^   op2[63]) ? res_of_dat_cmp :
                    op1[63]  & (~op2[63]) ? `OP1_LT_OP2 :
                  (~op1[63]) &   op2[63]  ? `OP1_GT_OP2 : 2'bZZ;

endmodule

`endif