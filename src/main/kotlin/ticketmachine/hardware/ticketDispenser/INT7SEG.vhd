LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

entity INT7SEG is

	port(	d: in STD_LOGIC_VECTOR(3 downto 0);
			ewr: in STD_LOGIC_VECTOR(7 downto 0);
			dOut: out STD_LOGIC_VECTOR(7 downto 0) );
			
end INT7SEG;

architecture logicFunction of INT7SEG is

begin

-- ewr stands for enable write, which will let the user directly set values for each LED avalaible in a 7 segment display 

dOut <= 	ewr when ewr /= "11111111" else
			"11000000" when d = "0000" else 
			"11111001" when d = "0001" else
			"10100100" when d = "0010" else
			"10110000" when d = "0011" else
			"10011001" when d = "0100" else
			"10010010" when d = "0101" else
			"10000010" when d = "0110" else
			"11111000" when d = "0111" else
			"10000000" when d = "1000" else
			"10011000" when d = "1001" else
			"10001000" when d = "1010" else -- A
			"10000011" when d = "1011" else -- B
			"11000110" when d = "1100" else -- C
			"10100001" when d = "1101" else -- D
			"10000110" when d = "1110" else -- E
			"10001110"; 						  -- F

end logicFunction;