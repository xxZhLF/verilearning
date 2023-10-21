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

    wire [63:0] sum [8:0], carry[8:0];
    AddCS64 adderCS_0(
        .op1(PPs[0]),
        .op2(PPs[1]),
        .op3(PPs[2]),
        .sum(sum[0]),
        .carry(carry[0])
    ), adderCS_1(
        .op1(sum[0]),
        .op2(carry[0]),
        .op3(PPs[3]),
        .sum(sum[1]),
        .carry(carry[1])
    ), adderCS_2(
        .op1(sum[1]),
        .op2(carry[1]),
        .op3(PPs[4]),
        .sum(sum[2]),
        .carry(carry[2])
    ), adderCS_3(
        .op1(sum[2]),
        .op2(carry[2]),
        .op3(PPs[5]),
        .sum(sum[3]),
        .carry(carry[3])
    ), adderCS_4(
        .op1(sum[3]),
        .op2(carry[3]),
        .op3(PPs[6]),
        .sum(sum[4]),
        .carry(carry[4])
    ), adderCS_5(
        .op1(sum[4]),
        .op2(carry[4]),
        .op3(PPs[7]),
        .sum(sum[5]),
        .carry(carry[5])
    );

    AddLC64 adderLC(
        .op1(sum[5]),
        .op2(carry[5]),
        .sum(res)
    );

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
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd6})) ? {1'b0, 8'h0C} : 
                      (((~|{grp ^ 3'b001}) | (~|{grp ^ 3'b010})) & (~|{gid ^ 3'd7})) ? {1'b0, 8'h0E} : // E
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd0})) ? {1'b0, 8'h01} : // S
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd1})) ? {1'b0, 8'h03} : 
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd2})) ? {1'b0, 8'h05} : 
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd3})) ? {1'b0, 8'h07} : 
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd4})) ? {1'b0, 8'h09} : 
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd5})) ? {1'b0, 8'h0B} : 
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd6})) ? {1'b0, 8'h0D} : 
                      (((~|{grp ^ 3'b011})                     ) & (~|{gid ^ 3'd7})) ? {1'b0, 8'h0F} : // E
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd0})) ? {1'b1, 8'h01} : // S
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd1})) ? {1'b1, 8'h03} : 
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd2})) ? {1'b1, 8'h05} : 
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd3})) ? {1'b1, 8'h07} : 
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd4})) ? {1'b1, 8'h09} : 
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd5})) ? {1'b1, 8'h0B} : 
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd6})) ? {1'b1, 8'h0D} : 
                      (((~|{grp ^ 3'b100})                     ) & (~|{gid ^ 3'd7})) ? {1'b1, 8'h1F} : // E
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
        .T({sb, shout[62:0]}),
        .C(t2cout)
    );

    assign pp = ~sb ? shout : {1'b1, t2cout[62:0]};
    
endmodule