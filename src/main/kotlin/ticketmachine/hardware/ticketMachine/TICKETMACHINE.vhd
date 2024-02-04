library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TICKETMACHINE is

	port( MCLK, RESET: in STD_LOGIC; -- General in
			CollectTicket: in STD_LOGIC; -- Ticket Dispenser in
			COIN: in STD_LOGIC; -- Coin Acceptor in
			M: in STD_LOGIC; -- Maintenance Mode 
			CID: in STD_LOGIC_VECTOR(2 downto 0); -- Coin Acceptor in
			LIN: in STD_LOGIC_VECTOR(3 downto 0); -- KBD in
			PRINT: out STD_LOGIC; -- Ticket Dispenser out
			COIN_EJECT, COIN_COLLECT, COIN_ACCEPT: out STD_LOGIC; -- Coin Acceptor Out
			RS_OUT, EN_OUT: out STD_LOGIC; -- LCD out
			COL: out STD_LOGIC_VECTOR(3 downto 0);	-- KBD out
			HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out STD_LOGIC_VECTOR(7 downto 0); -- 6 seven segments displays out
			D_OUT: out STD_LOGIC_VECTOR(7 downto 0) ); -- LCD out
			
end TICKETMACHINE;

architecture arq_TICKETMACHINE of TICKETMACHINE is

component KBD 

	port( MCLK, TXclk, RESET: in STD_LOGIC;
			LIN: in STD_LOGIC_VECTOR(3 downto 0);
			TXD: out STD_LOGIC;
			COL: out STD_LOGIC_VECTOR(3 downto 0) );		
		 
end component;

component UsbPort 

	port ( inputPort: in STD_LOGIC_VECTOR(7 DOWNTO 0);
			 outputPort: out STD_LOGIC_VECTOR(7 DOWNTO 0) );
			 
end component;

component IOS 

	port ( MCLK, RESET, SCLK, SDX, nSS, Fsh: in STD_LOGIC;
			 Dout: out STD_LOGIC_VECTOR(8 downto 0);
			 busy, Wrl, Wrt: out STD_LOGIC );
		 
end component;

component TICKET_DISPENSER 

	port ( Prt, CollectTicket: in STD_LOGIC;
			 Dout: in STD_LOGIC_VECTOR(8 downto 0);
			 Fn: out STD_LOGIC;
			 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out STD_LOGIC_VECTOR(7 downto 0) );
			
end component;

component LCD 

	port ( D: in STD_LOGIC_VECTOR(7 downto 0);
			 RS, EN: in STD_LOGIC;
			 D_OUT: out STD_LOGIC_VECTOR(7 downto 0);
			 RS_OUT, EN_OUT: out STD_LOGIC );
		 
end component;

-- UsbPort signals:
-- Inputport:
signal busy_LINK, RXD_LINK, CID0_LINK, CID1_LINK, CID2_LINK, COIN_LINK, M_LINK: STD_LOGIC;
-- Outputport:
signal SDX_LINK, SCLK_LINK, nSS_LINK, RXCLK_LINK, COIN_EJECT_LINK, COIN_COLLECT_LINK, COIN_ACCEPT_LINK: STD_LOGIC;

-- Module signals:
signal Fn_LINK, Wrl_LINK, Wrt_LINK: STD_LOGIC; 
signal Dout_LINK: STD_LOGIC_VECTOR(8 downto 0);

begin
	
	M0: KBD port map (
		MCLK => MCLK,
		TXclk => RXCLK_LINK,
		RESET => RESET,
		LIN => LIN,
		TXD => RXD_LINK,
		COL => COL );		
	
	M1: UsbPort port map (
		-- InputPorts:
		inputPort(0) => busy_LINK,
		inputPort(1) => RXD_LINK,
		inputPort(2) => CID0_LINK,
		inputPort(3) => CID1_LINK, 
		inputPort(4) => CID2_LINK,
		inputPort(5) => COIN_LINK, 
		--inputPort(6) => '0',
		inputPort(7) => M_LINK,
		-- OutputPorts:
		outputPort(0) => SDX_LINK,
	   outputPort(1) => SCLK_LINK,
		outputPort(2) => nSS_LINK,
		outputPort(3) => RXCLK_LINK, 
		outputPort(4) => COIN_EJECT_LINK, 	
		outputPort(5) => COIN_COLLECT_LINK, 
		outputPort(6) => COIN_ACCEPT_LINK );
		--outputPort(7) => '0' );
	
	M2: IOS port map (
		MCLK => MCLK,
		Fsh => Fn_LINK,
		RESET => RESET,
		SCLK => SCLK_LINK,
		SDX => SDX_LINK,
		nSS => nSS_LINK,
		busy => busy_LINK,
		Dout => Dout_LINK,
		wrl => Wrl_LINK,
		Wrt => Wrt_LINK );
				
	M3: TICKET_DISPENSER port map (
	   CollectTicket => CollectTicket,
		Prt => Wrt_LINK,
		Dout => Dout_LINK,
		Fn => Fn_LINK,
		HEX0 => HEX0,
		HEX1 => HEX1,
		HEX2 => HEX2, 
		HEX3 => HEX3,
		HEX4 => HEX4,
		HEX5 => HEX5 );

	M4: LCD port map (
		D => Dout_LINK(8 downto 1),
		RS => Dout_LINK(0), 
		EN => Wrl_LINK,
		D_OUT => D_OUT,
		RS_OUT => RS_OUT,
		EN_OUT => EN_OUT );
	
	-- SW Inputs
	M_LINK <= M;
	COIN_LINK <= COIN;
	CID0_LINK <= CID(0);
	CID1_LINK <= CID(1);
	CID2_LINK <= CID(2);
	
	-- LEDS Outputs
	PRINT <= '1' when (Wrt_LINK = '1') else '0';
	COIN_EJECT <= COIN_EJECT_LINK;
	COIN_COLLECT <= COIN_COLLECT_LINK;
	COIN_ACCEPT <= COIN_ACCEPT_LINK;
					
end arq_TICKETMACHINE;