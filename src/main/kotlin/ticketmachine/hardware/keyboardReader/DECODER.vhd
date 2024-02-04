library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DECODER is

	port( EN: in STD_LOGIC;  
			S: in STD_LOGIC_VECTOR(1 downto 0);  
	      O: out STD_LOGIC_VECTOR(3 downto 0) );

end DECODER;

architecture arq_DECODER of DECODER is

begin

	O(0) <= (not S(0) and not S(1)) and EN;
	O(1) <= (    S(0) and not S(1)) and EN;
	O(2) <= (not S(0) and     S(1)) and EN;
	O(3) <= (    S(0) and 	  S(1)) and EN;

end arq_DECODER;
	