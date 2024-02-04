library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REGISTER4BITS is

	port( D: in STD_LOGIC_VECTOR(3 downto 0);
		   CLK, RESET, SET, EN: in STD_LOGIC;
         Q: out STD_LOGIC_VECTOR(3 downto 0) );
		 
end REGISTER4BITS;

architecture arq_REGISTER4BITS of REGISTER4BITS is

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
		
	FFDET2: FFD port map (
		CLK => CLK, 
		RESET => RESET, 
		SET => SET,
		D => D(2),
		EN => EN,
		Q => Q(2) );
		
	FFEDT3: FFD port map (
		CLK => CLK, 
		RESET => RESET,
		SET => SET,
		D => D(3),
		EN => EN,
		Q => Q(3) );
	
end arq_REGISTER4BITS;
