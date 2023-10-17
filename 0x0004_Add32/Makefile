TopModule := Add32
Testbehch := Add32_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace
FLGS += -I../0x0003_AdderLC32bit

SRCS := $(Testbehch).v
SRCS += $(TopModule).v
SRCS += AdderLC32bit.v

include ../COMMON.mk