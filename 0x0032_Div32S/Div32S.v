`ifndef DIV_32BIT_SIGNED_V_COMBINATIONAL
`define DIV_32BIT_SIGNED_V_COMBINATIONAL

module Div32S (
    input  wire [31:0] dived,
    input  wire [31:0] divor,
    output wire [31:0] quoti,
    output wire [31:0] remai
);

    wire [31:0] divedT, divorT;
    CTC32 c2t_1 (
        .C(dived),
        .T(divedT)
    ), c2t_2 (
        .C(divor),
        .T(divorT)
    );

    wire [31:0] quotiT;
    Div32U divider(
        .dived({1'b0, divedT[30:0]}),
        .divor({1'b0, divorT[30:0]}),
        .quoti(quotiT),
        .remai(remai)
    );

    TCC32 t2c (
        .T({dived[31] ^ divor[31], quotiT[30:0]}),
        .C(quoti)
    );

endmodule

`endif 