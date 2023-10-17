TopModule := Mul32U
Testbehch := Mul32U_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace
FLGS += -I../0x0003_AdderLC32bit
FLGS += -I../0x0005_Add32
FLGS += -I../0x0020_Mul32U

ROOT := $(shell pwd)

SRCS := $(ROOT)/$(Testbehch).v
SRCS += $(ROOT)/$(TopModule).v
SRCS += AdderLC32bit.v

include ../COMMON.mk