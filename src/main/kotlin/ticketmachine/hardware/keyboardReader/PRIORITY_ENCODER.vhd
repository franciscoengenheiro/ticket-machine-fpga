library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Highest Priority: I3
-- Lowest Priority: I0
entity PRIORITY_ENCODER is

	port( EN: in STD_LOGIC; 
			I: in STD_LOGIC_VECTOR(3 downto 0);
	      Y: out STD_LOGIC_VECTOR(1 downto 0);
			GS: out STD_LOGIC );

end PRIORITY_ENCODER;

architecture arq_PRIORITY_ENCODER of PRIORITY_ENCODER is

begin

	Y(0) <= ((I(1) and (not I(2))) or I(3)) and EN;
	Y(1) <= (I(2) or I(3)) and EN;
	GS <= (I(0) or I(1) or I(2) or I(3)) and EN;

end arq_PRIORITY_ENCODER;
	