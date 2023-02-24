# SPDX-FileCopyrightText: 2023 Brian Woods
# SPDX-License-Identifier: GPL-2.0-or-later

# this is for ghdl-gcc, I've not tested it on ghdl-llvm but it will not
# work with ghdl-mcode

SRC=simulation.vhd top.vhd counter.vhd
OBJ=$(SRC:.vhd=.o)
TOP=simulation
TOP_OBJ=e~$(TOP).o
WAVE=simulation.ghw
WORKLIB=work
FLAGS=--std=08 --work=$(WORKLIB)
TIME=1us

.PHONY: all clean sim

all: $(TOP)

%.o: %.vhd
	ghdl -a $(FLAGS) $<

$(TOP): $(OBJ)
	ghdl -e $(FLAGS) $@

$(WAVE): $(TOP)
	ghdl -r $(FLAGS) $< --wave=$@ --stop-time=$(TIME)

sim: $(WAVE)
	 gtkwave $<

clean:
	rm -f $(OBJ) $(TOP_OBJ) $(TOP) $(WAVE) $(WORKLIB)-obj*.cf
