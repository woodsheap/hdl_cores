-- SPDX-FileCopyrightText: 2023 Brian Woods
-- SPDX-License-Identifier: GPL-2.0-or-later

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity simulation is
end;

-- TODO: change this for the FIR
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
	signal clr: std_logic := '0';
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

	process begin
		-- at 0 ns
		int_input <= 100000;
		en <= '0';
		clr <= '1';
		wait for 10 ns;

		-- at 10 ns
		int_input <= 100000;
		en <= '0';
		clr <= '1';
		wait for 10 ns;

		-- at 20 ns
		int_input <= 100000;
		en <= '0';
		clr <= '0';
		wait for 10 ns;

		-- at 30 ns
		int_input <= 100000;
		en <= '1';
		clr <= '0';
		wait for 70 ns;

		-- at 100 ns
		int_input <= 100000;
		en <= '1';
		clr <= '0';
		wait for 300 ns;

		-- at 400 ns
		int_input <= 100000;
		en <= '0';
		clr <= '0';
		wait for 10 ns;

		-- end sim
		wait;
	end process;

end sim;
