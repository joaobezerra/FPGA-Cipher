LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity PermDif is
port(
	reset, clock, start, activate, done: in std_logic;
	block_in_input, diff_value_input, prev_input: in unsigned(127 downto 0);
	perm_value_input: in unsigned(3 downto 0);
	block_ciphered: out std_logic;
	block_out_output: out unsigned(127 downto 0)
	);
end entity;

architecture arq_PermDif of PermDif is

TYPE STATE_TYPE is (reset_state, load_state, state0, state1);
SIGNAL current_state, next_state: STATE_TYPE;

SIGNAL block_in, diff_value, prev, block_out: unsigned(127 downto 0);
SIGNAL perm_val: unsigned(3 downto 0);

SIGNAL sig_block_ciphered: std_logic;

begin

--Logica de estado atual
process(clock, reset, done)

begin

	if reset = '1' then
		current_state <= reset_state;
	elsif rising_edge(clock) then
		if done = '1' then
			current_state <= reset_state;
		else
			current_state <= next_state;
		end if;
	end if;
	
end process;

--Logica de proximo estado
--Ver se a logica da leitura ta boa e funcional
process(clock, reset, activate, current_state, start)
	
	begin
	
	case current_state is
		
		when reset_state =>
			next_state <= load_state;
			
		when load_state =>
			if start = '1' then
				next_state <= state0;
			else
				next_state <= load_state;
			end if;
		
		when state0 =>
			next_state <= state1;
		
		when state1 =>
			
			if activate = '1' then
				next_state <= load_state;
			else
				next_state <= state1;
			end if;
		
	end case;

end process;

--Processo do flag block_ciphered
process(clock, reset, current_state)
	
	begin
	
	if reset = '1' then
		sig_block_ciphered <= '0';
	
	elsif rising_edge(clock) then
		
		if current_state = state0 then
			sig_block_ciphered <= '1';
		else
			sig_block_ciphered <= '0';
		end if;
		
	end if;
	
end process;

block_ciphered <= sig_block_ciphered;

--Process de leitura das entradas
process(clock, reset, current_state)
	
	begin
	
	if reset = '1' then
	
		block_in <= (others => '0');
		diff_value <= (others => '0');
		prev <= (others => '0');
		perm_val <= (others => '0');
	
	elsif rising_edge(clock) and current_state = load_state then
		
		block_in <= block_in_input;
		diff_value <= diff_value_input;
		prev <= prev_input;
		perm_val <= perm_value_input;
		
	end if;
	
end process;

