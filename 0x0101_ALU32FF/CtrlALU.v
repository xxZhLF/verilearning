`ifndef ALU_CONTRAL_SIGNAL_V
`define ALU_CONTRAL_SIGNAL_V

`define ALU_CTRL_ADD    32'b00000000000000000000000000000001
`define ALU_CTRL_SUB    32'b00000000000000000000000000000010
`define ALU_CTRL_MUL    32'b00000000000000000000000000000100
`define ALU_CTRL_DIV    32'b00000000000000000000000000001000
`define ALU_CTRL_REM    32'b00000000000000000000000000010000
`define ALU_CTRL_DIVU   32'b00000000000000000000000000100000
`define ALU_CTRL_REMU   32'b00000000000000000000000001000000
`define ALU_CTRL_MULH   32'b00000000000000000000000010000000
`define ALU_CTRL_MULHU  32'b00000000000000000000000100000000
`define ALU_CTRL_MULHSU 32'b00000000000000000000001000000000
`define ALU_CTRL_SLT    32'b00000000000000000000010000000000
`define ALU_CTRL_SLTU   32'b00000000000000000000100000000000
`define ALU_CTRL_SLL    32'b00000000000000000001000000000000
`define ALU_CTRL_SRL    32'b00000000000000000010000000000000
`define ALU_CTRL_SRA    32'b00000000000000000100000000000000
`define ALU_CTRL_OR     32'b00000000000000001000000000000000
`define ALU_CTRL_AND    32'b00000000000000010000000000000000
`define ALU_CTRL_XOR    32'b00000000000000100000000000000000

`endif 