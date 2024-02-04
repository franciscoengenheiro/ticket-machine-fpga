library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DISPATCHER is

	port( MCLK, Fsh, Dval, RESET: in STD_LOGIC;
			Din: in STD_LOGIC_VECTOR(9 downto 0);
			Wrt, Wrl, done: out STD_LOGIC;
			Dout: out STD_LOGIC_VECTOR(8 downto 0) );
		 
end DISPATCHER;

architecture arq_DISPATCHER of DISPATCHER is

component DISPATCHER_CONTROL

	port( MCLK, Fsh, Dval, RESET, cFlag: in STD_LOGIC;
			Din: in STD_LOGIC_VECTOR(9 downto 0);
			Wrt, Wrl, done, resetC: out STD_LOGIC;
			Dout: out STD_LOGIC_VECTOR(8 downto 0) );
		 
end component;

component COUNTER4BITS 

	port ( CLR, SCLK, EN: in STD_LOGIC;
          O: out STD_LOGIC_VECTOR(3 downto 0) );
		 
end component;

signal COUNTER_LINK: STD_LOGIC_VECTOR(3 downto 0);
signal resetC_LINK, cFlag_LINK: STD_LOGIC;

begin
			
	M0: DISPATCHER_CONTROL port map (		
		MCLK => MCLK,
		Fsh => Fsh,
		Dval => Dval,
		RESET => RESET,
		cFlag => cFlag_LINK,
		Din => Din,
		Wrt => Wrt,
		Wrl => Wrl,
		done => done,
		resetC => resetC_LINK,
		Dout => Dout );
		
	M1: COUNTER4BITS port map (
		CLR => resetC_LINK,
		SCLK => MCLK,
		EN => '1',
      O => COUNTER_LINK );
		
	-- Active flag when counter equals to 15 (1111)
	cFlag_LINK <= COUNTER_LINK(3) and COUNTER_LINK(2) and  COUNTER_LINK(1) and  COUNTER_LINK(0);
		 
end arq_DISPATCHER;
