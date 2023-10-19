TopModule := MulBT32S
Testbehch := MulBT32S_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace
FLGS += -I../0x0004_AdderCS32bit
FLGS += -I../0x0020_Mul32U

ROOT := $(shell pwd)

SRCS := $(ROOT)/$(Testbehch).v
SRCS += $(ROOT)/$(TopModule).v
SRCS += AdderCS32bit.v

include ../COMMON.mk