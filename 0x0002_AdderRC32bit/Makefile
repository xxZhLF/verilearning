TopModule := AdderRC32bit
Testbehch := AdderRC32bit_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace
FLGS += -I../0x0001_AdderFL1bit

SRCS := $(Testbehch).v
SRCS += $(TopModule).v
SRCS += AdderFL1bit.v

include ../COMMON.mk