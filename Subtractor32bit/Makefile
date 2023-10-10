TopModule := Sub32bit
Testbehch := Sub32bit_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace
FLGS += -I../AdderLA32bit

SRCS := $(Testbehch)
SRCS += $(TopModule)
SRCS += AdderLA32bit.v

include ../COMMON.mk