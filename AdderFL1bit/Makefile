TopModule := AdderFL1bit
Testbehch := AdderFL1bit_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace

SRCS := $(Testbehch)
SRCS += $(TopModule)

include ../COMMON.mk