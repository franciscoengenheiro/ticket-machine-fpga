library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KEY_TRANSMITTER is

	port( MCLK, RESET, DAV, TXclk: in STD_LOGIC;
			D: in STD_LOGIC_VECTOR(3 downto 0);
			DAC, TXD: out STD_LOGIC );
		 
end KEY_TRANSMITTER;

architecture arq_KEY_TRANSMITTER of KEY_TRANSMITTER is

component KEY_TRANSMITTER_CONTROL 

	port( MCLK, RESET, DAV, Cflag: in STD_LOGIC;
			ENR, RESET_C, ENC, DAC, TXD_INIT: out STD_LOGIC ); 
		 
end component;

component REGISTER4BITS 

	port( D: in STD_LOGIC_VECTOR(3 downto 0);
		   CLK, RESET, SET, EN: in STD_LOGIC;
         Q: out STD_LOGIC_VECTOR(3 downto 0) );
		 
end component;

component COUNTER4BITS 

	port( CLR, SCLK, EN: in STD_LOGIC;
         O: out STD_LOGIC_VECTOR(3 downto 0) );
		 
end component;

component Mux8x3 

    port( A: in STD_LOGIC_VECTOR(7 downto 0);
          S: in STD_LOGIC_VECTOR(2 downto 0);
          O: out STD_LOGIC );

end component;

signal C_FLAG, ENR_LINK, ENC_LINK, RESETC_LINK, TXD_INIT_LINK: STD_LOGIC;
signal S_LINK: STD_LOGIC_VECTOR(2 downto 0);
signal O_LINK, Q_LINK: STD_LOGIC_VECTOR(3 downto 0);
signal M_LINK: STD_LOGIC_VECTOR(7 downto 0);

begin
	
	-- Active flag when counter equals to 7 (111)
	C_FLAG <= (O_LINK(2) and O_LINK(1) and O_LINK(0)) and not TXclk;

	M0: KEY_TRANSMITTER_CONTROL port map (
		MCLK => MCLK, 
		RESET => RESET,
		DAV => DAV,
		Cflag => C_FLAG,
		ENR => ENR_LINK,
		RESET_C => RESETC_LINK,
		ENC => ENC_LINK,
		DAC => DAC,
		TXD_INIT => TXD_INIT_LINK ); 
	
	M1: REGISTER4BITS port map ( 
		D => D,
	   CLK => MCLK,
		RESET => RESET,
		SET => '0',
		EN => ENR_LINK,
      Q => Q_LINK);
	
	M2: COUNTER4BITS port map (
		CLR => RESETC_LINK,
		SCLK => TXclk,
		EN => ENC_LINK,
      O => O_LINK );
	
	-- Counter last 3 bits assignment:
	S_LINK(2 downto 0) <= O_LINK(2 downto 0);
	
	-- Multiplexer Assignments:
	M_LINK(0) <= TXD_INIT_LINK; -- Either '1' (Default TXD value) or '0' (INIT BIT)
	M_LINK(1) <= '1'; -- Start bit
	M_LINK(2) <= Q_LINK(0); -- K(0)
	M_LINK(3) <= Q_LINK(1); -- K(1)
	M_LINK(4) <= Q_LINK(2); -- K(2)
	M_LINK(5) <= Q_LINK(3); -- K(3)
	M_LINK(6) <= '0'; -- Stop bit
	M_LINK(7) <= '1'; -- Place holder value 
	
	M3: MUX8x3 port map (
		A => M_LINK,
      S => S_LINK,
      O => TXD );
									
end arq_KEY_TRANSMITTER; 
