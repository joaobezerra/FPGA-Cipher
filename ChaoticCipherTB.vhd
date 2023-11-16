LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity ChaoticCipherTB is
end ChaoticCipherTB;

architecture arq_ChaoticCipherTB of ChaoticCipherTB is

component ChaoticCipher is
port(
	clock, reset: in std_logic;
	data_in: in unsigned(127 downto 0);
	ready: out std_logic;
	perm_val_out: out unsigned(3 downto 0);
	perm_counter_out: out integer range 0 to 16;
	diff_counter: out integer range 1 to 4096;
	ciph_block: out unsigned (127 downto 0)
	);
end component;

SIGNAL reset : std_logic := '1';
SIGNAL clock : std_logic := '0';
SIGNAL ready_perm_dif : std_logic;
SIGNAL ciph_block: unsigned(127 downto 0);
SIGNAL data_in: unsigned(127 downto 0);
SIGNAL perm_val_out: unsigned (3 downto 0);
SIGNAL diff_counter: integer range 1 to 4192;
SIGNAL perm_counter: integer range 0 to 16;

		-- Leitura da imagem da memoria, ta ok
	TYPE mem_type IS ARRAY(1 TO 4096) OF unsigned(127 DOWNTO 0);
	
	impure function init_mem(mif_file_name : in string) return mem_type is
			file mif_file : text open read_mode is mif_file_name;
			variable mif_line : line;
			variable temp_bv : bit_vector(127 downto 0);
			variable temp_mem : mem_type;
		begin
			for i in 1 to 4096 loop
				  readline(mif_file, mif_line);
				  read(mif_line, temp_bv);
				  temp_mem(i) := unsigned(to_stdlogicvector(temp_bv));
			 end loop;
		return temp_mem;
	end function;
	
	-- Le a imagem em um bloco de memoria
	signal ram_block: mem_type := init_mem("baboon.mif");
	--signal ram_block: mem_type := init_mem("ciph_img.mif");
	
begin

reset <= '0' after 0.25 ns;
clock <= not clock after 0.5 ns;

process(clock, reset, ram_block)
	
	begin
	
		if reset = '1' then
			data_in <= ram_block(1);
			
		elsif rising_edge(clock) then
			
			if ready_perm_dif = '1' and diff_counter < 8192 then
				data_in <= ram_block(diff_counter+1);
			end if;
			
		end if;
	
end process;

Ciph: ChaoticCipher port map(clock, reset, data_in, ready_perm_dif, perm_val_out, perm_counter, diff_counter, ciph_block);

end arq_ChaoticCipherTB;