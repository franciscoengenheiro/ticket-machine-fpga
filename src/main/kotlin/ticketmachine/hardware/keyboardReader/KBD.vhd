library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KBD is

	port( MCLK, TXclk, RESET: in STD_LOGIC;
			LIN: in STD_LOGIC_VECTOR(3 downto 0);
			TXD: out STD_LOGIC;
			COL: out STD_LOGIC_VECTOR(3 downto 0) );		
		 
end KBD;

architecture arq_KBD of KBD is

component KEY_DECODE 

	port( KACK, MCLK, RESET: in STD_LOGIC;
			LIN: in STD_LOGIC_VECTOR(3 downto 0);
			K, COL: out STD_LOGIC_VECTOR(3 downto 0);		
			KVAL: out STD_LOGIC );
		 
end component;

component KEY_TRANSMITTER 

	port( MCLK, RESET, DAV, TXclk: in STD_LOGIC;
			D: in STD_LOGIC_VECTOR(3 downto 0);
			DAC, TXD: out STD_LOGIC );
		 
end component;

signal DAC_LINK, KVAL_LINK: STD_LOGIC;
signal K_LINK: STD_LOGIC_VECTOR(3 downto 0);

begin
	
	U1: KEY_DECODE port map (
		KACK => DAC_LINK,
		MCLK => MCLK,
		RESET => RESET,
		LIN => LIN,
		K => K_LINK,
		COL => COL,
		KVAL => KVAL_LINK );
	
	U2: KEY_TRANSMITTER port map (
		MCLK => MCLK,
		RESET => RESET,
		DAV => KVAL_LINK,
		TXclk => TXclk,
		D => K_LINK,
		DAC => DAC_LINK,
		TXD => TXD );
		
end arq_KBD;