--Process de calculo da saida
process(reset, current_state, clock)
	
	begin
	
	if reset = '1' then
		block_out <= (others => '0');
	
	--else
	elsif rising_edge(clock) and current_state = state0 then

		case perm_val is
				
					when "0000" =>
						
						block_out(7 downto 0) <= block_in(7 downto 0) xor diff_value(7 downto 0) xor prev(7 downto 0);
						block_out(15 downto 8) <= block_in(15 downto 8) xor diff_value(15 downto 8) xor prev(15 downto 8);
						block_out(23 downto 16) <= block_in(23 downto 16) xor diff_value(23 downto 16) xor prev(23 downto 16);
						block_out(31 downto 24) <= block_in(31 downto 24) xor diff_value(31 downto 24) xor prev(31 downto 24);
						block_out(39 downto 32) <= block_in(39 downto 32) xor diff_value(39 downto 32) xor prev(39 downto 32);
						block_out(47 downto 40) <= block_in(47 downto 40) xor diff_value(47 downto 40) xor prev(47 downto 40);
						block_out(55 downto 48) <= block_in(55 downto 48) xor diff_value(55 downto 48) xor prev(55 downto 48);
						block_out(63 downto 56) <= block_in(63 downto 56) xor diff_value(63 downto 56) xor prev(63 downto 56);
						block_out(71 downto 64) <= block_in(71 downto 64) xor diff_value(71 downto 64) xor prev(71 downto 64);
						block_out(79 downto 72) <= block_in(79 downto 72) xor diff_value(79 downto 72) xor prev(79 downto 72);
						block_out(87 downto 80) <= block_in(87 downto 80) xor diff_value(87 downto 80) xor prev(87 downto 80);
						block_out(95 downto 88) <= block_in(95 downto 88) xor diff_value(95 downto 88) xor prev(95 downto 88);
						block_out(103 downto 96) <= block_in(103 downto 96) xor diff_value(103 downto 96) xor prev(103 downto 96);
						block_out(111 downto 104) <= block_in(111 downto 104) xor diff_value(111 downto 104) xor prev(111 downto 104);
						block_out(119 downto 112) <= block_in(119 downto 112) xor diff_value(119 downto 112) xor prev(119 downto 112);
						block_out(127 downto 120) <= block_in(127 downto 120) xor diff_value(127 downto 120) xor prev(127 downto 120);
				
					when "0001" =>
						
						block_out(7 downto 0) <= block_in(127 downto 120) xor diff_value(7 downto 0) xor prev(7 downto 0);
						block_out(15 downto 8) <= block_in(7 downto 0) xor diff_value(15 downto 8) xor prev(15 downto 8);
						block_out(23 downto 16) <= block_in(15 downto 8) xor diff_value(23 downto 16) xor prev(23 downto 16);
						block_out(31 downto 24) <= block_in(23 downto 16) xor diff_value(31 downto 24) xor prev(31 downto 24);
						block_out(39 downto 32) <= block_in(31 downto 24) xor diff_value(39 downto 32) xor prev(39 downto 32);
						block_out(47 downto 40) <= block_in(39 downto 32) xor diff_value(47 downto 40) xor prev(47 downto 40);
						block_out(55 downto 48) <= block_in(47 downto 40) xor diff_value(55 downto 48) xor prev(55 downto 48);
						block_out(63 downto 56) <= block_in(55 downto 48) xor diff_value(63 downto 56) xor prev(63 downto 56);
						block_out(71 downto 64) <= block_in(63 downto 56) xor diff_value(71 downto 64) xor prev(71 downto 64);
						block_out(79 downto 72) <= block_in(71 downto 64) xor diff_value(79 downto 72) xor prev(79 downto 72);
						block_out(87 downto 80) <= block_in(79 downto 72) xor diff_value(87 downto 80) xor prev(87 downto 80);
						block_out(95 downto 88) <= block_in(87 downto 80) xor diff_value(95 downto 88) xor prev(95 downto 88);
						block_out(103 downto 96) <= block_in(95 downto 88) xor diff_value(103 downto 96) xor prev(103 downto 96);
						block_out(111 downto 104) <= block_in(103 downto 96) xor diff_value(111 downto 104) xor prev(111 downto 104);
						block_out(119 downto 112) <= block_in(111 downto 104) xor diff_value(119 downto 112) xor prev(119 downto 112);
						block_out(127 downto 120) <= block_in(119 downto 112) xor diff_value(127 downto 120) xor prev(127 downto 120);
						
					when "0010" =>
						
						block_out(7 downto 0) <= block_in(119 downto 112) xor diff_value(7 downto 0) xor prev(7 downto 0);
						block_out(15 downto 8) <= block_in(127 downto 120) xor diff_value(15 downto 8) xor prev(15 downto 8);
						block_out(23 downto 16) <= block_in(7 downto 0) xor diff_value(23 downto 16) xor prev(23 downto 16);
						block_out(31 downto 24) <= block_in(15 downto 8) xor diff_value(31 downto 24) xor prev(31 downto 24);
						block_out(39 downto 32) <= block_in(23 downto 16) xor diff_value(39 downto 32) xor prev(39 downto 32);
						block_out(47 downto 40) <= block_in(31 downto 24) xor diff_value(47 downto 40) xor prev(47 downto 40);
						block_out(55 downto 48) <= block_in(39 downto 32) xor diff_value(55 downto 48) xor prev(55 downto 48);
						block_out(63 downto 56) <= block_in(47 downto 40) xor diff_value(63 downto 56) xor prev(63 downto 56);
						block_out(71 downto 64) <= block_in(55 downto 48) xor diff_value(71 downto 64) xor prev(71 downto 64);
						block_out(79 downto 72) <= block_in(63 downto 56) xor diff_value(79 downto 72) xor prev(79 downto 72);
						block_out(87 downto 80) <= block_in(71 downto 64) xor diff_value(87 downto 80) xor prev(87 downto 80);
						block_out(95 downto 88) <= block_in(79 downto 72) xor diff_value(95 downto 88) xor prev(95 downto 88);
						block_out(103 downto 96) <= block_in(87 downto 80) xor diff_value(103 downto 96) xor prev(103 downto 96);
						block_out(111 downto 104) <= block_in(95 downto 88) xor diff_value(111 downto 104) xor prev(111 downto 104);
						block_out(119 downto 112) <= block_in(103 downto 96) xor diff_value(119 downto 112) xor prev(119 downto 112);
						block_out(127 downto 120) <= block_in(111 downto 104) xor diff_value(127 downto 120) xor prev(127 downto 120);
					
					when "0011" =>
						
						block_out(7 downto 0) <= block_in(111 downto 104) xor diff_value(7 downto 0) xor prev(7 downto 0);
						block_out(15 downto 8) <= block_in(119 downto 112) xor diff_value(15 downto 8) xor prev(15 downto 8);
						block_out(23 downto 16) <= block_in(127 downto 120) xor diff_value(23 downto 16) xor prev(23 downto 16);
						block_out(31 downto 24) <= block_in(7 downto 0) xor diff_value(31 downto 24) xor prev(31 downto 24);
						block_out(39 downto 32) <= block_in(15 downto 8) xor diff_value(39 downto 32) xor prev(39 downto 32);
						block_out(47 downto 40) <= block_in(23 downto 16) xor diff_value(47 downto 40) xor prev(47 downto 40);
						block_out(55 downto 48) <= block_in(31 downto 24) xor diff_value(55 downto 48) xor prev(55 downto 48);
						block_out(63 downto 56) <= block_in(39 downto 32) xor diff_value(63 downto 56) xor prev(63 downto 56);
						block_out(71 downto 64) <= block_in(47 downto 40) xor diff_value(71 downto 64) xor prev(71 downto 64);
						block_out(79 downto 72) <= block_in(55 downto 48) xor diff_value(79 downto 72) xor prev(79 downto 72);
						block_out(87 downto 80) <= block_in(63 downto 56) xor diff_value(87 downto 80) xor prev(87 downto 80);
						block_out(95 downto 88) <= block_in(71 downto 64) xor diff_value(95 downto 88) xor prev(95 downto 88);
						block_out(103 downto 96) <= block_in(79 downto 72) xor diff_value(103 downto 96) xor prev(103 downto 96);
						block_out(111 downto 104) <= block_in(87 downto 80) xor diff_value(111 downto 104) xor prev(111 downto 104);
						block_out(119 downto 112) <= block_in(95 downto 88) xor diff_value(119 downto 112) xor prev(119 downto 112);
						block_out(127 downto 120) <= block_in(103 downto 96) xor diff_value(127 downto 120) xor prev(127 downto 120);
					
					when "0100" => 
						
						block_out(7 downto 0) <= block_in(103 downto 96) xor diff_value(7 downto 0) xor prev(7 downto 0);
						block_out(15 downto 8) <= block_in(111 downto 104) xor diff_value(15 downto 8) xor prev(15 downto 8);
						block_out(23 downto 16) <= block_in(119 downto 112) xor diff_value(23 downto 16) xor prev(23 downto 16);
						block_out(31 downto 24) <= block_in(127 downto 120) xor diff_value(31 downto 24) xor prev(31 downto 24);
						block_out(39 downto 32) <= block_in(7 downto 0) xor diff_value(39 downto 32) xor prev(39 downto 32);
						block_out(47 downto 40) <= block_in(15 downto 8) xor diff_value(47 downto 40) xor prev(47 downto 40);
						block_out(55 downto 48) <= block_in(23 downto 16) xor diff_value(55 downto 48) xor prev(55 downto 48);
						block_out(63 downto 56) <= block_in(31 downto 24) xor diff_value(63 downto 56) xor prev(63 downto 56);
						block_out(71 downto 64) <= block_in(39 downto 32) xor diff_value(71 downto 64) xor prev(71 downto 64);
						block_out(79 downto 72) <= block_in(47 downto 40) xor diff_value(79 downto 72) xor prev(79 downto 72);
						block_out(87 downto 80) <= block_in(55 downto 48) xor diff_value(87 downto 80) xor prev(87 downto 80);
						block_out(95 downto 88) <= block_in(63 downto 56) xor diff_value(95 downto 88) xor prev(95 downto 88);
						block_out(103 downto 96) <= block_in(71 downto 64) xor diff_value(103 downto 96) xor prev(103 downto 96);
						block_out(111 downto 104) <= block_in(79 downto 72) xor diff_value(111 downto 104) xor prev(111 downto 104);
						block_out(119 downto 112) <= block_in(87 downto 80) xor diff_value(119 downto 112) xor prev(119 downto 112);
						block_out(127 downto 120) <= block_in(95 downto 88) xor diff_value(127 downto 120) xor prev(127 downto 120);
					
					when "0101" =>
						
						block_out(7 downto 0) <= block_in(95 downto 88) xor diff_value(7 downto 0) xor prev(7 downto 0);
						block_out(15 downto 8) <= block_in(103 downto 96) xor diff_value(15 downto 8) xor prev(15 downto 8);
						block_out(23 downto 16) <= block_in(111 downto 104) xor diff_value(23 downto 16) xor prev(23 downto 16);
						block_out(31 downto 24) <= block_in(119 downto 112) xor diff_value(31 downto 24) xor prev(31 downto 24);
						block_out(39 downto 32) <= block_in(127 downto 120) xor diff_value(39 downto 32) xor prev(39 downto 32);
						block_out(47 downto 40) <= block_in(7 downto 0) xor diff_value(47 downto 40) xor prev(47 downto 40);
						block_out(55 downto 48) <= block_in(15 downto 8) xor diff_value(55 downto 48) xor prev(55 downto 48);
						block_out(63 downto 56) <= block_in(23 downto 16) xor diff_value(63 downto 56) xor prev(63 downto 56);
						block_out(71 downto 64) <= block_in(31 downto 24) xor diff_value(71 downto 64) xor prev(71 downto 64);
						block_out(79 downto 72) <= block_in(39 downto 32) xor diff_value(79 downto 72) xor prev(79 downto 72);
						block_out(87 downto 80) <= block_in(47 downto 40) xor diff_value(87 downto 80) xor prev(87 downto 80);
						block_out(95 downto 88) <= block_in(55 downto 48) xor diff_value(95 downto 88) xor prev(95 downto 88);
						block_out(103 downto 96) <= block_in(63 downto 56) xor diff_value(103 downto 96) xor prev(103 downto 96);
						block_out(111 downto 104) <= block_in(71 downto 64) xor diff_value(111 downto 104) xor prev(111 downto 104);
						block_out(119 downto 112) <= block_in(79 downto 72) xor diff_value(119 downto 112) xor prev(119 downto 112);
						block_out(127 downto 120) <= block_in(87 downto 80) xor diff_value(127 downto 120) xor prev(127 downto 120);
					
					when "0110" =>
						
						block_out(7 downto 0) <= block_in(87 downto 80) xor diff_value(7 downto 0) xor prev(7 downto 0);
						block_out(15 downto 8) <= block_in(95 downto 88) xor diff_value(15 downto 8) xor prev(15 downto 8);
						block_out(23 downto 16) <= block_in(103 downto 96) xor diff_value(23 downto 16) xor prev(23 downto 16);
						block_out(31 downto 24) <= block_in(111 downto 104) xor diff_value(31 downto 24) xor prev(31 downto 24);
						block_out(39 downto 32) <= block_in(119 downto 112) xor diff_value(39 downto 32) xor prev(39 downto 32);
						block_out(47 downto 40) <= block_in(127 downto 120) xor diff_value(47 downto 40) xor prev(47 downto 40);
						block_out(55 downto 48) <= block_in(7 downto 0) xor diff_value(55 downto 48) xor prev(55 downto 48);
						block_out(63 downto 56) <= block_in(15 downto 8) xor diff_value(63 downto 56) xor prev(63 downto 56);
						block_out(71 downto 64) <= block_in(23 downto 16) xor diff_value(71 downto 64) xor prev(71 downto 64);
						block_out(79 downto 72) <= block_in(31 downto 24) xor diff_value(79 downto 72) xor prev(79 downto 72);
						block_out(87 downto 80) <= block_in(39 downto 32) xor diff_value(87 downto 80) xor prev(87 downto 80);
						block_out(95 downto 88) <= block_in(47 downto 40) xor diff_value(95 downto 88) xor prev(95 downto 88);
						block_out(103 downto 96) <= block_in(55 downto 48) xor diff_value(103 downto 96) xor prev(103 downto 96);
						block_out(111 downto 104) <= block_in(63 downto 56) xor diff_value(111 downto 104) xor prev(111 downto 104);
						block_out(119 downto 112) <= block_in(71 downto 64) xor diff_value(119 downto 112) xor prev(119 downto 112);
						block_out(127 downto 120) <= block_in(79 downto 72) xor diff_value(127 downto 120) xor prev(127 downto 120);
					
					when "0111" =>
						
						block_out(7 downto 0) <= block_in(79 downto 72) xor diff_value(7 downto 0) xor prev(7 downto 0);
						block_out(15 downto 8) <= block_in(87 downto 80) xor diff_value(15 downto 8) xor prev(15 downto 8);
						block_out(23 downto 16) <= block_in(95 downto 88) xor diff_value(23 downto 16) xor prev(23 downto 16);
						block_out(31 downto 24) <= block_in(103 downto 96) xor diff_value(31 downto 24) xor prev(31 downto 24);
						block_out(39 downto 32) <= block_in(111 downto 104) xor diff_value(39 downto 32) xor prev(39 downto 32);
						block_out(47 downto 40) <= block_in(119 downto 112) xor diff_value(47 downto 40) xor prev(47 downto 40);
						block_out(55 downto 48) <= block_in(127 downto 120) xor diff_value(55 downto 48) xor prev(55 downto 48);
						block_out(63 downto 56) <= block_in(7 downto 0) xor diff_value(63 downto 56) xor prev(63 downto 56);
						block_out(71 downto 64) <= block_in(15 downto 8) xor diff_value(71 downto 64) xor prev(71 downto 64);
						block_out(79 downto 72) <= block_in(23 downto 16) xor diff_value(79 downto 72) xor prev(79 downto 72);
						block_out(87 downto 80) <= block_in(31 downto 24) xor diff_value(87 downto 80) xor prev(87 downto 80);
						block_out(95 downto 88) <= block_in(39 downto 32) xor diff_value(95 downto 88) xor prev(95 downto 88);
						block_out(103 downto 96) <= block_in(47 downto 40) xor diff_value(103 downto 96) xor prev(103 downto 96);
						block_out(111 downto 104) <= block_in(55 downto 48) xor diff_value(111 downto 104) xor prev(111 downto 104);
						block_out(119 downto 112) <= block_in(63 downto 56) xor diff_value(119 downto 112) xor prev(119 downto 112);
						block_out(127 downto 120) <= block_in(71 downto 64) xor diff_value(127 downto 120) xor prev(127 downto 120);
					
					when "1000" =>
						
						block_out(7 downto 0) <= block_in(71 downto 64) xor diff_value(7 downto 0) xor prev(7 downto 0);
						block_out(15 downto 8) <= block_in(79 downto 72) xor diff_value(15 downto 8) xor prev(15 downto 8);
						block_out(23 downto 16) <= block_in(87 downto 80) xor diff_value(23 downto 16) xor prev(23 downto 16);
						block_out(31 downto 24) <= block_in(95 downto 88) xor diff_value(31 downto 24) xor prev(31 downto 24);
						block_out(39 downto 32) <= block_in(103 downto 96) xor diff_value(39 downto 32) xor prev(39 downto 32);
						block_out(47 downto 40) <= block_in(111 downto 104) xor diff_value(47 downto 40) xor prev(47 downto 40);
						block_out(55 downto 48) <= block_in(119 downto 112) xor diff_value(55 downto 48) xor prev(55 downto 48);
						block_out(63 downto 56) <= block_in(127 downto 120) xor diff_value(63 downto 56) xor prev(63 downto 56);
						block_out(71 downto 64) <= block_in(7 downto 0) xor diff_value(71 downto 64) xor prev(71 downto 64);
						block_out(79 downto 72) <= block_in(15 downto 8) xor diff_value(79 downto 72) xor prev(79 downto 72);
						block_out(87 downto 80) <= block_in(23 downto 16) xor diff_value(87 downto 80) xor prev(87 downto 80);
						block_out(95 downto 88) <= block_in(31 downto 24) xor diff_value(95 downto 88) xor prev(95 downto 88);
						block_out(103 downto 96) <= block_in(39 downto 32) xor diff_value(103 downto 96) xor prev(103 downto 96);
						block_out(111 downto 104) <= block_in(47 downto 40) xor diff_value(111 downto 104) xor prev(111 downto 104);
						block_out(119 downto 112) <= block_in(55 downto 48) xor diff_value(119 downto 112) xor prev(119 downto 112);
						block_out(127 downto 120) <= block_in(63 downto 56) xor diff_value(127 downto 120) xor prev(127 downto 120);
					
					when "1001" =>
						
						block_out(7 downto 0) <= block_in(63 downto 56) xor diff_value(7 downto 0) xor prev(7 downto 0);
						block_out(15 downto 8) <= block_in(71 downto 64) xor diff_value(15 downto 8) xor prev(15 downto 8);
						block_out(23 downto 16) <= block_in(79 downto 72) xor diff_value(23 downto 16) xor prev(23 downto 16);
						block_out(31 downto 24) <= block_in(87 downto 80) xor diff_value(31 downto 24) xor prev(31 downto 24);
						block_out(39 downto 32) <= block_in(95 downto 88) xor diff_value(39 downto 32) xor prev(39 downto 32);
						block_out(47 downto 40) <= block_in(103 downto 96) xor diff_value(47 downto 40) xor prev(47 downto 40);
						block_out(55 downto 48) <= block_in(111 downto 104) xor diff_value(55 downto 48) xor prev(55 downto 48);
						block_out(63 downto 56) <= block_in(119 downto 112) xor diff_value(63 downto 56) xor prev(63 downto 56);
						block_out(71 downto 64) <= block_in(127 downto 120) xor diff_value(71 downto 64) xor prev(71 downto 64);
						block_out(79 downto 72) <= block_in(7 downto 0) xor diff_value(79 downto 72) xor prev(79 downto 72);
						block_out(87 downto 80) <= block_in(15 downto 8) xor diff_value(87 downto 80) xor prev(87 downto 80);
						block_out(95 downto 88) <= block_in(23 downto 16) xor diff_value(95 downto 88) xor prev(95 downto 88);
						block_out(103 downto 96) <= block_in(31 downto 24) xor diff_value(103 downto 96) xor prev(103 downto 96);
						block_out(111 downto 104) <= block_in(39 downto 32) xor diff_value(111 downto 104) xor prev(111 downto 104);
						block_out(119 downto 112) <= block_in(47 downto 40) xor diff_value(119 downto 112) xor prev(119 downto 112);
						block_out(127 downto 120) <= block_in(55 downto 48) xor diff_value(127 downto 120) xor prev(127 downto 120);
				
				when "1010" =>
						
						block_out(7 downto 0) <= block_in(55 downto 48) xor diff_value(7 downto 0) xor prev(7 downto 0);
						block_out(15 downto 8) <= block_in(63 downto 56) xor diff_value(15 downto 8) xor prev(15 downto 8);
						block_out(23 downto 16) <= block_in(71 downto 64) xor diff_value(23 downto 16) xor prev(23 downto 16);
						block_out(31 downto 24) <= block_in(79 downto 72) xor diff_value(31 downto 24) xor prev(31 downto 24);
						block_out(39 downto 32) <= block_in(87 downto 80) xor diff_value(39 downto 32) xor prev(39 downto 32);
						block_out(47 downto 40) <= block_in(95 downto 88) xor diff_value(47 downto 40) xor prev(47 downto 40);
						block_out(55 downto 48) <= block_in(103 downto 96) xor diff_value(55 downto 48) xor prev(55 downto 48);
						block_out(63 downto 56) <= block_in(111 downto 104) xor diff_value(63 downto 56) xor prev(63 downto 56);
						block_out(71 downto 64) <= block_in(119 downto 112) xor diff_value(71 downto 64) xor prev(71 downto 64);
						block_out(79 downto 72) <= block_in(127 downto 120) xor diff_value(79 downto 72) xor prev(79 downto 72);
						block_out(87 downto 80) <= block_in(7 downto 0) xor diff_value(87 downto 80) xor prev(87 downto 80);
						block_out(95 downto 88) <= block_in(15 downto 8) xor diff_value(95 downto 88) xor prev(95 downto 88);
						block_out(103 downto 96) <= block_in(23 downto 16) xor diff_value(103 downto 96) xor prev(103 downto 96);
						block_out(111 downto 104) <= block_in(31 downto 24) xor diff_value(111 downto 104) xor prev(111 downto 104);
						block_out(119 downto 112) <= block_in(39 downto 32) xor diff_value(119 downto 112) xor prev(119 downto 112);
						block_out(127 downto 120) <= block_in(47 downto 40) xor diff_value(127 downto 120) xor prev(127 downto 120);
				
				when "1011" =>
			
						block_out(7 downto 0) <= block_in(47 downto 40) xor diff_value(7 downto 0) xor prev(7 downto 0);
						block_out(15 downto 8) <= block_in(55 downto 48) xor diff_value(15 downto 8) xor prev(15 downto 8);
						block_out(23 downto 16) <= block_in(63 downto 56) xor diff_value(23 downto 16) xor prev(23 downto 16);
						block_out(31 downto 24) <= block_in(71 downto 64) xor diff_value(31 downto 24) xor prev(31 downto 24);
						block_out(39 downto 32) <= block_in(79 downto 72) xor diff_value(39 downto 32) xor prev(39 downto 32);
						block_out(47 downto 40) <= block_in(87 downto 80) xor diff_value(47 downto 40) xor prev(47 downto 40);
						block_out(55 downto 48) <= block_in(95 downto 88) xor diff_value(55 downto 48) xor prev(55 downto 48);
						block_out(63 downto 56) <= block_in(103 downto 96) xor diff_value(63 downto 56) xor prev(63 downto 56);
						block_out(71 downto 64) <= block_in(111 downto 104) xor diff_value(71 downto 64) xor prev(71 downto 64);
						block_out(79 downto 72) <= block_in(119 downto 112) xor diff_value(79 downto 72) xor prev(79 downto 72);
						block_out(87 downto 80) <= block_in(127 downto 120) xor diff_value(87 downto 80) xor prev(87 downto 80);
						block_out(95 downto 88) <= block_in(7 downto 0) xor diff_value(95 downto 88) xor prev(95 downto 88);
						block_out(103 downto 96) <= block_in(15 downto 8) xor diff_value(103 downto 96) xor prev(103 downto 96);
						block_out(111 downto 104) <= block_in(23 downto 16) xor diff_value(111 downto 104) xor prev(111 downto 104);
						block_out(119 downto 112) <= block_in(31 downto 24) xor diff_value(119 downto 112) xor prev(119 downto 112);
						block_out(127 downto 120) <= block_in(39 downto 32) xor diff_value(127 downto 120) xor prev(127 downto 120);
			
				when "1100" =>
						
						block_out(7 downto 0) <= block_in(39 downto 32) xor diff_value(7 downto 0) xor prev(7 downto 0);
						block_out(15 downto 8) <= block_in(47 downto 40) xor diff_value(15 downto 8) xor prev(15 downto 8);
						block_out(23 downto 16) <= block_in(55 downto 48) xor diff_value(23 downto 16) xor prev(23 downto 16);
						block_out(31 downto 24) <= block_in(63 downto 56) xor diff_value(31 downto 24) xor prev(31 downto 24);
						block_out(39 downto 32) <= block_in(71 downto 64) xor diff_value(39 downto 32) xor prev(39 downto 32);
						block_out(47 downto 40) <= block_in(79 downto 72) xor diff_value(47 downto 40) xor prev(47 downto 40);
						block_out(55 downto 48) <= block_in(87 downto 80) xor diff_value(55 downto 48) xor prev(55 downto 48);
						block_out(63 downto 56) <= block_in(95 downto 88) xor diff_value(63 downto 56) xor prev(63 downto 56);
						block_out(71 downto 64) <= block_in(103 downto 96) xor diff_value(71 downto 64) xor prev(71 downto 64);
						block_out(79 downto 72) <= block_in(111 downto 104) xor diff_value(79 downto 72) xor prev(79 downto 72);
						block_out(87 downto 80) <= block_in(119 downto 112) xor diff_value(87 downto 80) xor prev(87 downto 80);
						block_out(95 downto 88) <= block_in(127 downto 120) xor diff_value(95 downto 88) xor prev(95 downto 88);
						block_out(103 downto 96) <= block_in(7 downto 0) xor diff_value(103 downto 96) xor prev(103 downto 96);
						block_out(111 downto 104) <= block_in(15 downto 8) xor diff_value(111 downto 104) xor prev(111 downto 104);
						block_out(119 downto 112) <= block_in(23 downto 16) xor diff_value(119 downto 112) xor prev(119 downto 112);
						block_out(127 downto 120) <= block_in(31 downto 24) xor diff_value(127 downto 120) xor prev(127 downto 120);
				
				when "1101" =>
						
						block_out(7 downto 0) <= block_in(31 downto 24) xor diff_value(7 downto 0) xor prev(7 downto 0);
						block_out(15 downto 8) <= block_in(39 downto 32) xor diff_value(15 downto 8) xor prev(15 downto 8);
						block_out(23 downto 16) <= block_in(47 downto 40) xor diff_value(23 downto 16) xor prev(23 downto 16);
						block_out(31 downto 24) <= block_in(55 downto 48) xor diff_value(31 downto 24) xor prev(31 downto 24);
						block_out(39 downto 32) <= block_in(63 downto 56) xor diff_value(39 downto 32) xor prev(39 downto 32);
						block_out(47 downto 40) <= block_in(71 downto 64) xor diff_value(47 downto 40) xor prev(47 downto 40);
						block_out(55 downto 48) <= block_in(79 downto 72) xor diff_value(55 downto 48) xor prev(55 downto 48);
						block_out(63 downto 56) <= block_in(87 downto 80) xor diff_value(63 downto 56) xor prev(63 downto 56);
						block_out(71 downto 64) <= block_in(95 downto 88) xor diff_value(71 downto 64) xor prev(71 downto 64);
						block_out(79 downto 72) <= block_in(103 downto 96) xor diff_value(79 downto 72) xor prev(79 downto 72);
						block_out(87 downto 80) <= block_in(111 downto 104) xor diff_value(87 downto 80) xor prev(87 downto 80);
						block_out(95 downto 88) <= block_in(119 downto 112) xor diff_value(95 downto 88) xor prev(95 downto 88);
						block_out(103 downto 96) <= block_in(127 downto 120) xor diff_value(103 downto 96) xor prev(103 downto 96);
						block_out(111 downto 104) <= block_in(7 downto 0) xor diff_value(111 downto 104) xor prev(111 downto 104);
						block_out(119 downto 112) <= block_in(15 downto 8) xor diff_value(119 downto 112) xor prev(119 downto 112);
						block_out(127 downto 120) <= block_in(23 downto 16) xor diff_value(127 downto 120) xor prev(127 downto 120);
				
				when "1110" => 
						
						block_out(7 downto 0) <= block_in(23 downto 16) xor diff_value(7 downto 0) xor prev(7 downto 0);
						block_out(15 downto 8) <= block_in(31 downto 24) xor diff_value(15 downto 8) xor prev(15 downto 8);
						block_out(23 downto 16) <= block_in(39 downto 32) xor diff_value(23 downto 16) xor prev(23 downto 16);
						block_out(31 downto 24) <= block_in(47 downto 40) xor diff_value(31 downto 24) xor prev(31 downto 24);
						block_out(39 downto 32) <= block_in(55 downto 48) xor diff_value(39 downto 32) xor prev(39 downto 32);
						block_out(47 downto 40) <= block_in(63 downto 56) xor diff_value(47 downto 40) xor prev(47 downto 40);
						block_out(55 downto 48) <= block_in(71 downto 64) xor diff_value(55 downto 48) xor prev(55 downto 48);
						block_out(63 downto 56) <= block_in(79 downto 72) xor diff_value(63 downto 56) xor prev(63 downto 56);
						block_out(71 downto 64) <= block_in(87 downto 80) xor diff_value(71 downto 64) xor prev(71 downto 64);
						block_out(79 downto 72) <= block_in(95 downto 88) xor diff_value(79 downto 72) xor prev(79 downto 72);
						block_out(87 downto 80) <= block_in(103 downto 96) xor diff_value(87 downto 80) xor prev(87 downto 80);
						block_out(95 downto 88) <= block_in(111 downto 104) xor diff_value(95 downto 88) xor prev(95 downto 88);
						block_out(103 downto 96) <= block_in(119 downto 112) xor diff_value(103 downto 96) xor prev(103 downto 96);
						block_out(111 downto 104) <= block_in(127 downto 120) xor diff_value(111 downto 104) xor prev(111 downto 104);
						block_out(119 downto 112) <= block_in(7 downto 0) xor diff_value(119 downto 112) xor prev(119 downto 112);
						block_out(127 downto 120) <= block_in(15 downto 8) xor diff_value(127 downto 120) xor prev(127 downto 120);
				
				when others =>
				
						block_out(7 downto 0) <= block_in(15 downto 8) xor diff_value(7 downto 0) xor prev(7 downto 0);
						block_out(15 downto 8) <= block_in(23 downto 16) xor diff_value(15 downto 8) xor prev(15 downto 8);
						block_out(23 downto 16) <= block_in(31 downto 24) xor diff_value(23 downto 16) xor prev(23 downto 16);
						block_out(31 downto 24) <= block_in(39 downto 32) xor diff_value(31 downto 24) xor prev(31 downto 24);
						block_out(39 downto 32) <= block_in(47 downto 40) xor diff_value(39 downto 32) xor prev(39 downto 32);
						block_out(47 downto 40) <= block_in(55 downto 48) xor diff_value(47 downto 40) xor prev(47 downto 40);
						block_out(55 downto 48) <= block_in(63 downto 56) xor diff_value(55 downto 48) xor prev(55 downto 48);
						block_out(63 downto 56) <= block_in(71 downto 64) xor diff_value(63 downto 56) xor prev(63 downto 56);
						block_out(71 downto 64) <= block_in(79 downto 72) xor diff_value(71 downto 64) xor prev(71 downto 64);
						block_out(79 downto 72) <= block_in(87 downto 80) xor diff_value(79 downto 72) xor prev(79 downto 72);
						block_out(87 downto 80) <= block_in(95 downto 88) xor diff_value(87 downto 80) xor prev(87 downto 80);
						block_out(95 downto 88) <= block_in(103 downto 96) xor diff_value(95 downto 88) xor prev(95 downto 88);
						block_out(103 downto 96) <= block_in(111 downto 104) xor diff_value(103 downto 96) xor prev(103 downto 96);
						block_out(111 downto 104) <= block_in(119 downto 112) xor diff_value(111 downto 104) xor prev(111 downto 104);
						block_out(119 downto 112) <= block_in(127 downto 120) xor diff_value(119 downto 112) xor prev(119 downto 112);
						block_out(127 downto 120) <= block_in(7 downto 0) xor diff_value(127 downto 120) xor prev(127 downto 120);
--				
			end case;
		
	end if;
	
end process;

block_out_output <= block_out;

end arq_PermDif;