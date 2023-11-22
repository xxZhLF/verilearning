TopModule := Decoder
Testbehch := Decoder_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace
FLGS += -I../IPs_shared

ROOT := $(shell pwd)

SRCS := $(ROOT)/$(Testbehch).v
SRCS += $(ROOT)/$(TopModule).v

include ../COMMON.mk