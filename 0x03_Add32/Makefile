TopModule := Add32
Testbehch := Add32_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace
FLGS += -I../0x02_AdderLA32bit

SRCS := $(Testbehch).v
SRCS += $(TopModule).v
SRCS += AdderLA32bit.v

include ../COMMON.mk