library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KEY_TRANSMITTER_CONTROL_tb is
end KEY_TRANSMITTER_CONTROL_tb;

architecture behavior of KEY_TRANSMITTER_CONTROL_tb is 

-- Component Declaration for the Unit Under Test (UUT)
component KEY_TRANSMITTER_CONTROL 

	port( MCLK, RESET, DAV, Cflag: in STD_LOGIC;
			ENR, RESET_C, ENC, DAC: out STD_LOGIC ); 
		 
end component;

--UUT signals
constant MCLK_PERIOD: TIME := 2 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

signal MCLK_tb, RESET_tb, DAV_tb, Cflag_tb, ENR_tb, RESET_C_tb, ENC_tb, DAC_tb: STD_LOGIC;
		 
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: KEY_TRANSMITTER_CONTROL port map(
		MCLK => MCLK_tb,
		RESET => RESET_tb,
		DAV => DAV_tb,
		Cflag => Cflag_tb,
		ENR => ENR_tb,
		RESET_C => RESET_C_tb,
		ENC => ENC_tb,
		DAC => DAC_tb ); 

	--Instantiate MCLK generator
	mclk_gen: process
	begin
		MCLK_tb <= '0';
		wait for MCLK_HALF_PERIOD;
		MCLK_tb <= '1';
		wait for MCLK_HALF_PERIOD;			
	end process;
		
	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 50ns
	stimulus: process
	begin
	
		-- RESET FF's current state
		RESET_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- Disable RESET
		RESET_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;		
		
		
		
		-- [Test 1]: Entire STATE MACHINE loop, going through each avaliable state at least once
		-- Expected Starting State: STATE_IDLE
		-- Expected Output: ENR (Enable Register) and RESET_C (Reset Counter) active while on STATE_IDLE
		DAV_tb <= '0'; -- Key Decode doesn't have a valid key yet
		wait for MCLK_HALF_PERIOD*4;
		
		-- Expected State: STATE_IDLE
		DAV_tb <= '1'; -- Key Decode has a valid key 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected State: STATE_ACK
		-- Expected Output: DAC (Key was acknowledged) active while on STATE_IDLE
		DAV_tb <= '1'; -- Key Decode is still waiting for the valid key to be acknowledge by Key Transmitter
		wait for MCLK_HALF_PERIOD*4;
		
		-- Expected State: STATE_ACK	
		DAV_tb <= '0'; -- Key Transmitter has acknowledge the key so Key Decode can resume key pad scanning
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected State: STATE_SEND
		-- Expected Output: ENC (Enable counter) active and TXD_INIT = 0 while on STATE_SEND
		Cflag_tb <= '0'; -- Counter hasn't reached 7 yet
		wait for MCLK_HALF_PERIOD*4;
		
		-- Expected State: STATE_SEND
		Cflag_tb <= '1'; -- Counter has reached 7 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected State: STATE_IDLE
		
		wait; -- Disables stimulus generator instruction loop
		
	end process;

end;