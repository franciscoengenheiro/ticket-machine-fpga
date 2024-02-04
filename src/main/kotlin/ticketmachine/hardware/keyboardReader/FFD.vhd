library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FFD is

	port(	CLK, RESET, SET, D, EN: in STD_LOGIC;
		   Q: out STD_LOGIC );
		
end FFD;

architecture arq_FFD of FFD is

begin

Q <= '0' when RESET = '1' else '1' when SET = '1' else D WHEN rising_edge(CLK) and EN = '1';

end arq_FFD;