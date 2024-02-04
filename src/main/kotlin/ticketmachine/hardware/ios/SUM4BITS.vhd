library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SUM4BITS is

	port( A, B: in STD_LOGIC_VECTOR(3 downto 0);
	      Cin: in STD_LOGIC;
		   S: out STD_LOGIC_VECTOR(3 downto 0);
         Cout: out STD_LOGIC );
		 
end SUM4BITS;

architecture arq_SUM4BITS of SUM4BITS is

component FULLADDER

	port( A, B, Cin: in STD_LOGIC;
         S, Cout: out STD_LOGIC );
     
		  
end component;

signal c1,c2,c3: STD_LOGIC;

begin

	FULLADDER1: FULLADDER port map( A(0), B(0), Cin, S(0), c1); 
	FULLADDER2: FULLADDER port map( A(1), B(1), c1, S(1), c2); 
	FULLADDER3: FULLADDER port map( A(2), B(2), c2, S(2), c3); 
	FULLADDER4: FULLADDER port map( A(3), B(3), c3, S(3), Cout); 
 
end arq_SUM4BITS;
