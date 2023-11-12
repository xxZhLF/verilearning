`ifndef WALLACE_TREE_4_MULTIPLIER_V
`define WALLACE_TREE_4_MULTIPLIER_V

`define NL0 32
`define NL1 10
`define NL2 7
`define NL3 5
`define NL4 3
`define NL5 2
`define NL6 1
`define NL7 1
`define NL8 1

`define WallaceTree32(array, sum_of_array)          \
                                                    \
wire [63:0] vecL1I [3*`NL1-1:0];                    \
wire [63:0] vecL1O [2*`NL1-1:0];                    \
generate                                            \
    for (genvar i = 0; i < 3*`NL1; ++i) begin       \
        assign vecL1I[i] = array[i];                \
    end                                             \
    for (genvar i = 0; i < `NL1; ++i) begin         \
        AddCS64 adder(                              \
            .op1(vecL1I[3*i+0]),                    \
            .op2(vecL1I[3*i+1]),                    \
            .op3(vecL1I[3*i+2]),                    \
            .sum(vecL1O[2*i+0]),                    \
            .carry(vecL1O[2*i+1])                   \
        );                                          \
    end                                             \
endgenerate                                         \
                                                    \
wire [63:0] vecL2I [3*`NL2-1:0];                    \
wire [63:0] vecL2O [2*`NL2-1:0];                    \
generate /* 3 * NL2 = 21,  2 * NL1 = 20 */          \
    for (genvar i = 0; i < 2*`NL1; ++i) begin       \
        assign vecL2I[i] = vecL1O[i];               \
    end assign vecL2I[3*`NL2-1] = array[`NL0-2];    \
    for (genvar i = 0; i < `NL2; ++i) begin         \
        if (i % 2 == 0) begin                       \
            AddCS64 adder(                          \
                .op1(vecL2I[3*i+0]),                \
                .op2({vecL2I[3*i+1][62:0], 1'b0}),  \
                .op3(vecL2I[3*i+2]),                \
                .sum(vecL2O[2*i+0]),                \
                .carry(vecL2O[2*i+1])               \
            );                                      \
        end else begin                              \
            AddCS64 adder(                          \
                .op1({vecL2I[3*i+0][62:0], 1'b0}),  \
                .op2(vecL2I[3*i+1]),                \
                .op3({vecL2I[3*i+2][62:0], 1'b0}),  \
                .sum(vecL2O[2*i+0]),                \
                .carry(vecL2O[2*i+1])               \
            );                                      \
        end                                         \
    end                                             \
endgenerate                                         \
                                                    \
wire [63:0] vecL3I [3*`NL3-1:0];                    \
wire [63:0] vecL3O [2*`NL3-1:0];                    \
generate /* 3 * NL3 = 15, 2 * NL2 = 14 */           \
    for (genvar i = 0; i < 2*`NL2; ++i) begin       \
        assign vecL3I[i] = vecL2O[i];               \
    end assign vecL3I[3*`NL3-1] = array[`NL0-1];    \
    for (genvar i = 0; i < `NL3; ++i) begin         \
        if (i % 2 == 0) begin                       \
            AddCS64 adder(                          \
                .op1(vecL3I[3*i+0]),                \
                .op2({vecL3I[3*i+1][62:0], 1'b0}),  \
                .op3(vecL3I[3*i+2]),                \
                .sum(vecL3O[2*i+0]),                \
                .carry(vecL3O[2*i+1])               \
            );                                      \
        end else begin                              \
            AddCS64 adder(                          \
                .op1({vecL3I[3*i+0][62:0], 1'b0}),  \
                .op2(vecL3I[3*i+1]),                \
                .op3({vecL3I[3*i+2][62:0], 1'b0}),  \
                .sum(vecL3O[2*i+0]),                \
                .carry(vecL3O[2*i+1])               \
            );                                      \
        end                                         \
    end                                             \
endgenerate                                         \
                                                    \
