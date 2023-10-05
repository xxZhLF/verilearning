TopModule := AdderHF1bit
Testbench := AdderHF1bit_tb.cpp

FLAGS := --cc
FLAGS += --top-module $(TopModule)
FLAGS += --exe $(Testbench)
FLAGS += --build

srcs = $(wildcard *.v)

.PHONY: all
all: 
	@ verilator $(srcs) $(FLAGS) 

.PHONY: clean
clean:
	@ rm -rf obj_dir