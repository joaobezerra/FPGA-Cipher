LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Shifter is
port(
	ctrl: in integer;
	x_in: in unsigned (31 downto 0);
	x_out: out unsigned (31 downto 0)
);
end Shifter;

architecture arq_Shifter of Shifter is
	
begin
		
	with ctrl select x_out <= 
		
		x_in when 0,
		x_in(30 downto 0) & x_in(31) when 1,
		x_in(29 downto 0) & x_in(31 downto 30) when 2,
		x_in(28 downto 0) & x_in(31 downto 29) when 3,
		x_in(27 downto 0) & x_in(31 downto 28) when 4,
		x_in(26 downto 0) & x_in(31 downto 27) when 5,
		x_in(25 downto 0) & x_in(31 downto 26) when 6,
		x_in(24 downto 0) & x_in(31 downto 25) when 7,
		x_in(23 downto 0) & x_in(31 downto 24) when 8,
		x_in(22 downto 0) & x_in(31 downto 23) when 9,
		x_in(21 downto 0) & x_in(31 downto 22) when 10,
		x_in(20 downto 0) & x_in(31 downto 21) when 11,
		x_in(19 downto 0) & x_in(31 downto 20) when 12,
		x_in(18 downto 0) & x_in(31 downto 19) when 13,
		x_in(17 downto 0) & x_in(31 downto 18) when 14,
		x_in(16 downto 0) & x_in(31 downto 17) when 15,
		x_in(15 downto 0) & x_in(31 downto 16) when 16,
		x_in(14 downto 0) & x_in(31 downto 15) when 17,
		x_in(13 downto 0) & x_in(31 downto 14) when 18,
		x_in(12 downto 0) & x_in(31 downto 13) when 19,
		x_in(11 downto 0) & x_in(31 downto 12) when 20,
		x_in(10 downto 0) & x_in(31 downto 11) when 21,
		x_in(9 downto 0) & x_in(31 downto 10) when 22,
		x_in(8 downto 0) & x_in(31 downto 9) when 23,
		x_in(7 downto 0) & x_in(31 downto 8) when 24,
		x_in(6 downto 0) & x_in(31 downto 7) when 25,
		x_in(5 downto 0) & x_in(31 downto 6) when 26,
		x_in(4 downto 0) & x_in(31 downto 5) when 27,
		x_in(3 downto 0) & x_in(31 downto 4) when 28,
		x_in(2 downto 0) & x_in(31 downto 3) when 29,
		x_in(1 downto 0) & x_in(31 downto 2) when 30,
		x_in(0) & x_in(31 downto 1) when others;
		
end arq_Shifter;
