library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KEY_DECODE is

	port( KACK, MCLK, RESET: in STD_LOGIC;
			LIN: in STD_LOGIC_VECTOR(3 downto 0);
			K, COL: out STD_LOGIC_VECTOR(3 downto 0);		
			KVAL: out STD_LOGIC );
		 
end KEY_DECODE;

architecture arq_KEY_DECODE of KEY_DECODE is

component KEY_SCAN 

	port( MCLK, RESET: in STD_LOGIC;
			Kscan: in STD_LOGIC_VECTOR(1 downto 0);
			Lin: in STD_LOGIC_VECTOR(3 downto 0);
			K: out STD_LOGIC_VECTOR(3 downto 0);
			Kpress: out STD_LOGIC;
			Col: out STD_LOGIC_VECTOR(3 downto 0) );
		 
end component;

component KEY_CONTROL 

	port( MCLK, RESET, Kack, Kpress: in STD_LOGIC;
			Kval: out STD_LOGIC;
			Kscan: out STD_LOGIC_VECTOR(1 downto 0) );
		 
end component;

component CLKDIV 

	generic(div: natural := 250000);
	port( clk_in: in std_logic;
			clk_out: out std_logic);
		 
end component;

signal KPRESS_LINK, M_LINK: STD_LOGIC;
signal KSCAN_LINK: STD_LOGIC_VECTOR (1 downto 0);

begin
	
	-- Using CLK_DIV to lower the avaliable frequency to 200Hz(0.01s)
	M0: CLKDIV port map (
		clk_in => MCLK,
		clk_out => M_LINK );
	
	U1: KEY_SCAN port map (
		Kscan => KSCAN_LINK,
		MCLK => M_LINK, 
		RESET => RESET,
		K => K,
		Kpress => KPRESS_LINK,
		Col => COL,
		Lin => LIN );
	
	U2: KEY_CONTROL port map (
		MCLK => not M_LINK,
		RESET => RESET,
		Kack => KACK,
		Kpress => KPRESS_LINK,
		Kval => KVAL,
		Kscan => KSCAN_LINK );
		
end arq_KEY_DECODE;
