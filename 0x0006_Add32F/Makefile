TopModule := Add32F
Testbehch := Add32F_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace
FLGS += -I../0x0001_AdderFL1bit
FLGS += -I../0x0003_AdderLC32bit

SRCS := $(Testbehch).v
SRCS += $(TopModule).v
SRCS += AdderFL1bit.v
SRCS += AdderLC32bit.v

include ../COMMON.mk