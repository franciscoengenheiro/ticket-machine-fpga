library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IOS is

	port( MCLK, RESET, SCLK, SDX, nSS, Fsh: in STD_LOGIC;
			Dout: out STD_LOGIC_VECTOR(8 downto 0);
			busy, Wrl, Wrt: out STD_LOGIC );
		 
end IOS;

architecture arq_IOS of IOS is

component SERIAL_RECEIVER 

	port( SDX, MCLK, SCLK, nSS, accept, RESET: in STD_LOGIC;
         D: out STD_LOGIC_VECTOR(9 downto 0);
			DXval, busy: out STD_LOGIC ); 
		 
end component;

component DISPATCHER 

	port( MCLK, Fsh, Dval, RESET: in STD_LOGIC;
			Din: in STD_LOGIC_VECTOR(9 downto 0);
			Wrt, Wrl, done: out STD_LOGIC;
			Dout: out STD_LOGIC_VECTOR(8 downto 0) );
		 
end component;

signal DXval_LINK, done_LINK: STD_LOGIC;
signal D_LINK: STD_LOGIC_VECTOR(9 downto 0);

begin

	SLR: SERIAL_RECEIVER port map (
		SDX => SDX,
		MCLK => MCLK,
		SCLK => SCLK,
		nSS => nSS,
		accept => done_LINK,
		RESET => RESET,
      D =>  D_LINK,
		DXval => DXval_LINK,
		busy => busy );	
	
	DPTR: DISPATCHER port map (
		MCLK => MCLK,
		Fsh => Fsh,
		Dval => DXval_LINK,
		RESET => RESET,
		Din => D_LINK,
		Wrt => Wrt,
		Wrl => Wrl,
		done => done_LINK,
		Dout => Dout );			
			
end arq_IOS;