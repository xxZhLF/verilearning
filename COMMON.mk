BIN  := $(OPutTo)V$(Testbehch)
WAVE := $(TopModule).vcd

.PHONY: all
all: 
	verilator $(SRCS) $(FLGS) 

.PHONY: run
run: $(BIN)
	./$(BIN)

.PHONY: show
show: $(WAVE)
	gtkwave $(WAVE)

.PHONY: clean
clean:
	@- rm -rf $(OPutTo)
	@- rm $(TopModule).vcd

$(BIN): 
	make all

$(WAVE): $(BIN)
	make run