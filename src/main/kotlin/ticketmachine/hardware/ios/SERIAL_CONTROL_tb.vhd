library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SERIAL_CONTROL_tb is
end SERIAL_CONTROL_tb;

architecture behavior of SERIAL_CONTROL_tb is 

-- Component Declaration for the Unit Under Test (UUT)
component SERIAL_CONTROL 

	port( nSS, accept, dFlag, pFlag, RXerror, MCLK, RESET: in STD_LOGIC;
			wr, init, DXval, busy: out STD_LOGIC );
		 
end component;

--UUT signals
constant MCLK_PERIOD: TIME := 2 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

signal nSS_tb, accept_tb, dFlag_tb, pFlag_tb, RXerror_tb, MCLK_tb, RESET_tb, wr_tb, init_tb, DXval_tb, busy_tb: std_logic;
		 
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: SERIAL_CONTROL port map(
		nSS => nSS_tb,
		accept => accept_tb,
		dFlag => dFlag_tb,
		pFlag => pFlag_tb,
		RXerror => RXerror_tb,
		MCLK => MCLK_tb,
		RESET => RESET_tb,
		wr => wr_tb,
		init => init_tb,
		DXval => DXval_tb,
		busy => busy_tb );

	--Instantiate MCLK generator
	mclk_gen: process
	begin
		MCLK_tb <= '0';
		wait for MCLK_HALF_PERIOD;
		MCLK_tb <= '1';
		wait for MCLK_HALF_PERIOD;			
	end process;
		
	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 80ns
	stimulus: process
	begin
	
		-- Reset FF's current state
		reset_tb <= '1'; -- Reset Serial Control current state
		nSS_tb <= '1'; -- Control has disabled sending protocol 
		RXerror_tb <= '0'; -- No error can be reported since no frame is currently in the Serial Receiver
		accept_tb <= '1'; -- Dispatcher has processed the previously sent frame 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Disable RESET
		reset_tb <= '0'; -- Reset disabled
		wait for MCLK_HALF_PERIOD*2;		
		
		
		
		-- [Test 1]: Entire STATE MACHINE loop, going through each avaliable state at least once
		-- Expected starting State: STATE_INIT
		nSS_tb <= '0'; -- Control wants to send a frame to Serial Receiver
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected State: STATE_WRITE
		dFlag_tb <= '1'; -- Serial Receiver received 10 bits of this frame 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected State: STATE_OFF
		nSS_tb <= '0'; -- Control hasn't finished sending data
		wait for MCLK_HALF_PERIOD*2; 
		
		-- Expected State: STATE_OFF
		nSS_tb <= '1'; -- Control finished sending data
		pFlag_tb <= '1'; -- Serial Receiver received 11 bits of this frame
		RXerror_tb <= '0'; -- No error was detected in this frame
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected State: STATE_BUSY
		accept_tb <= '0'; -- Control finished sending data
		wait for MCLK_HALF_PERIOD*2;
	
		-- Expected State: STATE_BUSY
		accept_tb <= '1'; -- Control finished sending data
		wait for MCLK_HALF_PERIOD*2;
			
		-- Expected State: STATE_WAIT
		accept_tb <= '0'; -- Control finished sending data
		wait for MCLK_HALF_PERIOD*2;
	
		-- Expected State: STATE_WAIT
		accept_tb <= '1'; -- Control finished sending data
		wait for MCLK_HALF_PERIOD*8;
		
		
	
		-- [Test 2]: Evaluate paths that lead to early initial state
		------------------------------------------------------------------------------------------------
		-- Expected starting State: STATE_INIT
		nSS_tb <= '0'; -- Control wants to send a frame to Serial Receiver
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected State: STATE_WRITE
		nSS_tb <= '1'; -- Control finished sending data, but the first 10 bits weren't acknowledged
		wait for MCLK_HALF_PERIOD*2;
		
		------------------------------------------------------------------------------------------------
		-- Expected State: STATE_INIT
		nSS_tb <= '0'; -- Control wants to send another frame to Serial Receiver
		wait for MCLK_HALF_PERIOD*2;

		-- Expected State: STATE_WRITE
		dFlag_tb <= '1'; -- Serial Receiver received 10 bits of this frame 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected State: STATE_OFF
		nSS_tb <= '1'; -- Control finished sending data
		pFlag_tb <= '0'; -- Serial Receiver hasn't received all bits of this frame 
		wait for MCLK_HALF_PERIOD*2;
		
		------------------------------------------------------------------------------------------------
		-- Expected starting State: STATE_INIT
		nSS_tb <= '0'; -- Control wants to send a frame to Serial Receiver
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected State: STATE_WRITE
		dFlag_tb <= '1'; -- Serial Receiver received 10 bits of this frame 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected State: STATE_OFF
		nSS_tb <= '0'; -- Control hasn't finished sending data
		wait for MCLK_HALF_PERIOD*2; 
		
		-- Expected State: STATE_OFF
		nSS_tb <= '1'; -- Control finished sending data
		pFlag_tb <= '1'; -- Serial Receiver received 11 bits of this frame
		RXerror_tb <= '1'; -- Error was detected in this frame
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected State: STATE_INIT
		wait for MCLK_HALF_PERIOD*2;
		
		wait; -- Disables stimulus generator instruction loop
		
	end process;
	
end;