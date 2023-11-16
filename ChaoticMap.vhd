LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Impelementacao de 16 bits

entity ChaoticMap is
generic(WIDTH : integer := 32);
port(
	reset, clock, done: in std_logic;
	x_in, map_prev: in unsigned(WIDTH-1 downto 0);
	iteration_done : out std_logic;
	x_out: out unsigned(WIDTH-1 downto 0)
	);
end ChaoticMap;

architecture arq_ChaoticMap of ChaoticMap is

component Shifter is
port(
	ctrl: in integer;
	x_in: in unsigned (31 downto 0);
	x_out: out unsigned (31 downto 0)
);
end component;

TYPE STATE_TYPE is (reset_state, load_state, state0, state1, state2, state3, state4,state5);
SIGNAL current_state, next_state: STATE_TYPE;

SIGNAL reg_map_in, reg_map_prev: unsigned(WIDTH-1 downto 0);
SIGNAL add_1, add_2, x_1, x_2: unsigned(WIDTH/2-1 downto 0);
SIGNAL reg_p, p, prod, z, x_temp, shifter_out, x_out_reg: unsigned(WIDTH-1 downto 0);
SIGNAL sl: integer;
SIGNAL sig_iteration_done: std_logic;

begin

--Process que controla o estado
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

--Wait flag sera necessario para o mapa da permutacao
--Logica do proximo estado
process(current_state, next_state)

begin

	case current_state is
		
		when reset_state => 
			sig_iteration_done <= '0';
			next_state <= load_state;
			
		when load_state =>
			sig_iteration_done <= '0';
			next_state <= state0;
			
		when state0 =>
			sig_iteration_done <= '0';
			next_state <= state1;
			
		when state1 =>
			sig_iteration_done <= '0';
			next_state <= state2;
		
		when state2 =>
			sig_iteration_done <= '0';
			next_state <= state3;
			
		when state3 =>
			sig_iteration_done <= '0';
			next_state <= state4;
		
		when state4 =>
			sig_iteration_done <= '0';
			next_state <= state5;
		
		when state5 =>
			sig_iteration_done <= '1';
			next_state <= state0;
			
	end case;

end process;

--Process que controla as entradas para as operacoes
process(reset, clock, current_state, x_in, map_prev)

begin
	
	if reset = '1' then
	
		reg_map_in <= (others => '0');
		reg_map_prev <= (others => '0');
	
	elsif rising_edge(clock) then
		
		if current_state = load_state then
			reg_map_prev <= map_prev;
			reg_map_in <= x_in;
		elsif current_state = state5 then
			reg_map_prev <= reg_map_in;
			reg_map_in <= x_out_reg;
		end if;
	
	end if;
	
end process;

--Process que controla os sinais de add
process(clock, reset, current_state)

begin
	
	if reset = '1' then
	
		add_1 <= (others => '0');
		add_2 <= (others => '0');
	
	elsif rising_edge(clock) and current_state = state0 then
		
		add_1 <= reg_map_in(WIDTH-1 downto WIDTH/2) + 1;
		add_2 <= reg_map_in(WIDTH/2-1 downto 0) + 1;
		
	end if;
	
end process;

--Process que faz o produto com DSP
process(clock, reset, current_state)

begin

	if reset = '1' then
		p <= (others => '0');
		reg_p <= (others => '0');
		z <= (others => '0');

	elsif rising_edge(clock) and current_state = state1 then
			p <= add_1*add_2;
			reg_p <= p;
			z <= reg_p + 1;
	end if;

end process;
	

--Process que calcula o valor dos deslocamentos
process(clock, reset, current_state)

begin

	if reset = '1' then
		sl <= 0;
	elsif rising_edge(clock) and current_state = state2 then
		sl <= to_integer(z(4 downto 0));
	end if;

end process;

--Process que desloca o mapa caotico
process(clock, reset, current_state)

begin

	if reset = '1' then
		x_temp <= (others => '0');
	elsif rising_edge(clock) and current_state = state3 then
		x_temp <= shifter_out;
	end if;

end process;

--Process que calcula o valor final do mapa caotico
process(clock, reset, current_state)

begin

	if reset = '1' then
		x_out_reg <= (others => '0');
	elsif rising_edge(clock) and current_state = state4 then
		x_out_reg <= x_temp xor reg_map_in xor reg_map_prev;
	end if;
	
end process;

--Output assignment
x_out <= x_out_reg;
iteration_done <= sig_iteration_done;

Shift: Shifter port map(sl, z, shifter_out);

end arq_ChaoticMap;