module ShiftL64 (
    input  wire [ 7:0] n,
    input  wire [63:0] in,
    output wire [63:0] out
);

    assign out = ~|{n ^ 8'h00} ? in : 
                 ~|{n ^ 8'h01} ? {in[62:0],  1'b0} :
                 ~|{n ^ 8'h02} ? {in[61:0],  2'b0} : 
                 ~|{n ^ 8'h03} ? {in[60:0],  3'b0} : 
                 ~|{n ^ 8'h04} ? {in[59:0],  4'b0} : 
                 ~|{n ^ 8'h05} ? {in[58:0],  5'b0} : 
                 ~|{n ^ 8'h06} ? {in[57:0],  6'b0} : 
                 ~|{n ^ 8'h07} ? {in[56:0],  7'b0} : 
                 ~|{n ^ 8'h08} ? {in[55:0],  8'b0} : 
                 ~|{n ^ 8'h09} ? {in[54:0],  9'b0} : 
                 ~|{n ^ 8'h0A} ? {in[53:0], 10'b0} : 
                 ~|{n ^ 8'h0B} ? {in[52:0], 11'b0} : 
                 ~|{n ^ 8'h0C} ? {in[51:0], 12'b0} : 
                 ~|{n ^ 8'h0D} ? {in[50:0], 13'b0} : 
                 ~|{n ^ 8'h0E} ? {in[49:0], 14'b0} : 
                 ~|{n ^ 8'h0F} ? {in[48:0], 15'b0} : 
                 ~|{n ^ 8'h10} ? {in[47:0], 16'b0} : 
                 ~|{n ^ 8'h11} ? {in[46:0], 17'b0} : 
                 ~|{n ^ 8'h12} ? {in[45:0], 18'b0} : 
                 ~|{n ^ 8'h13} ? {in[44:0], 19'b0} : 
                 ~|{n ^ 8'h14} ? {in[43:0], 20'b0} : 
                 ~|{n ^ 8'h15} ? {in[42:0], 21'b0} : 
                 ~|{n ^ 8'h16} ? {in[41:0], 22'b0} : 
                 ~|{n ^ 8'h17} ? {in[40:0], 23'b0} : 
                 ~|{n ^ 8'h18} ? {in[39:0], 24'b0} : 
                 ~|{n ^ 8'h19} ? {in[38:0], 25'b0} : 
                 ~|{n ^ 8'h1A} ? {in[37:0], 26'b0} : 
                 ~|{n ^ 8'h1B} ? {in[36:0], 27'b0} : 
                 ~|{n ^ 8'h1C} ? {in[35:0], 28'b0} : 
                 ~|{n ^ 8'h1D} ? {in[34:0], 29'b0} : 
                 ~|{n ^ 8'h1E} ? {in[33:0], 30'b0} : 
                 ~|{n ^ 8'h1F} ? {in[32:0], 31'b0} : 
                 ~|{n ^ 8'h20} ? {in[31:0], 32'b0} : 
                 ~|{n ^ 8'h21} ? {in[30:0], 33'b0} : 
                 ~|{n ^ 8'h22} ? {in[29:0], 34'b0} : 
                 ~|{n ^ 8'h23} ? {in[28:0], 35'b0} : 
                 ~|{n ^ 8'h24} ? {in[27:0], 36'b0} : 
                 ~|{n ^ 8'h25} ? {in[26:0], 37'b0} : 
                 ~|{n ^ 8'h26} ? {in[25:0], 38'b0} : 
                 ~|{n ^ 8'h27} ? {in[24:0], 39'b0} : 
                 ~|{n ^ 8'h28} ? {in[23:0], 40'b0} : 
                 ~|{n ^ 8'h29} ? {in[22:0], 41'b0} : 
                 ~|{n ^ 8'h2A} ? {in[21:0], 42'b0} : 
                 ~|{n ^ 8'h2B} ? {in[20:0], 43'b0} : 
                 ~|{n ^ 8'h2C} ? {in[19:0], 44'b0} : 
                 ~|{n ^ 8'h2D} ? {in[18:0], 45'b0} : 
                 ~|{n ^ 8'h2E} ? {in[17:0], 46'b0} : 
                 ~|{n ^ 8'h2F} ? {in[16:0], 47'b0} : 
                 ~|{n ^ 8'h30} ? {in[15:0], 48'b0} : 
                 ~|{n ^ 8'h31} ? {in[14:0], 49'b0} : 
                 ~|{n ^ 8'h32} ? {in[13:0], 50'b0} : 
                 ~|{n ^ 8'h33} ? {in[12:0], 51'b0} : 
                 ~|{n ^ 8'h34} ? {in[11:0], 52'b0} : 
                 ~|{n ^ 8'h35} ? {in[10:0], 53'b0} : 
                 ~|{n ^ 8'h36} ? {in[ 9:0], 54'b0} : 
                 ~|{n ^ 8'h37} ? {in[ 8:0], 55'b0} : 
                 ~|{n ^ 8'h38} ? {in[ 7:0], 56'b0} : 
                 ~|{n ^ 8'h39} ? {in[ 6:0], 57'b0} : 
                 ~|{n ^ 8'h3A} ? {in[ 5:0], 58'b0} : 
                 ~|{n ^ 8'h3B} ? {in[ 4:0], 59'b0} : 
                 ~|{n ^ 8'h3C} ? {in[ 3:0], 60'b0} : 
                 ~|{n ^ 8'h3D} ? {in[ 2:0], 61'b0} : 
                 ~|{n ^ 8'h3E} ? {in[ 1:0], 62'b0} : 
                 ~|{n ^ 8'h3F} ? {in[   0], 63'b0} : 64'h0000000000000000;

endmodule