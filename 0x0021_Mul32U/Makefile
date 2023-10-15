TopModule := Mul32U
Testbehch := Mul32U_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace
FLGS += -I../0x0003_AdderLA32bit
FLGS += -I../0x0020_Mul32U

ROOT := $(shell pwd)

SRCS := $(ROOT)/$(Testbehch).v
SRCS += $(ROOT)/$(TopModule).v
SRCS += AdderLA32bit.v
# SRCS += Add64.v

include ../COMMON.mk