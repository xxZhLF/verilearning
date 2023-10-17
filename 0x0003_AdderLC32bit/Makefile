TopModule := AdderLC32bit
Testbehch := AdderLC32bit_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace

SRCS := $(Testbehch).v
SRCS += $(TopModule).v

include ../COMMON.mk