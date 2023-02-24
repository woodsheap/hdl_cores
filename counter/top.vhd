-- SPDX-FileCopyrightText: 2023 Brian Woods
-- SPDX-License-Identifier: GPL-2.0-or-later

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
	port(
		set: in std_logic;
		set_val: in unsigned(7 downto 0);
		cnt: out unsigned(7 downto 0);
		en: in  std_logic;
		cnt_auto: out unsigned(7 downto 0);
		clr: in std_logic;
		clk: in std_logic
	);
end entity;

architecture func of top is
	component counter is
	port(
		set: in std_logic;
		set_val: in unsigned(7 downto 0);
		cnt: out unsigned(7 downto 0);
		en: in  std_logic;
		clr: in std_logic;
		clk: in std_logic
	);
	end component;
begin
	-- controlled by the top signals
	counter01: counter port map(
		set => set,
		set_val => set_val,
		cnt => cnt,
		en => en,
		clr => clr,
		clk => clk
	);

	-- just counts automatically
	counter02: counter port map(
		set => '0',
		set_val => "00000000",
		cnt => cnt_auto,
		en => '1',
		clr => clr,
		clk => clk
	);
end func;
