-- SPDX-FileCopyrightText: 2023 Brian Woods
-- SPDX-License-Identifier: GPL-2.0-or-later

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity fir_filter is
	generic (
		data_width: integer := 16;
		coef_width: integer := 12;
		coef_num: integer := 4;
		coefs: array (0 to coef_num)
		       of signed(coef_width-1 downto 0)
		       := (others => (others => '0'));
		coefs_offset: array (0 to coef_num)
		              of integer
		              := (others => 0);
		overflow_width: integer :=
		                integer(ceil(log2(real(coefs_num))));
		fraction_width: integer := overflow_width + 2
	);
	port(
		input: in signed(data_width-1 downto 0);
		output: out signed(data_width-1 downto 0);
		en: in std_logic;
		ready: out std_logic;
		dr: out std_logic;
		clr: in std_logic;
		clk: in std_logic
	);
end entity;

architecture behav of fir_filter is
	--type data_array_type is
	--    array (0 to averaging_amount-1) of
	--    signed(data_width-1 downto 0);
	--signal data_array: data_array_type;
	--signal running_sum: signed (data_width + overflow_buffer - 1 downto 0);
	signal mul0_sig_in:  signed(data_width-1 downto 0);
	signal mul0_coef_in: signed(coef_width-1 downto 0);
	signal mul0_out:     signed(data_width+coef_width-1 downto 0);
	signal mul0_sel:     integer (range 0 to coef_num);
	signal mul0_en:      std_logic;

	signal acc_sum: signed(data_width+overflow_width+fraction_width-1
	                       downto 0);
	signal acc_in:  signed(data_width+overflow_width+fraction_width-1
	                       downto 0);

	signal data_delay: array (0 to coef_num-1) of
	                   signed (data_width-1 downto 0);

	signal fir_shift: std_logic;

	signal FSM_states is (clear, waiting, processing)
	signal state_cur, state_next: FSM_states;
begin
	-- state machine here
	-- inputs: en,
	-- outputs: mul0_sel, mul0_en
	fsm_logic process (en, clk)
		variable mul0_sel_prev  -- TODO past value so we know
		                        -- what's next
	begin
		-- TODO shift the FIR regs
		case state_cur is
		when clear =>
			state_next <= waiting;
			mul0_sel   <= 0;
			mul0_en    <= '0';
			ready      <= '0';
			fir_shift  <= '0';
		when waiting =>
		when proc_coef =>
			if mul0_sel='1' then
				state_next <= ?;
			else
				state_next <= processing;
			end if;
			mul0_sel   <=  mul0_sel_prev - 1;
			mul0_en    <= '1';
			ready      <= '0';  --TODO confirm
			fir_shift  <= '0';
		when proc_last =>
			if (en='1') then
				state_next <= waiting;
				mul0_sel   <=  0;
				mul0_en    <= '1';
				ready      <= '0';
				fir_shift  <= '1';
			else
				state_next <= proc_last;
				mul0_sel   <=  0;
				mul0_en    <= '0';
				ready      <= '1';
				fir_shift  <= '0';
			end if;
		when others =>
			state_next <= clear;
			mul0_sel   <=  0;
			mul0_en    <= '0';
			ready      <= '0';
			fir_shift  <= '0';
		end case;
	end process fsm_logic;

	fsm_reg: process (clk, clr)
	begin
		if (clr='1') then
			state_cur <= clear;
		elsif (clk'event and clk='1') then
			state_cur <= state_next;
		end if;
	end process fsm_reg;

	-- our one multipler
	-- output will be data_width + coef_width - coefs_offset . coefs_offset
	mul0_out <= mul0_sig_in * mul0_coef_in;

	accumulator: process (clr, clk)
	begin
		if (clr='1') then
			acc_sum => (others => '0');
		elsif (clk'event and clk='1') then
			if (acc_clr='0') then
				acc_sum => (others => '0');
			elsif (acc_en='1') then
				acc_sum <= acc_sum + acc_in;
			end if;
		end if;
	end process;

	-- data_width + coef_width bit from multipler
	-- data_width = N
	-- coef_width = M
	-- coefs_offset = Moff
	--running = L+N.K
	-- overflow_width = L
	-- fraction_width = K
	-- multi out = N + M - Moff . Moff

	process (mul0_sel, mul0_en)
		variable N: integer (range 0 to coef_num);
	begin
		N := mul0_sel;
		if (mul0_en) then
			mul0_sign_in <= signal_delay(N);
			mul0_coef_in <= coefs(N);
			acc_in <= resize(mul0_out(data_width+data_width-1
			                          downto
			                          coefs_offset(N)-fraction_width),
			                 running_sum'length);
			acc_en <= '1';
		else
			mul0_sign_in <= (others => '0');
			mul0_coef_in <= (others => '0');
			acc_in <= (others => '0');
			acc_en <= '0';
		end if;
	end process;

	-- fir_shift here just means increment the saved registers
	data_delay(0) <= input;  -- no delay
	process (clr, clk)
	begin
		if (clr='1') then
			data_delay(1 to coef_num-1)  <= (others (others => '0'));
		elsif (clk'event and clk='1') then
			if (fir_shift='1') then
				data_delay(1 to coef_num-1)
				    <= data_delay(0 to coef_num-2);
			end if;
		end if;
	end process;

end behav;
