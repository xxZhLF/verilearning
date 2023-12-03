TopModule := MicroarchSC
Testbehch := MicroarchSC_tb

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
FLGS += -I../0x0101_ALU32FF
FLGS += -I../0x0200_REGs3P
FLGS += -I../0x0300_PC
FLGS += -I../0x0500_Mem

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
SRCS += ALU32FF.v
SRCS += REGs3P.v
SRCS += PC.v
SRCS += Mem4K.v

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