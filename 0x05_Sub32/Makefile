TopModule := Sub32
Testbehch := Sub32_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace
FLGS += -I../0x02_AdderLA32bit
FLGS += -I../0x03_Add32

SRCS := $(Testbehch).v
SRCS += $(TopModule).v
SRCS += AdderLA32bit.v
SRCS += Add32.v

include ../COMMON.mk