BIN  := $(OPutTo)V$(Testbehch)
WAVE := $(TopModule).vcd
SAVE := $(TopModule).gtkw

.PHONY: all
all: 
	verilator $(SRCS) $(FLGS) 

.PHONY: run
run: $(BIN)
	./$(BIN)

.PHONY: show
show: $(WAVE)
ifeq ("$(wildcard $(SAVE))", "")
	gtkwave $(WAVE)
else
	gtkwave $(WAVE) -a $(SAVE)
endif

.PHONY: clean
clean:
	@- rm -rf $(OPutTo)
	@- rm $(TopModule).vcd

$(BIN): 
	make all

$(WAVE): $(BIN)
	make run