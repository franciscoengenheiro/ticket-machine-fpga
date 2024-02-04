library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PARITY_CHECK is

	port( DATA, SCLK, INIT: in STD_LOGIC;
         ERR: out STD_LOGIC);
		 
end PARITY_CHECK;

architecture arq_PARITY_CHECK of PARITY_CHECK is

component FFD 

	port(	CLK, RESET, SET, D, EN: in STD_LOGIC;
		   Q: out STD_LOGIC );
			
end component;

signal D_LINK, Q_LINK: STD_LOGIC;

begin	
	
	FFDET0: FFD port map (
		CLK => SCLK, 
		RESET => INIT,
		SET => '0',
		D => D_LINK,	
		EN => '1',
		Q => Q_LINK );	
		
	D_LINK <= (Q_LINK XOR DATA);
	ERR <= Q_LINK; 
	
end arq_PARITY_CHECK;