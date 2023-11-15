TopModule := Div32F
Testbehch := Div32F_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace
FLGS += -j 8
FLGS += -I../IPs_shared
FLGS += -I../0x0001_AdderFL1bit
FLGS += -I../0x0003_AdderLC32bit
FLGS += -I../0x0004_AdderCS32bit
FLGS += -I../0x0005_Add32
FLGS += -I../0x0012_Sub32U

SRCS := $(Testbehch).v
SRCS += $(TopModule).v
SRCS += AdderFL1bit.v
SRCS += AdderLC32bit.v
SRCS += AdderCS32bit.v
SRCS += Add32.v
SRCS += Add64.v
SRCS += Sub32.v

include ../COMMON.mk

.PHONY: c_sim
c_sim:
	@- gcc Div32F_sim.c -o Div32F_sim
	@- ./Div32F_sim
	@- rm Div32F_sim