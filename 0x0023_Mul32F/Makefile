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
FLGS += -I../0x0004_AdderCS32bit
FLGS += -I../0x0005_Add32
FLGS += -I../0x0012_Sub32U
FLGS += -I../0x0022_MulBT32S

SRCS := $(Testbehch).v
SRCS += $(TopModule).v
SRCS += AdderFL1bit.v
SRCS += AdderLC32bit.v
SRCS += AdderCS32bit.v
SRCS += MulBT32S.v
SRCS += Add32.v
SRCS += Sub32.v
SRCS += Add64.v
SRCS += Shift.v
SRCS += IEEE754.v
SRCS += TC_converter.v

include ../COMMON.mk

.PHONY: c_sim
c_sim:
	@- gcc Mul32F_sim.c -o Mul32F_sim
	@- ./Mul32F_sim
	@- rm Mul32F_sim