library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SUM2BITS is

	port( A, B: in STD_LOGIC_VECTOR(1 downto 0);
	      Cin: in STD_LOGIC;
		   S: out STD_LOGIC_VECTOR(1 downto 0);
         Cout: out STD_LOGIC );
		 
end SUM2BITS;

architecture arq_SUM2BITS of SUM2BITS is

component FULLADDER

	port( A, B, Cin: in STD_LOGIC;
         S, Cout: out STD_LOGIC );
     
		  
end component;

signal c1: STD_LOGIC;

begin

	FULLADDER1: FULLADDER port map( A(0), B(0), Cin, S(0), c1); 
	FULLADDER2: FULLADDER port map( A(1), B(1), c1, S(1), Cout); 
 
end arq_SUM2BITS;
