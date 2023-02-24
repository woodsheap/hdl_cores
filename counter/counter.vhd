-- SPDX-FileCopyrightText: 2023 Brian Woods
-- SPDX-License-Identifier: GPL-2.0-or-later

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
	port(
		set: in std_logic;
		set_val: in unsigned(7 downto 0);
		cnt: out unsigned(7 downto 0);
		en: in  std_logic;
		clr: in std_logic;
		clk: in std_logic
	);
end entity;

architecture func of counter is
	signal counter: unsigned(7 downto 0);
begin
	cnt <= counter;

	process (clk, clr)
	begin
		if (clr='1') then
			counter <= "00000000";
		elsif  (clk='1' and clk'event) then
			if (set='1') then
				counter <= set_val;
			elsif (en='1') then
				counter <= counter + 1;
			end if;
		end if;
	end process;
end func;
