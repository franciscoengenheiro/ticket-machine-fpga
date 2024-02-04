library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LCD is

	port( D: in STD_LOGIC_VECTOR(7 downto 0);
			RS, EN: in STD_LOGIC;
			D_OUT: out STD_LOGIC_VECTOR(7 downto 0);
			RS_OUT, EN_OUT: out STD_LOGIC );
		 
end LCD;

architecture arq_LCD of LCD is

signal D_LINK: STD_LOGIC_VECTOR(7 downto 0);
signal RS_LINK, EN_LINK: STD_LOGIC;	

begin
	
	D_OUT <= D;
	RS_OUT <= RS;
	EN_OUT <= EN;
	
end arq_LCD;