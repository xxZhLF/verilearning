/*
 * Some Universal Macro defined in this file
 */

`define OP1_GT_OP2 2'b01
`define OP1_LT_OP2 2'b10
`define OP1_EQ_OP2 2'b11

`define isZERO(a) ~|{a}
`define isEQ(a,b) ~|{a ^ b}