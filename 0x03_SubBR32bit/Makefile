TopModule := SubBR32bit
Testbehch := SubBR32bit_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace
FLGS += -I../0x02_AddLA32bit

SRCS := $(Testbehch)
SRCS += $(TopModule)
SRCS += AddLA32bit.v
SRCS += Add32.v
SRCS += Sub32.v

include ../COMMON.mk