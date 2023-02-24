-- SPDX-FileCopyrightText: 2023 Brian Woods
-- SPDX-License-Identifier: GPL-2.0-or-later

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity simulation is
end;

architecture sim of simulation is
	component top is
	port(
		set: in std_logic;
		set_val: in unsigned(7 downto 0);
		cnt: out unsigned(7 downto 0);
		en: in  std_logic;
		clr: in std_logic;
		cnt_auto: out unsigned(7 downto 0);
		clk: in std_logic
	);
	end component;

	signal set: std_logic := '0';
	signal set_val: unsigned(7 downto 0) := "00000000";
	signal cnt: unsigned(7 downto 0);
	signal en:  std_logic := '0';
	signal clr: std_logic := '0';
	signal cnt_auto: unsigned(7 downto 0);
	signal clk: std_logic := '0';
begin
	dut: top port map(
		set => set,
		set_val => set_val,
		cnt => cnt,
		en => en,
		clr => clr,
		cnt_auto => cnt_auto,
		clk => clk
	);

	clk <= not clk after 5 ns;
	-- clr <= '1', '0' after 20 ns;
	-- en  <= '0', '1' after 10 ns;

	-- clk_proc: process begin
	-- begin
	-- end process clk_proc;

	process begin
		-- at 0 ns
		set <= '0';
		set_val <= "00000000";
		en <= '0';
		clr <= '1';
		wait for 10 ns;

		-- at 10 ns
		set <= '0';
		set_val <= "00000000";
		en <= '1';
		clr <= '1';
		wait for 10 ns;

		-- at 20 ns
		set <= '0';
		set_val <= "00000000";
		en <= '1';
		clr <= '0';
		wait for 80 ns;

		-- at 100 ns
		set <= '1';
		set_val <= "00100000";
		en <= '1';
		clr <= '0';
		wait for 10 ns;

		-- at 110 ns
		set <= '0';
		set_val <= "00000000";
		en <= '1';
		clr <= '0';
		wait for 100 ns;

		-- at 210 ns
		set <= '0';
		set_val <= "00000000";
		en <= '0';
		clr <= '0';
		wait for 10 ns;

		-- end sim
		wait;
	end process;

end sim;
