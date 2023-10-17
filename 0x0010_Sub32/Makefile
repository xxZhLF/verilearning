TopModule := Sub32
Testbehch := Sub32_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace
FLGS += -I../0x0003_AdderLC32bit
FLGS += -I../0x0004_Add32

SRCS := $(Testbehch).v
SRCS += $(TopModule).v
SRCS += AdderLC32bit.v
SRCS += Add32.v

include ../COMMON.mk