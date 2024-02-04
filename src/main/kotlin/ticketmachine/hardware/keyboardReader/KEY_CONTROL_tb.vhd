library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KEY_CONTROL_tb is
end KEY_CONTROL_tb;

architecture behavior of KEY_CONTROL_tb is 

-- Component Declaration for the Unit Under Test (UUT)
component KEY_CONTROL 

	port( MCLK, RESET, Kack, Kpress: in STD_LOGIC;
			Kval: out STD_LOGIC;
			Kscan: out STD_LOGIC_VECTOR(1 downto 0) );
		 
end component;

--UUT signals
constant MCLK_PERIOD: TIME := 2 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

signal MCLK_tb, RESET_tb, Kack_tb, Kpress_tb, kval_tb: STD_LOGIC;
signal Kscan_tb: STD_LOGIC_VECTOR(1 downto 0); 
		 
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: KEY_CONTROL port map(
		MCLK => MCLK_tb,
		RESET => RESET_tb,
		Kack => Kack_tb,
		Kpress => Kpress_tb,
		Kval => Kval_tb,
		Kscan => Kscan_tb );

	--Instantiate MCLK generator
	mclk_gen: process
	begin
		MCLK_tb <= '0';
		wait for MCLK_HALF_PERIOD;
		MCLK_tb <= '1';
		wait for MCLK_HALF_PERIOD;			
	end process;
		
	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 40ns
	stimulus: process
	begin
	
		-- RESET FF's current state
		RESET_tb <= '1';
		Kack_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- Disable RESET
		RESET_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;		
		
		
		
		-- [Test 1]: Entire STATE MACHINE loop, going through each avaliable state at least once
		-- Expected Starting State: STATE_SCAN
		-- Expected Output: Kscan = "10" while on STATE_SCAN
		Kpress_tb <= '0'; -- No key was pressed yet
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected State: STATE_SCAN
		Kpress_tb <= '1'; -- A key was pressed
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected State: STATE_KEY_VALID
		-- Expected Output: Kval active  and Kscan = "01" while on STATE_KEY_VALID
		Kack_tb <= '0'; -- The key hasn't been acknowledge by Key Transmitter yet
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected State: STATE_KEY_VALID
		Kack_tb <= '1'; -- The key is currently being acknowledge by Key Transmitter 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected State: STATE_VERIFIED
		-- Expected Output: No output while on STATE_VERIFIED
		Kack_tb <= '0'; -- The key was acknowledge by Key Transmitter 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected State: STATE_VERIFIED
		Kpress_tb <= '0'; -- The key is no longer pressed
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected State: STATE_SCAN

		wait; -- Disables stimulus generator instruction loop
		
	end process;

end;