TopModule := AdderLA32bit
Testbehch := AdderLA32bit_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace

SRCS := $(Testbehch)
SRCS += $(TopModule)
# SRCS += ../AdderFL1bit.v

include ../COMMON.mk