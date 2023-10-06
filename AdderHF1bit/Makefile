TopModule := AdderHF1bit
Testbehch := AdderHF1bit_tb

OPutTo := obj_dir/

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --timing
FLGS += --build
FLGS += --main
FLGS += --exe
# FLAGS += --binary
FLGS += --trace

srcs := $(wildcard *.v)

.PHONY: all
all: 
	verilator $(Testbehch).v $(FLGS) 

.PHONY: run
run: 
	./$(OPutTo)V$(Testbehch)

.PHONY: show
show:
	gtkwave $(TopModule).vcd

.PHONY: clean
clean:
	@- rm -rf $(OPutTo)
	@- rm $(TopModule).vcd