TopModule := AdderHF1bit
Testbehch := AdderHF1bit_tb

FLAGS := --cc
FLAGS += --top-module $(Testbehch)
FLAGS += --timing
FLAGS += --build
FLAGS += --main
FLAGS += --exe
# FLAGS += --binary

.PHONY: all
all: 
	verilator $(Testbehch).v $(FLAGS) 
#	./obj_dir/V$(TopModule)

.PHONY: clean
clean:
	@ rm -rf obj_dir