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
SRCS += Add32.v

include ../COMMON.mk