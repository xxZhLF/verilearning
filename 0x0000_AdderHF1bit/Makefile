TopModule := AdderHF1bit
Testbehch := AdderHF1bit_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --timing
FLGS += --build
FLGS += --main
FLGS += --exe
# FLAGS += --binary
FLGS += --trace

SRCS := $(Testbehch).v
SRCS += $(TopModule).v

include ../COMMON.mk