TopModule := AdderFL1bit
Testbehch := AdderFL1bit_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace

SRCS := $(Testbehch).v
SRCS += $(TopModule).v

include ../COMMON.mk