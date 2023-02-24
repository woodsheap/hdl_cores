-- SPDX-FileCopyrightText: 2023 Brian Woods
-- SPDX-License-Identifier: GPL-2.0-or-later

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
	port(
		input: in signed(17 downto 0);
		output: out signed(17 downto 0);
		en: in std_logic;
		dr: out std_logic;
		clr: in std_logic;
		clk: in std_logic
	);
end entity;

architecture func of top is
	component averaging_filter is
	generic (
		data_width: integer;
		averaging_amount: integer
	);
	port(
		input: in signed(data_width-1 downto 0);
		output: out signed(data_width-1 downto 0);
		en: in std_logic;
		dr: out std_logic;
		clr: in std_logic;
		clk: in std_logic
	);
	end component;
begin
	-- controlled by the top signals
	filter01: averaging_filter
	generic map(
		data_width => 18,
		averaging_amount => 16
	)
	port map(
		input => input,
		output => output,
		en => en,
		dr => dr,
		clr => clr,
		clk => clk
	);
end func;
