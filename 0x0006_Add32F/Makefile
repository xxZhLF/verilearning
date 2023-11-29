TopModule := Add32F
Testbehch := Add32F_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace
FLGS += -I../IPs_shared
FLGS += -I../0x0001_AdderFL1bit
FLGS += -I../0x0003_AdderLC32bit
FLGS += -I../0x0005_Add32
FLGS += -I../0x0012_Sub32U

SRCS := $(Testbehch).v
SRCS += $(TopModule).v
SRCS += AdderFL1bit.v
SRCS += AdderLC32bit.v
SRCS += Add32.v
SRCS += Sub32.v
SRCS += IEEE754.v
SRCS += Shift.v
SRCS += Comparator.v
SRCS += TC_converter.v

include ../COMMON.mk

.PHONY: c_sim
c_sim:
	@- gcc Add32F_sim.c -o Add32F_sim
	@- ./Add32F_sim
	@- rm Add32F_sim