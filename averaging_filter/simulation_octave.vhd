-- SPDX-FileCopyrightText: 2023 Brian Woods
-- SPDX-License-Identifier: GPL-2.0-or-later

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity simulation is
end;

architecture sim of simulation is
	component top is
	port(
		input: in signed(17 downto 0);
		output: out signed(17 downto 0);
		en: in std_logic;
		dr: out std_logic;
		clr: in std_logic;
		clk: in std_logic
	);
	end component;

	signal input: signed(17 downto 0) := (others => '0');
	signal output: signed(17 downto 0);
	signal en:  std_logic := '0';
	signal dr:  std_logic := '0';
	signal clr: std_logic := '1';
	signal clk: std_logic := '0';
	signal int_input: integer := 0;
	signal int_output: integer;

begin
	dut: top port map(
		input => input,
		output => output,
		en => en,
		dr => dr,
		clr => clr,
		clk => clk
	);

	clk <= not clk after 5 ns;

	int_output <= to_integer(output);
	--int_output <= 42;
	input <= to_signed(int_input, input'length);

	input_proc: process
		file read_file: text open read_mode is "sim_input.txt";
		variable read_line: line;
		variable read_input: integer;
	begin
		-- at 0 ns
		int_input <= 0;
		en <= '0';
		clr <= '1';
		wait for 10 ns;

		-- at 10 ns
		int_input <= 0;
		en <= '0';
		clr <= '1';
		wait for 10 ns;

		-- at 20 ns
		int_input <= 0;
		en <= '0';
		clr <= '0';
		wait for 10 ns;

		while not endfile(read_file) loop
			readline(read_file, read_line);
			read(read_line, read_input);

			int_input <= read_input;
			en <= '1';
			clr <= '0';
			wait for 10 ns;
		end loop;

		--wait for anything to happen
		int_input <= 0;
		en <= '0';
		clr <= '0';
		wait for 100 ns;

		-- end sim
		wait;
	end process;

	-- for writing output to a file
	output_proc: process(clk, dr)
		file write_file: text open write_mode is "sim_output.txt";
		variable write_line: line;
		variable write_output: integer;
	begin
		if (clk='1' and clk'event) then
			if (dr='1') then
				write_output := int_output;
				write(write_line, write_output);
				writeline(write_file, write_line);
			end if;
		end if;
	end process;
end sim;
