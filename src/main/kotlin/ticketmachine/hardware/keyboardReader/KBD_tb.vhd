library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KBD_tb is
end KBD_tb;

architecture behavior of KBD_tb is 

-- Component Declaration for the Unit Under Test (UUT)
component KBD

	port( MCLK, TXclk, RESET: in STD_LOGIC;
			LIN: in STD_LOGIC_VECTOR(3 downto 0);
			TXD: out STD_LOGIC;
			COL: out STD_LOGIC_VECTOR(3 downto 0) );		
		 
end component;

--UUT signals
constant MCLK_PERIOD: TIME := 2 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

signal MCLK_tb, TXclk_tb, RESET_tb, TXD_tb: STD_LOGIC;
signal LIN_tb, COL_tb: STD_LOGIC_VECTOR(3 downto 0);
		 
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: KBD port map(
		MCLK => MCLK_tb,
		TXclk => TXclk_tb,
		RESET => RESET_tb,
		LIN => LIN_tb,
		TXD => TXD_tb,
		COL => COL_tb );		

	--Instantiate MCLK generator
	mclk_gen: process
	begin
		MCLK_tb <= '0';
		wait for MCLK_HALF_PERIOD;
		MCLK_tb <= '1';
		wait for MCLK_HALF_PERIOD;			
	end process;
		
	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 100ns
	stimulus: process
	begin
		
		-- RESET FF's current state
		RESET_tb <= '1';
		TXclk_tb <= '0'; 
		-- Expected output: TXD should be '1' because DAV/Kval is not active
		wait for MCLK_HALF_PERIOD*2;
		
		-- Disable RESET
		RESET_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;		
		
		-- A key on line 2 was pressed
		LIN_tb <= "1101"; -- KPRESS = 1
		
		-- Wait until Key Transmitter has a information to send to Control
	   wait until TXD_tb <= '0'; -- Counter = 0
			TXclk_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			TXclk_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;

		-- The previous key is no longer pressed 
		LIN_tb <= "1111"; -- KPRESS = 0	
		
		-- Expected Output: Sending START BIT. TXD should be '1' / Counter = 1
			TXclk_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			TXclk_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;	
		
		-- Expected Output: Sending K[0] = 1 / Counter = 2
			TXclk_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			TXclk_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;	
		
		-- A key on line 3 was pressed
		LIN_tb <= "1011"; -- KPRESS = 1
			
		-- Expected Output: Sending K[1] = 0 / Counter = 3
			TXclk_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			TXclk_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			
		-- Expected Output: Sending K[2] = 0 / Counter = 4
			TXclk_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			TXclk_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
				
		-- Expected Output: Sending K[3] = 0 / Counter = 5
			TXclk_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			TXclk_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			
		-- The previous key is no longer pressed 
		LIN_tb <= "1111"; -- KPRESS = 0	
		
		-- Expected Output: Sending STOP BIT. TXD should be '0' / Counter = 6
			TXclk_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			TXclk_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;	
		
		-- Wait until Key Transmitter has a information to send to Control
	   wait until TXD_tb <= '0'; --  Counter = 0
			TXclk_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			TXclk_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;
			
		-- Expected Output: Sending START BIT. TXD should be '1' / Counter = 1
			TXclk_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			TXclk_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;	
		
		-- Expected Output: Sending K[0] = 0 / Counter = 2
			TXclk_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			TXclk_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;	
			
		-- Expected Output: Sending K[1] = 0 / Counter = 3
			TXclk_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			TXclk_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			
		-- Expected Output: Sending K[2] = 1 / Counter = 4
			TXclk_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			TXclk_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
				
		-- Expected Output: Sending K[3] = 1 / Counter = 5
			TXclk_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			TXclk_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
		
		-- Expected Output: Sending STOP BIT. TXD should be '0' / Counter = 6
			TXclk_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			TXclk_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;	

		wait; -- Disables stimulus generator instruction loop
		
	end process;

end;