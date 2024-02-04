library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FULLADDER is

	port( A, B, Cin: in STD_LOGIC;
         S, Cout: out STD_LOGIC );
		 
end FULLADDER;

architecture arq_FULLADDER of FULLADDER is
 
begin
 
	S <= (A XOR B) XOR Cin;
	Cout <= ((A XOR B) AND Cin) OR (A AND B);
 
end arq_FULLADDER;
