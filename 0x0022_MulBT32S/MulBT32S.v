`include "../IPs_shared/Add64.v"
`include "../IPs_shared/Shift.v"
`include "../IPs_shared/TC_converter.v"

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

    // generate
    //     for (genvar i = 0; i < 6; ++i) begin
    //         wire [63:0] c, s;
    //         AdderCS64bit adderCS(
    //             .op1(),
    //             .op2(),
    //             .op3(),
    //             .sum(),
    //             .carry(),
    //         );
    //     end
    // endgenerate

endmodule

module BoothEncoding (
    input  wire[ 2:0] grp,  // Group of 3-bit 
    input  wire[ 2:0] gid,  // Index of Group
    input  wire[31:0] op1,  // Multiplier
    output wire[63:0] pp    // Partial Product
);

    wire [63:0] op1EX; // Symbol Expansion
    assign op1EX = {op1[31] ? 32'hFFFFFFFF : 32'h00000000, op1};

    wire        sb;  // sign of partial product
    wire [ 7:0] nb;  // bits to be shift
    //                                                                          i        +/-     2i
    assign {sb, nb} = (((~|{grp ^ 3'b000}) | (~|{grp ^ 3'b111})) & (~|{gid ^ 3'd0})) ? {1'b0, 8'hFF} : // shift
                      (((~|{grp ^ 3'b000}) | (~|{grp ^ 3'b111})) & (~|{gid ^ 3'd1})) ? {1'b0, 8'hFF} : // return
                      (((~|{grp ^ 3'b000}) | (~|{grp ^ 3'b111})) & (~|{gid ^ 3'd2})) ? {1'b0, 8'hFF} : // 64'h00
                      (((~|{grp ^ 3'b000}) | (~|{grp ^ 3'b111})) & (~|{gid ^ 3'd3})) ? {1'b0, 8'hFF} : // if
                      (((~|{grp ^ 3'b000}) | (~|{grp ^ 3'b111})) & (~|{gid ^ 3'd4})) ? {1'b0, 8'hFF} : // n
                      (((~|{grp ^ 3'b000}) | (~|{grp ^ 3'b111})) & (~|{gid ^ 3'd5})) ? {1'b0, 8'hFF} : // is
                      (((~|{grp ^ 3'b000}) | (~|{grp ^ 3'b111})) & (~|{gid ^ 3'd6})) ? {1'b0, 8'hFF} : //  8'hFF
                      (((~|{grp ^ 3'b000}) | (~|{grp ^ 3'b111})) & (~|{gid ^ 3'd7})) ? {1'b0, 8'hFF} : // E
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd0})) ? {1'b0, 8'h00} : // S
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd1})) ? {1'b0, 8'h02} : 
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd2})) ? {1'b0, 8'h04} : 
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd3})) ? {1'b0, 8'h06} : 
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd4})) ? {1'b0, 8'h08} : 
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd5})) ? {1'b0, 8'h0A} : 
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd6})) ? {1'b0, 8'h0C} : // E
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd7})) ? {1'b0, 8'h0E} : // S
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd0})) ? {1'b0, 8'h02} : 
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd1})) ? {1'b0, 8'h04} : 
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd2})) ? {1'b0, 8'h06} : 
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd3})) ? {1'b0, 8'h08} : 
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd4})) ? {1'b0, 8'h0A} : 
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd5})) ? {1'b0, 8'h0C} : 
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd6})) ? {1'b0, 8'h0E} : 
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd7})) ? {1'b0, 8'h10} : // E
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd0})) ? {1'b1, 8'h02} : // S
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd1})) ? {1'b1, 8'h04} : 
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd2})) ? {1'b1, 8'h06} : 
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd3})) ? {1'b1, 8'h08} : 
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd4})) ? {1'b1, 8'h0A} : 
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd5})) ? {1'b1, 8'h0C} : 
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd6})) ? {1'b1, 8'h0E} : 
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd7})) ? {1'b1, 8'h10} : // E
                      (((~|{grp ^ 3'b101}) | (~|{grp ^ 3'b110})) & (~|{gid ^ 3'd0})) ? {1'b1, 8'h00} : // S
                      (((~|{grp ^ 3'b101}) | (~|{grp ^ 3'b110})) & (~|{gid ^ 3'd1})) ? {1'b1, 8'h02} : 
                      (((~|{grp ^ 3'b101}) | (~|{grp ^ 3'b110})) & (~|{gid ^ 3'd2})) ? {1'b1, 8'h04} : 
                      (((~|{grp ^ 3'b101}) | (~|{grp ^ 3'b110})) & (~|{gid ^ 3'd3})) ? {1'b1, 8'h06} : 
                      (((~|{grp ^ 3'b101}) | (~|{grp ^ 3'b110})) & (~|{gid ^ 3'd4})) ? {1'b1, 8'h08} : 
                      (((~|{grp ^ 3'b101}) | (~|{grp ^ 3'b110})) & (~|{gid ^ 3'd5})) ? {1'b1, 8'h0A} : 
                      (((~|{grp ^ 3'b101}) | (~|{grp ^ 3'b110})) & (~|{gid ^ 3'd6})) ? {1'b1, 8'h0C} : 
                      (((~|{grp ^ 3'b101}) | (~|{grp ^ 3'b110})) & (~|{gid ^ 3'd7})) ? {1'b1, 8'h0E} : {1'bZ, 8'hZZ};

    wire [63:0] shout;
    ShiftL64 shift(
        .n(nb),
        .in(op1EX),
        .out(shout)
    );

    wire [63:0] t2cout;
    TCC64 t2c(
        .T(shout),
        .C(t2cout)
    );

    wire [63:0] c2tout;
    CTC64 c2t(
        .C(shout),
        .T(c2tout)
    );

    assign pp = ~sb ? shout :  // sb is 0 add pp, sb is 0 sub pp
          shout[63] ? {1'b0, c2tout[62:0]} :   // sign of pp is 1, -pp -> +pp
                      {1'b1, t2cout[62:0]};    // sign of pp is 0, +pp -> -pp
    
endmodule