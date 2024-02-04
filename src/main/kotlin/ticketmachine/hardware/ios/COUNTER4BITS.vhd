library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COUNTER4BITS is

	port ( CLR, SCLK, EN: in STD_LOGIC;
          O: out STD_LOGIC_VECTOR(3 downto 0) );
		 
end COUNTER4BITS;

architecture arq_COUNTER4BITS of COUNTER4BITS is

component SUM4BITS 

	port ( A, B: in STD_LOGIC_VECTOR(3 downto 0);
	       Cin: in STD_LOGIC;
		    S: out STD_LOGIC_VECTOR(3 downto 0);
          Cout: out STD_LOGIC );
		 
end component;

component REGISTER4BITS 

	port( D: in STD_LOGIC_VECTOR(3 downto 0);
		   CLK, RESET, SET, EN: in STD_LOGIC;
         Q: out STD_LOGIC_VECTOR(3 downto 0) );
		 
end component;

signal S_LINK, R_LINK: STD_LOGIC_VECTOR(3 downto 0);

begin

	M0: SUM4BITS port map( 
		A => "0000",
		B => R_LINK,
		Cin => '1',
		S => S_LINK );
		
	M1: REGISTER4BITS port map(
		D => S_LINK,
	   CLK => SCLK,
		RESET => CLR,
		SET => '0',
		EN => EN,
	   Q => R_LINK );
		
	O <= R_LINK;
	
end arq_COUNTER4BITS;