wire [63:0] vecL4I [3*`NL4-1:0];                    \
wire [63:0] vecL4O [2*`NL4-1:0];                    \
generate /* 3 * NL4 = 9, 2 * NL3 = 10 */            \
    for (genvar i = 0; i < 3*`NL4; ++i) begin       \
        assign vecL4I[i] = vecL3O[i];               \
    end                                             \
    for (genvar i = 0; i < `NL4; ++i) begin         \
        if (i % 2 == 0) begin                       \
            AddCS64 adder(                          \
                .op1(vecL4I[3*i+0]),                \
                .op2({vecL4I[3*i+1][62:0], 1'b0}),  \
                .op3(vecL4I[3*i+2]),                \
                .sum(vecL4O[2*i+0]),                \
                .carry(vecL4O[2*i+1])               \
            );                                      \
        end else begin                              \
            AddCS64 adder(                          \
                .op1({vecL4I[3*i+0][62:0], 1'b0}),  \
                .op2(vecL4I[3*i+1]),                \
                .op3({vecL4I[3*i+2][62:0], 1'b0}),  \
                .sum(vecL4O[2*i+0]),                \
                .carry(vecL4O[2*i+1])               \
            );                                      \
        end                                         \
    end                                             \
endgenerate                                         \
                                                    \
wire [63:0] vecL5I [3*`NL5-1:0];                    \
wire [63:0] vecL5O [2*`NL5-1:0];                    \
generate /* 3 * NL5 = 6, 2 * NL4 = 6 */             \
    for (genvar i = 0; i < 3*`NL5; ++i) begin       \
        assign vecL5I[i] = vecL4O[i];               \
    end                                             \
    for (genvar i = 0; i < `NL5; ++i) begin         \
        if (i % 2 == 0) begin                       \
            AddCS64 adder(                          \
                .op1(vecL5I[3*i+0]),                \
                .op2({vecL5I[3*i+1][62:0], 1'b0}),  \
                .op3(vecL5I[3*i+2]),                \
                .sum(vecL5O[2*i+0]),                \
                .carry(vecL5O[2*i+1])               \
            );                                      \
        end else begin                              \
            AddCS64 adder(                          \
                .op1({vecL5I[3*i+0][62:0], 1'b0}),  \
                .op2(vecL5I[3*i+1]),                \
                .op3({vecL5I[3*i+2][62:0], 1'b0}),  \
                .sum(vecL5O[2*i+0]),                \
                .carry(vecL5O[2*i+1])               \
            );                                      \
        end                                         \
    end                                             \
endgenerate                                         \
                                                    \
wire [63:0] vecL6I [3*`NL6-1:0];                    \
wire [63:0] vecL6O [2*`NL6-1:0];                    \
generate /* 3 * NL6 = 3, 2 * NL5 = 4 */             \
    for (genvar i = 0; i < 3*`NL6; ++i) begin       \
        assign vecL6I[i] = vecL5O[i];               \
    end                                             \
    for (genvar i = 0; i < `NL6; ++i) begin         \
        if (i % 2 == 0) begin                       \
            AddCS64 adder(                          \
                .op1(vecL6I[3*i+0]),                \
                .op2({vecL6I[3*i+1][62:0], 1'b0}),  \
                .op3(vecL6I[3*i+2]),                \
                .sum(vecL6O[2*i+0]),                \
                .carry(vecL6O[2*i+1])               \
            );                                      \
        end else begin                              \
            /* non-existent */                      \
        end                                         \
    end                                             \
endgenerate                                         \
                                                    \
wire [63:0] vecL7I [3*`NL7-1:0];                    \
wire [63:0] vecL7O [2*`NL7-1:0];                    \
generate /* 3 * NL7 = 3, 2 * NL6 = 2 */             \
    for (genvar i = 0; i < 2*`NL6; ++i) begin       \
        assign vecL7I[i] = vecL6O[i];               \
    end assign vecL7I[2*`NL7-1] = vecL5O[2*`NL5-1]; \
    for (genvar i = 0; i < `NL7; ++i) begin         \
        if (i % 2 == 0) begin                       \
            AddCS64 adder(                          \
                .op1(vecL7I[3*i+0]),                \
                .op2({vecL7I[3*i+1][62:0], 1'b0}),  \
                .op3({vecL7I[3*i+2][62:0], 1'b0}),  \
                .sum(vecL7O[2*i+0]),                \
                .carry(vecL7O[2*i+1])               \
            );                                      \
        end else begin                              \
            /* non-existent */                      \
        end                                         \
    end                                             \
endgenerate                                         \
                                                    \
wire [63:0] vecL8I [3*`NL8-1:0];                    \
wire [63:0] vecL8O [2*`NL8-1:0];                    \
generate /* 3 * NL8 = 3, 2 * NL7 = 2 */             \
    for (genvar i = 0; i < 2*`NL7; ++i) begin       \
        assign vecL8I[i] = vecL7O[i];               \
    end assign vecL8I[2*`NL8-1] = vecL3O[2*`NL3-1]; \
    for (genvar i = 0; i < `NL8; ++i) begin         \
        if (i % 2 == 0) begin                       \
            AddCS64 adder(                          \
                .op1(vecL8I[3*i+0]),                \
                .op2({vecL8I[3*i+1][62:0], 1'b0}),  \
                .op3({vecL8I[3*i+2][62:0], 1'b0}),  \
                .sum(vecL8O[2*i+0]),                \
                .carry(vecL8O[2*i+1])               \
            );                                      \
        end else begin                              \
            /* non-existent */                      \
        end                                         \
    end                                             \
endgenerate                                         \
                                                    \
AddLC64 adder(                                      \
    .op1(vecL8O[0]),                                \
    .op2({vecL8O[1][63:1], 1'b0}),                  \
    .sum(sum_of_array)                              \
)

`endif 