-- SPDX-FileCopyrightText: 2023 Brian Woods
-- SPDX-License-Identifier: GPL-2.0-or-later

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity averaging_filter is
	generic (
		data_width: integer := 16;
		averaging_amount: integer := 32;
		overflow_buffer: integer :=
		    integer(ceil(log2(real(averaging_amount))))
	);
	port(
		data_in: in signed(data_width-1 downto 0);
		data_out: out signed(data_width-1 downto 0);
		en: in std_logic;
		dr: out std_logic;
		clr: in std_logic;
		clk: in std_logic
	);
end entity;

architecture func of averaging_filter is
	type data_array_type is
	    array (0 to averaging_amount-1) of
	    signed(data_width-1 downto 0);
	signal data_array: data_array_type;
	signal running_sum: signed (data_width + overflow_buffer - 1 downto 0);
begin
	process (clk, clr)
	begin
		if (clr='1') then
			data_array <= (others => (others => '0'));
			running_sum <= (others => '0');
			dr <= '0';
		elsif  (clk='1' and clk'event) then
			if (en='1') then
				running_sum <= running_sum -
				    resize(data_array(averaging_amount-1),
				           running_sum'length) +
				    resize(data_in, running_sum'length);
				data_array(1 to averaging_amount-1) <=
				    data_array(0 to averaging_amount-2);
				data_array(0) <= data_in;
			end if;
			dr <= en;
		end if;
	end process;
	data_out <= running_sum(data_width + overflow_buffer - 1
	                      downto overflow_buffer);
end func;
