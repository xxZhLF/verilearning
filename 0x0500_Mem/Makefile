TopModule := Mem4K
Testbehch := Mem4K_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --binary
FLGS += --trace
FLGS += -I../0x0001_AdderFL1bit
FLGS += -I../0x0003_AdderLC32bit

ROOT := $(shell pwd)

SRCS := $(ROOT)/$(Testbehch).v
SRCS += $(ROOT)/$(TopModule).v
SRCS += AdderFL1bit.v
SRCS += AdderLC32bit.v

include ../COMMON.mk

# =============================================================================

.SUFFIXES:		# DISABLE Makefile Implicit Rules
.PRECIOUS: %.S	# Keep ASM file otherwise it will be delete automatically

CC := /opt/llvm-riscv/bin/clang
DC := /opt/riscv/bin/riscv32-unknown-elf-objdump

C_PROG := prog

CLFLGs := --sysroot=/opt/riscv/riscv32-unknown-elf
CLFLGs += --gcc-toolchain=/opt/riscv/
CLFLGs += --target=riscv32-unknown-elf 
CLFLGs +=  -march=rv32i
CLFLGs +=  -mabi=ilp32
CLFLGs +=  -fno-builtin
CLFLGs +=  -static
CLFLGs +=  -ffreestanding
CLFLGs +=  -nostdlib
CLFLGs +=  -O0
CLFLGs +=  -g

$(C_PROG).mc: $(C_PROG)
	@ $(DC) $< -d -M no-aliases,numeric | awk 'NR > 7 {print $$2}' > $@

$(C_PROG): $(patsubst %.S, %.o, $(patsubst %.c, %.S, $(wildcard *.c))) 
	@ $(CC) $^ $(CLFLGs) -o $@

%.o: %.S
	@ $(CC) $< $(CLFLGs) -o $@ -c

%.S: %.c
	@ $(CC) $< $(CLFLGs) -o $@ -S 

.PHONY: clear
clear:
	rm *.S *.o *.mc $(C_PROG)