TopModule := ALU32FF
Testbehch := ALU32FF_tb

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
FLGS += -I../0x0031_Div32U

SRCS := $(Testbehch).v
SRCS += $(TopModule).v
SRCS += AdderFL1bit.v
SRCS += AdderLC32bit.v
SRCS += AdderCS32bit.v
SRCS += Add32.v
SRCS += Sub32.v
SRCS += Add64.v
SRCS += Sub64.v
SRCS += MulBT32S.v
SRCS += Div32U.v
SRCS += Shift.v
SRCS += Comparator.v
SRCS += TC_converter.v

include ../COMMON.mk