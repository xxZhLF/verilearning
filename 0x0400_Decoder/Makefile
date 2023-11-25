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
CLFLGs +=  -g

$(C_PROG).mc: $(C_PROG)
	$(DC) $< -d -M no-aliases,numeric | awk 'NR > 7 {print $$2}' > $@

$(C_PROG): $(patsubst %.S, %.o, $(patsubst %.c, %.S, $(wildcard *.c))) 
	$(CC) $^ $(CLFLGs) -o $@

%.o: %.S
	$(CC) $< $(CLFLGs) -o $@ -c

%.S: %.c
	$(CC) $< $(CLFLGs) -o $@ -S 

.PHONY: clear
clear:
	rm *.S *.o *.mc $(C_PROG)