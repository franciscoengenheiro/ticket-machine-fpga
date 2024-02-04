LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity DECODERHEX is

	port ( A: in STD_LOGIC_VECTOR(3 downto 0);
			 ewr: in STD_LOGIC_VECTOR(7 downto 0);
			 clear: in STD_LOGIC;
			 HEX0: out STD_LOGIC_VECTOR(7 downto 0) );		
			
end DECODERHEX;

architecture logicFuntion of DECODERHEX is

component INT7SEG 

	port(	d: in STD_LOGIC_VECTOR(3 downto 0);
			ewr: in STD_LOGIC_VECTOR(7 downto 0);
			dOut: out STD_LOGIC_VECTOR(7 downto 0) );
			
end component;

signal HEX0t: STD_LOGIC_VECTOR(7 downto 0);

begin

U0: int7seg port map(A, ewr, HEX0t);

HEX0 <= HEX0t when clear = '0' else "11111111";
							
end logicFuntion;