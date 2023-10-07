include AdderHF1bit.mk

.PHONY: all
all: 
	verilator $(SRCS) $(FLGS) 

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