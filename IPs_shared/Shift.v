`ifndef IPs_SHARED_SHIFT_V
`define IPs_SHARED_SHIFT_V

`include "./MacroFunc.v"

module ShiftL64U (
    input  wire [ 7:0] n,
    input  wire [63:0] in,
    output wire [63:0] out
);

    assign out = `isEQ(n, 8'h00) ? in : 
                 `isEQ(n, 8'h01) ? {in[62:0],  1'b0} :
                 `isEQ(n, 8'h02) ? {in[61:0],  2'b0} : 
                 `isEQ(n, 8'h03) ? {in[60:0],  3'b0} : 
                 `isEQ(n, 8'h04) ? {in[59:0],  4'b0} : 
                 `isEQ(n, 8'h05) ? {in[58:0],  5'b0} : 
                 `isEQ(n, 8'h06) ? {in[57:0],  6'b0} : 
                 `isEQ(n, 8'h07) ? {in[56:0],  7'b0} : 
                 `isEQ(n, 8'h08) ? {in[55:0],  8'b0} : 
                 `isEQ(n, 8'h09) ? {in[54:0],  9'b0} : 
                 `isEQ(n, 8'h0A) ? {in[53:0], 10'b0} : 
                 `isEQ(n, 8'h0B) ? {in[52:0], 11'b0} : 
                 `isEQ(n, 8'h0C) ? {in[51:0], 12'b0} : 
                 `isEQ(n, 8'h0D) ? {in[50:0], 13'b0} : 
                 `isEQ(n, 8'h0E) ? {in[49:0], 14'b0} : 
                 `isEQ(n, 8'h0F) ? {in[48:0], 15'b0} : 
                 `isEQ(n, 8'h10) ? {in[47:0], 16'b0} : 
                 `isEQ(n, 8'h11) ? {in[46:0], 17'b0} : 
                 `isEQ(n, 8'h12) ? {in[45:0], 18'b0} : 
                 `isEQ(n, 8'h13) ? {in[44:0], 19'b0} : 
                 `isEQ(n, 8'h14) ? {in[43:0], 20'b0} : 
                 `isEQ(n, 8'h15) ? {in[42:0], 21'b0} : 
                 `isEQ(n, 8'h16) ? {in[41:0], 22'b0} : 
                 `isEQ(n, 8'h17) ? {in[40:0], 23'b0} : 
                 `isEQ(n, 8'h18) ? {in[39:0], 24'b0} : 
                 `isEQ(n, 8'h19) ? {in[38:0], 25'b0} : 
                 `isEQ(n, 8'h1A) ? {in[37:0], 26'b0} : 
                 `isEQ(n, 8'h1B) ? {in[36:0], 27'b0} : 
                 `isEQ(n, 8'h1C) ? {in[35:0], 28'b0} : 
                 `isEQ(n, 8'h1D) ? {in[34:0], 29'b0} : 
                 `isEQ(n, 8'h1E) ? {in[33:0], 30'b0} : 
                 `isEQ(n, 8'h1F) ? {in[32:0], 31'b0} : 
                 `isEQ(n, 8'h20) ? {in[31:0], 32'b0} : 
                 `isEQ(n, 8'h21) ? {in[30:0], 33'b0} : 
                 `isEQ(n, 8'h22) ? {in[29:0], 34'b0} : 
                 `isEQ(n, 8'h23) ? {in[28:0], 35'b0} : 
                 `isEQ(n, 8'h24) ? {in[27:0], 36'b0} : 
                 `isEQ(n, 8'h25) ? {in[26:0], 37'b0} : 
                 `isEQ(n, 8'h26) ? {in[25:0], 38'b0} : 
                 `isEQ(n, 8'h27) ? {in[24:0], 39'b0} : 
                 `isEQ(n, 8'h28) ? {in[23:0], 40'b0} : 
                 `isEQ(n, 8'h29) ? {in[22:0], 41'b0} : 
                 `isEQ(n, 8'h2A) ? {in[21:0], 42'b0} : 
                 `isEQ(n, 8'h2B) ? {in[20:0], 43'b0} : 
                 `isEQ(n, 8'h2C) ? {in[19:0], 44'b0} : 
                 `isEQ(n, 8'h2D) ? {in[18:0], 45'b0} : 
                 `isEQ(n, 8'h2E) ? {in[17:0], 46'b0} : 
                 `isEQ(n, 8'h2F) ? {in[16:0], 47'b0} : 
                 `isEQ(n, 8'h30) ? {in[15:0], 48'b0} : 
                 `isEQ(n, 8'h31) ? {in[14:0], 49'b0} : 
                 `isEQ(n, 8'h32) ? {in[13:0], 50'b0} : 
                 `isEQ(n, 8'h33) ? {in[12:0], 51'b0} : 
                 `isEQ(n, 8'h34) ? {in[11:0], 52'b0} : 
                 `isEQ(n, 8'h35) ? {in[10:0], 53'b0} : 
                 `isEQ(n, 8'h36) ? {in[ 9:0], 54'b0} : 
                 `isEQ(n, 8'h37) ? {in[ 8:0], 55'b0} : 
                 `isEQ(n, 8'h38) ? {in[ 7:0], 56'b0} : 
                 `isEQ(n, 8'h39) ? {in[ 6:0], 57'b0} : 
                 `isEQ(n, 8'h3A) ? {in[ 5:0], 58'b0} : 
                 `isEQ(n, 8'h3B) ? {in[ 4:0], 59'b0} : 
                 `isEQ(n, 8'h3C) ? {in[ 3:0], 60'b0} : 
                 `isEQ(n, 8'h3D) ? {in[ 2:0], 61'b0} : 
                 `isEQ(n, 8'h3E) ? {in[ 1:0], 62'b0} : 
                 `isEQ(n, 8'h3F) ? {in[   0], 63'b0} : 64'h0000000000000000;

endmodule

module ShiftR64U (
    input  wire [ 7:0] n,
    input  wire [63:0] in,
    output wire [63:0] out
);

    assign out = `isEQ(n, 8'h00) ? in : 
                 `isEQ(n, 8'h01) ? { 1'b0, in[63: 1]} :
                 `isEQ(n, 8'h02) ? { 2'b0, in[63: 2]} : 
                 `isEQ(n, 8'h03) ? { 3'b0, in[63: 3]} : 
                 `isEQ(n, 8'h04) ? { 4'b0, in[63: 4]} : 
                 `isEQ(n, 8'h05) ? { 5'b0, in[63: 5]} : 
                 `isEQ(n, 8'h06) ? { 6'b0, in[63: 6]} : 
                 `isEQ(n, 8'h07) ? { 7'b0, in[63: 7]} : 
                 `isEQ(n, 8'h08) ? { 8'b0, in[63: 8]} : 
                 `isEQ(n, 8'h09) ? { 9'b0, in[63: 9]} : 
                 `isEQ(n, 8'h0A) ? {10'b0, in[63:10]} : 
                 `isEQ(n, 8'h0B) ? {11'b0, in[63:11]} : 
                 `isEQ(n, 8'h0C) ? {12'b0, in[63:12]} : 
                 `isEQ(n, 8'h0D) ? {13'b0, in[63:13]} : 
                 `isEQ(n, 8'h0E) ? {14'b0, in[63:14]} : 
                 `isEQ(n, 8'h0F) ? {15'b0, in[63:15]} : 
                 `isEQ(n, 8'h10) ? {16'b0, in[63:16]} : 
                 `isEQ(n, 8'h11) ? {17'b0, in[63:17]} : 
                 `isEQ(n, 8'h12) ? {18'b0, in[63:18]} : 
                 `isEQ(n, 8'h13) ? {19'b0, in[63:19]} : 
                 `isEQ(n, 8'h14) ? {20'b0, in[63:20]} : 
                 `isEQ(n, 8'h15) ? {21'b0, in[63:21]} : 
                 `isEQ(n, 8'h16) ? {22'b0, in[63:22]} : 
                 `isEQ(n, 8'h17) ? {23'b0, in[63:23]} : 
                 `isEQ(n, 8'h18) ? {24'b0, in[63:24]} : 
                 `isEQ(n, 8'h19) ? {25'b0, in[63:25]} : 
                 `isEQ(n, 8'h1A) ? {26'b0, in[63:26]} : 
                 `isEQ(n, 8'h1B) ? {27'b0, in[63:27]} : 
                 `isEQ(n, 8'h1C) ? {28'b0, in[63:28]} : 
                 `isEQ(n, 8'h1D) ? {29'b0, in[63:29]} : 
                 `isEQ(n, 8'h1E) ? {30'b0, in[63:30]} : 
                 `isEQ(n, 8'h1F) ? {31'b0, in[63:31]} : 
                 `isEQ(n, 8'h20) ? {32'b0, in[63:32]} : 
                 `isEQ(n, 8'h21) ? {33'b0, in[63:33]} : 
                 `isEQ(n, 8'h22) ? {34'b0, in[63:34]} : 
                 `isEQ(n, 8'h23) ? {35'b0, in[63:35]} : 
                 `isEQ(n, 8'h24) ? {36'b0, in[63:36]} : 
                 `isEQ(n, 8'h25) ? {37'b0, in[63:37]} : 
                 `isEQ(n, 8'h26) ? {38'b0, in[63:38]} : 
                 `isEQ(n, 8'h27) ? {39'b0, in[63:39]} : 
                 `isEQ(n, 8'h28) ? {40'b0, in[63:40]} : 
                 `isEQ(n, 8'h29) ? {41'b0, in[63:41]} : 
                 `isEQ(n, 8'h2A) ? {42'b0, in[63:42]} : 
                 `isEQ(n, 8'h2B) ? {43'b0, in[63:43]} : 
                 `isEQ(n, 8'h2C) ? {44'b0, in[63:44]} : 
                 `isEQ(n, 8'h2D) ? {45'b0, in[63:45]} : 
                 `isEQ(n, 8'h2E) ? {46'b0, in[63:46]} : 
                 `isEQ(n, 8'h2F) ? {47'b0, in[63:47]} : 
                 `isEQ(n, 8'h30) ? {48'b0, in[63:48]} : 
                 `isEQ(n, 8'h31) ? {49'b0, in[63:49]} : 
                 `isEQ(n, 8'h32) ? {50'b0, in[63:50]} : 
                 `isEQ(n, 8'h33) ? {51'b0, in[63:51]} : 
                 `isEQ(n, 8'h34) ? {52'b0, in[63:52]} : 
                 `isEQ(n, 8'h35) ? {53'b0, in[63:53]} : 
                 `isEQ(n, 8'h36) ? {54'b0, in[63:54]} : 
                 `isEQ(n, 8'h37) ? {55'b0, in[63:55]} : 
                 `isEQ(n, 8'h38) ? {56'b0, in[63:56]} : 
                 `isEQ(n, 8'h39) ? {57'b0, in[63:57]} : 
                 `isEQ(n, 8'h3A) ? {58'b0, in[63:58]} : 
                 `isEQ(n, 8'h3B) ? {59'b0, in[63:59]} : 
                 `isEQ(n, 8'h3C) ? {60'b0, in[63:60]} : 
                 `isEQ(n, 8'h3D) ? {61'b0, in[63:61]} : 
                 `isEQ(n, 8'h3E) ? {62'b0, in[63:62]} : 
                 `isEQ(n, 8'h3F) ? {63'b0, in[63   ]} : 64'h0000000000000000;

endmodule

`endif 