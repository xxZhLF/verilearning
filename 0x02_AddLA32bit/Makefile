TopModule := AddLA32bit
Testbehch := AddLA32bit_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace

SRCS := $(Testbehch).v
SRCS += $(TopModule).v
SRCS += Add32.v

include ../COMMON.mk