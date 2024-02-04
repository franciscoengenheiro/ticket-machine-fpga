library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REGISTER2BITS is

	port( D: in STD_LOGIC_VECTOR(1 downto 0);
		   CLK, RESET, SET, EN: in STD_LOGIC;
         Q: out STD_LOGIC_VECTOR(1 downto 0) );
		 
end REGISTER2BITS;

architecture arq_REGISTER2BITS of REGISTER2BITS is

component FFD 

	port(	CLK, RESET, SET, D, EN: in STD_LOGIC;
		   Q: out STD_LOGIC );
		
end component;

begin
	
	FFDET0: FFD port map (
		CLK => CLK, 
		RESET => RESET,
		SET => SET,
		D => D(0),	
		EN => EN,
		Q => Q(0) );
		
	FFDET1: FFD port map (
		CLK => CLK, 
		RESET => RESET, 
		SET => SET,
		D => D(1),
		EN => EN,
		Q => Q(1) );
	
end arq_REGISTER2BITS;
