library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KEY_SCAN is

	port( MCLK, RESET: in STD_LOGIC;
			Kscan: in STD_LOGIC_VECTOR(1 downto 0);
			Lin: in STD_LOGIC_VECTOR(3 downto 0);
			K: out STD_LOGIC_VECTOR(3 downto 0);
			Kpress: out STD_LOGIC;
			Col: out STD_LOGIC_VECTOR(3 downto 0) );
		 
end KEY_SCAN;

architecture arq_KEY_SCAN of KEY_SCAN is

component COUNTER_MOD3 

	port( CLR, SCLK, EN: in STD_LOGIC;
         O: out STD_LOGIC_VECTOR(1 downto 0) );
		 
end component;

component DECODER 

	port( EN: in STD_LOGIC;  
			S: in STD_LOGIC_VECTOR(1 downto 0);  
	      O: out STD_LOGIC_VECTOR(3 downto 0) );

end component;

component PRIORITY_ENCODER 

	port( EN: in STD_LOGIC; 
			I: in STD_LOGIC_VECTOR(3 downto 0);
	      Y: out STD_LOGIC_VECTOR(1 downto 0);
			GS: out STD_LOGIC );

end component;

component REGISTER2BITS 

	port( D: in STD_LOGIC_VECTOR(1 downto 0);
		   CLK, RESET, SET, EN: in STD_LOGIC;
         Q: out STD_LOGIC_VECTOR(1 downto 0) );
		 
end component;

signal O_LINK, S_LINK, Y_LINK, R_LINK: STD_LOGIC_VECTOR(1 downto 0);
signal D_LINK, NOTLIN_LINK: STD_LOGIC_VECTOR(3 downto 0);

begin
	
	M0: COUNTER_MOD3 port map ( 
		CLR => RESET,
		SCLK => MCLK,
		EN => Kscan(1),
		O => O_LINK );
		
	S_LINK(1 downto 0) <= O_LINK(1 downto 0); -- Lower Counter bits goes to Decoder
		
	M1: DECODER port map (
		S => S_LINK,
		EN => '1', -- Always Enabled
	   O  => D_LINK );
	
	-- Lines are negated upon entrance
	NOTLIN_LINK <= not LIN;  
	
	M2: PRIORITY_ENCODER port map (
		EN => '1', -- Always Enabled
		I => NOTLIN_LINK,
	   Y => Y_LINK,
		GS => Kpress );
	
	M3: REGISTER2BITS port map(
		D => Y_LINK,
		CLK => Kscan(0),
		RESET => RESET,
		SET => '0',
		EN => '1',
      Q => R_LINK );
	
	K(3 downto 0) <= O_LINK(1 downto 0) & R_LINK(1 downto 0);
	
	Col <= not D_LINK; -- Every exit of Decoder negated
	
end arq_KEY_SCAN; 
