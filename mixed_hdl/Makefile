# SPDX-FileCopyrightText: 2023 Brian Woods
# SPDX-License-Identifier: GPL-2.0-or-later

# this is for ghdl-gcc or ghdl-llvm but it will not work with ghdl-mcode

VERI_SRC=simulation.v top.v counter.v averaging_filter_cfg.v
VHDL_SRC=averaging_filter.vhd averaging_filter_cfg.vhd
# These are the top level of modules to import to verilog
VHDL_MTOP=averaging_filter_cfg

# top module, we also use this for the object name
TOP=simulation
# this needs to match what's in top sim file
WAVE_DUMP=simulation.vcd

VHDL_OBJ=$(VHDL_SRC:.vhd=.o)
VHDL_MTOP_VERI=$(addsuffix .v, $(VHDL_MTOP))
SRC=$(VERI_SRC) $(VHDL_MTOP_VERI)
WAVE_CONF=$(TOP).gtkw
VERI_FLAGS=
VHDL_WORKLIB=work
VHDL_FLAGS=--std=08 --work=$(VHDL_WORKLIB)

.PHONY: all clean sim

all: $(TOP)

$(VHDL_MTOP_VERI): %.v: $(VHDL_OBJ)
	ghdl synth $(VHDL_FLAGS) --out=verilog $($@:.v=) > $@

$(VHDL_OBJ): %.o: %.vhd
	ghdl analyze $(VHDL_FLAGS) $<

$(TOP): $(SRC)
	iverilog -o $@ $(FLAGS) -s $@ $^

$(WAVE_DUMP): $(TOP)
	vvp $<

sim: $(WAVE_DUMP)
	gtkwave --save $(WAVE_CONF) --saveonexit $<

clean:
	rm -f $(TOP) $(VHDL_OBJ) $(VHDL_MTOP_VERI) $(VHDL_WORKLIB)-obj08.cf $(WAVE_DUMP) $(WAVE_CONF)
