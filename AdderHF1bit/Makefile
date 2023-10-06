TopModule := AdderHF1bit
Testbehch := AdderHF1bit_tb

FLGS := --cc
FLGS += --top-module $(Testbehch)
FLGS += --timing
FLGS += --build
FLGS += --main
FLGS += --exe
# FLAGS += --binary

srcs := $(wildcard *.v)

.PHONY: all
all: 
	verilator $(Testbehch).v $(FLGS) 
#	./obj_dir/V$(TopModule)

.PHONY: clean
clean:
	@ rm -rf obj_dir