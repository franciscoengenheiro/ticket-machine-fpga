library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KEY_TRANSMITTER_tb is
end KEY_TRANSMITTER_tb;

architecture behavior of KEY_TRANSMITTER_tb is 

-- Component Declaration for the Unit Under Test (UUT)
component KEY_TRANSMITTER 

	port( MCLK, RESET, DAV, TXclk: in STD_LOGIC;
			D: in STD_LOGIC_VECTOR(3 downto 0);
			DAC, TXD: out STD_LOGIC );
		 
end component;

--UUT signals
constant MCLK_PERIOD: TIME := 2 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

signal MCLK_tb, RESET_tb, DAV_tb, TXclk_tb, DAC_tb, TXD_tb: STD_LOGIC;
signal D_tb: STD_LOGIC_VECTOR(3 downto 0);
		 
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: KEY_TRANSMITTER port map(
		MCLK => MCLK_tb,
		RESET => RESET_tb,
		DAV => DAV_tb,
		TXclk => TXclk_tb,
		D => D_tb, 
		DAC => DAC_tb,
		TXD => TXD_tb ); 
		
	--Instantiate MCLK generator
	mclk_gen: process
	begin
		MCLK_tb <= '0';
		wait for MCLK_HALF_PERIOD;
		MCLK_tb <= '1';
		wait for MCLK_HALF_PERIOD;			
	end process;
		
	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 150ns
	stimulus: process
	begin
		
		-- Start values:
		RESET_tb <= '1'; -- Reset FF's current state
		DAV_tb <= '0'; -- Key Decode doesn't have a valid key yet
		TXclk_tb <= '0'; -- Control is waiting for Key Transmitter confirmation for a valid key
		wait for MCLK_HALF_PERIOD*2;
		
		-- Disable RESET
		RESET_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;		
		
		
		
		-- [Test 1]: Check if Key Transmitter module sends TXD values correctly to Control when a valid key is received	
		-- Key Code to be received: [0101]
		-- Expected Key Transmitter Control State: IDLE
		-- Expected Output: TXD_INIT set to logical '1'
		DAV_TB <= '1'; -- Key Decode has a valid key 
		D_tb <= "0101"; -- Key code (K)  
		wait for MCLK_HALF_PERIOD*2;	
		
		-- Expected Key Transmitter Control State: ACK
		-- Expected Output: TXD_INIT set to logical '1'
		DAV_TB <= '0'; -- Key Decode doesn't have a valid key yet
		wait for MCLK_HALF_PERIOD*2;	
		
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD_INIT set to logical '0' / Counter = 0
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
			
		-- Expected Output: TXD set to logical '1' (START BIT) / Counter = 1
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD set to logical '1' (K[0]) / Counter = 2
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
			
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD set to logical '0' (K[1]) / Counter = 3
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
			
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD set to logical '1' (K[2]) / Counter = 4
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD set to logical '0' (K[3]) / Counter = 5
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD set to logical '0' (STOP BIT) / Counter = 6
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
		
		-- Counter = 7 (resets counter) 
		-- Expected Key Transmitter Control State: IDLE
		wait for MCLK_HALF_PERIOD*4;
		
		
		
		-- [Test 2]: Check how the Key Transmitter module reacts when a new valid key is received and the previous key correspondent
		-- TXD values weren't all sent to Control yet, in other words, evaluate if the built-in buffer for 1 key is working correctly
		-- Key Code to be received: [1010]
		-- Next Key Code to be received: [0011]
		-- Expected Key Transmitter Control State: IDLE
		-- Expected Output: TXD_INIT set to logical '1'
		DAV_TB <= '1'; -- Key Decode has a valid key 
		D_tb <= "1010"; -- First key code received (K)
		wait for MCLK_HALF_PERIOD*2;	
		
		-- Expected Output: TXD_INIT set to logical '1'
		-- Expected Key Transmitter Control State: ACK
		DAV_TB <= '0'; -- Key Decode doesn't have a valid key yet
		wait for MCLK_HALF_PERIOD*2;	
		
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD_INIT set to logical '0' / Counter = 0
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
			
		-- Expected Output: TXD set to logical '1' (START BIT) / Counter = 1
 		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2; 
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD set to logical '0' (K[0]) / Counter = 2
		DAV_TB <= '1'; -- Key Decode has a valid key
		D_tb <= "0011"; -- Another Key code (K) was received in the meantime
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
			
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD set to logical '1' (K[1]) / Counter = 3
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
			
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD set to logical '0' (K[2]) / Counter = 4
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
			
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD set to logical '1' (K[3]) / Counter = 5
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD set to logical '0' (Stop bit) / Counter = 6
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
			
		-- Expected Key Transmitter Control State: IDLE
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: TXD_INIT set to logical '0' / Counter = 0
		-- Expected Key Transmitter Control State: ACK
		DAV_tb <= '0'; -- Key Decode doesn't have a valid key yet
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD set to logical '1' (START BIT) / Counter = 1
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD set to logical '1' (K[0]) / Counter = 2
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2; 
			
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD set to logical '1' (K[1]) / Counter = 3
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
			
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD set to logical '0' (K[2]) / Counter = 4
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD set to logical '0' (K[3]) / Counter = 5
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Key Transmitter Control State: SEND
		-- Expected Output: TXD set to logical '0' (STOP BIT) / Counter = 6
		TXclk_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
		TXclk_tb <= '0';
			wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Key Transmitter Control State: IDLE
		
		wait; -- Disables stimulus generator instruction loop
		
	end process;

end;