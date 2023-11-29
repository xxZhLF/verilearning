TopModule := Div32U
Testbehch := Div32U_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace
FLGS += -I../IPs_shared
FLGS += -I../0x0001_AdderFL1bit
FLGS += -I../0x0003_AdderLC32bit
FLGS += -I../0x0005_Add32

ROOT := $(shell pwd)

SRCS := $(ROOT)/$(Testbehch).v
SRCS += $(ROOT)/$(TopModule).v
SRCS += AdderFL1bit.v
SRCS += AdderLC32bit.v
SRCS += Add32.v
SRCS += Add64.v
SRCS += Sub64.v
SRCS += Counter.v
SRCS += Comparator.v
SRCS += TC_converter.v

include ../COMMON.mk