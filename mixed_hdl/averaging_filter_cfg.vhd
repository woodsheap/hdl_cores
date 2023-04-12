-- SPDX-FileCopyrightText: 2023 Brian Woods
-- SPDX-License-Identifier: GPL-2.0-or-later

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity averaging_filter_cfg is
	port(
		data_in: in signed(7 downto 0);
		data_out: out signed(7 downto 0);
		en: in std_logic;
		dr: out std_logic;
		clr: in std_logic;
		clk: in std_logic
	);
end entity;

architecture func of averaging_filter_cfg is
	component averaging_filter is
	generic (
		data_width: integer;
		averaging_amount: integer
	);
	port(
		data_in: in signed(data_width-1 downto 0);
		data_out: out signed(data_width-1 downto 0);
		en: in std_logic;
		dr: out std_logic;
		clr: in std_logic;
		clk: in std_logic
	);
	end component;
begin
	filter_cfg: averaging_filter
	generic map(
		data_width => 8,
		averaging_amount => 4
	)
	port map(
		data_in => data_in,
		data_out => data_out,
		en => en,
		dr => dr,
		clr => clr,
		clk => clk
	);
end func;
