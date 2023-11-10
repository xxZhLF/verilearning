TopModule := Mul32F
Testbehch := Mul32F_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace
FLGS += -I../IPs_shared
FLGS += -I../0x0001_AdderFL1bit
FLGS += -I../0x0003_AdderLC32bit
FLGS += -I../0x0004_AdderSC32bit

SRCS := $(Testbehch).v
SRCS += $(TopModule).v
SRCS += AdderFL1bit.v
SRCS += AdderLC32bit.v
SRCS += AdderSC32bit.v

include ../COMMON.mk

.PHONY: c_sim
c_sim:
	@- gcc Mul32F.c -o Mul32F
	@- ./Mul32F
	@- rm Mul32F