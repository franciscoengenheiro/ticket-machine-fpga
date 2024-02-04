library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SERIAL_RECEIVER is

	port( SDX, MCLK, SCLK, nSS, accept, RESET: in STD_LOGIC;
          D: out STD_LOGIC_VECTOR(9 downto 0);
		  DXval, busy: out STD_LOGIC ); 
		 
end SERIAL_RECEIVER;

architecture arq_SERIAL_RECEIVER of SERIAL_RECEIVER is

component SHIFTREGISTER

	port( Sin, SCLK, EN, RESET: in STD_LOGIC;
          D: out STD_LOGIC_VECTOR(9 downto 0) );
		 
end component;

component COUNTER4BITS 

	port( CLR, SCLK, EN: in STD_LOGIC;
          O: out STD_LOGIC_VECTOR(3 downto 0) );
		 
end component;

component SERIAL_CONTROL 

	port( nSS, accept, dFlag, pFlag, RXerror, RESET, MCLK: in STD_LOGIC;
		  wr, init, DXval, busy: out STD_LOGIC );
		 
end component;

component PARITY_CHECK 

	port( DATA, SCLK, INIT: in STD_LOGIC;
          ERR: out STD_LOGIC);
		 
end component;

signal COUNTER_LINK: STD_LOGIC_VECTOR(3 downto 0);
signal dFlag_LINK, pFlag_LINK, INIT_LINK, ERR_LINK, WR_LINK: STD_LOGIC;

begin
			
	M0: SHIFTREGISTER port map (		
		Sin => SDX,
		SCLK => SCLK,
		EN => WR_LINK,
		RESET => RESET,
        D => D );
		
	M1: COUNTER4BITS port map (
		CLR => INIT_LINK,
		SCLK => SCLK,
		EN => '1',
        O => COUNTER_LINK );
	
	M2: PARITY_CHECK port map (
		DATA => SDX, 
		SCLK => SCLK,
		INIT => INIT_LINK,
        ERR => ERR_LINK );
	
	M3: SERIAL_CONTROL port map (
		nSS => nSS,
		RESET => RESET,
		accept => accept,
		dFlag => dFlag_LINK,
		pFlag => pFlag_LINK,
		RXerror => ERR_LINK,
		MCLK => MCLK,
		wr => WR_LINK,
		init => INIT_LINK,
		DXval =>	DXval,
		busy => busy );
		
	-- Active flag when counter equals to 10 (1010)
	dFlag_LINK <= COUNTER_LINK(3) and not COUNTER_LINK(2) and COUNTER_LINK(1) and not COUNTER_LINK(0);
	
	
	-- Active flag when counter equals to 11 (1011)
	pFlag_LINK <= COUNTER_LINK(3) and not COUNTER_LINK(2) and COUNTER_LINK(1) and COUNTER_LINK(0); 
		 
end arq_SERIAL_RECEIVER;
