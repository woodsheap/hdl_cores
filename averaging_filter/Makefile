# SPDX-FileCopyrightText: 2023 Brian Woods
# SPDX-License-Identifier: GPL-2.0-or-later

# this is for ghdl-gcc, I've not tested it on ghdl-llvm but it will not
# work with ghdl-mcode

SRC=simulation.vhd top.vhd averaging_filter.vhd
OBJ=$(SRC:.vhd=.o)
TOP=simulation
TOP_OBJ=e~$(TOP).o
WAVE_DUMP=$(TOP).ghw
WAVE_CONF=$(TOP).gtkw
WORKLIB=work
FLAGS=--std=08 --work=$(WORKLIB)
TIME=1us

.PHONY: all clean sim

all: $(TOP)

%.o: %.vhd
	ghdl -a $(FLAGS) $<

$(TOP): $(OBJ)
	ghdl -e $(FLAGS) $@

$(WAVE_DUMP): $(TOP)
	ghdl -r $(FLAGS) $< --wave=$@ --stop-time=$(TIME)

sim: $(WAVE_DUMP)
	gtkwave --save $(WAVE_CONF) --saveonexit $<

clean:
	rm -f $(OBJ) $(TOP_OBJ) $(TOP) $(WAVE_DUMP) $(WAVE_CONF) $(WORKLIB)-obj*.cf
