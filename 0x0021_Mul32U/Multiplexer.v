module MUX32to1 (
    input  wire [ 4:0] idx,
    input  wire [31:0] set,
    output wire        ele
);

    assign ele = ~|{idx ^ 5'h00} ? set[5'h00] :
                 ~|{idx ^ 5'h01} ? set[5'h01] :
                 ~|{idx ^ 5'h02} ? set[5'h02] :
                 ~|{idx ^ 5'h03} ? set[5'h03] :
                 ~|{idx ^ 5'h04} ? set[5'h04] :
                 ~|{idx ^ 5'h05} ? set[5'h05] :
                 ~|{idx ^ 5'h06} ? set[5'h06] :
                 ~|{idx ^ 5'h07} ? set[5'h07] :
                 ~|{idx ^ 5'h08} ? set[5'h08] :
                 ~|{idx ^ 5'h09} ? set[5'h09] :
                 ~|{idx ^ 5'h0A} ? set[5'h0A] :
                 ~|{idx ^ 5'h0B} ? set[5'h0B] :
                 ~|{idx ^ 5'h0C} ? set[5'h0C] :
                 ~|{idx ^ 5'h0D} ? set[5'h0D] :
                 ~|{idx ^ 5'h0E} ? set[5'h0E] :
                 ~|{idx ^ 5'h0F} ? set[5'h0F] :
                 ~|{idx ^ 5'h10} ? set[5'h10] :
                 ~|{idx ^ 5'h11} ? set[5'h11] :
                 ~|{idx ^ 5'h12} ? set[5'h12] :
                 ~|{idx ^ 5'h13} ? set[5'h13] :
                 ~|{idx ^ 5'h14} ? set[5'h14] :
                 ~|{idx ^ 5'h15} ? set[5'h15] :
                 ~|{idx ^ 5'h16} ? set[5'h16] :
                 ~|{idx ^ 5'h17} ? set[5'h17] :
                 ~|{idx ^ 5'h18} ? set[5'h18] :
                 ~|{idx ^ 5'h19} ? set[5'h19] :
                 ~|{idx ^ 5'h1A} ? set[5'h1A] :
                 ~|{idx ^ 5'h1B} ? set[5'h1B] :
                 ~|{idx ^ 5'h1C} ? set[5'h1C] :
                 ~|{idx ^ 5'h1D} ? set[5'h1D] :
                 ~|{idx ^ 5'h1E} ? set[5'h1E] :
                 ~|{idx ^ 5'h1F} ? set[5'h1F] : 1'b0;
endmodule