# SPDX-FileCopyrightText: 2023 Brian Woods
# SPDX-License-Identifier: GPL-2.0-or-later

# this is for ghdl-gcc, I've not tested it on ghdl-llvm but it will not
# work with ghdl-mcode

SRC=simulation.v top.v counter.v
# top module, we also use this for the object name
TOP=sim_test
# this needs to match what's in top sim file
WAVE_DUMP=simulation.vcd
WAVE_CONF=$(TOP).gtkw
FLAGS=

.PHONY: all clean sim

all: $(TOP)

$(TOP): $(SRC)
	iverilog -o $@ $(FLAGS) -s $@ $^

$(WAVE_DUMP): $(TOP)
	vvp $<

sim: $(WAVE_DUMP)
	gtkwave --save $(WAVE_CONF) --saveonexit $<

clean:
	rm -f $(TOP) $(WAVE_DUMP) $(WAVE_CONF)
