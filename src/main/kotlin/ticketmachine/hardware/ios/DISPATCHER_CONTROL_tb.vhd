library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DISPATCHER_CONTROL_tb is
end DISPATCHER_CONTROL_tb;

architecture behavior of DISPATCHER_CONTROL_tb is 

-- Component Declaration for the Unit Under Test (UUT)
component DISPATCHER_CONTROL 

	port( MCLK, Fsh, Dval, RESET, cFlag: in STD_LOGIC;
			Din: in STD_LOGIC_VECTOR (9 downto 0);
			Wrt, Wrl, done, resetC: out STD_LOGIC;
			Dout: out STD_LOGIC_VECTOR (8 downto 0) );
		 
end component;

--UUT signals
constant MCLK_PERIOD: TIME := 2 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

signal MCLK_tb, Fsh_tb, Dval_tb, RESET_tb, cFlag_tb, Wrt_tb, Wrl_tb, done_tb, resetC_tb: STD_LOGIC;
signal Din_tb: STD_LOGIC_VECTOR (9 downto 0);
signal Dout_tb: STD_LOGIC_VECTOR (8 downto 0);
		 
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: DISPATCHER_CONTROL port map(
		MCLK => MCLK_tb,
		Fsh => Fsh_tb,
		Dval => Dval_tb,
		RESET => RESET_tb,
		cFlag => cFlag_tb,
		Din => Din_tb,
		Wrt => Wrt_tb,
		Wrl => Wrl_tb,
		done => done_tb,
		resetC => resetC_tb,
		Dout => Dout_tb );

	-- Instantiate MCLK generator
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
	
		-- Start values
		Fsh_tb <= '0'; -- No ticket was printed yet
		RESET_tb <= '1'; -- Reset Dispatcher current state
		wait for MCLK_HALF_PERIOD*2;	
		RESET_tb <= '0'; -- Reset disabled
		wait for MCLK_HALF_PERIOD*2;		
						
						
						
		-- [Test 1]: Evaluate the state path when Dispatcher receives a frame with Tnl (Din LSB) = 1
		-- End Module: Ticket Dispenser
		-- Frame to be received: [1010010001]
		-- Expected output: Wrt and done enabled in their respective states, Dout = "101001000"
		-- Expected state: STATE_RECEIVE
		Din_tb <= "1010010001"; 		
		Dval_tb <= '0'; -- Serial Receiver doesn't have a valid frame to send yet
		wait for MCLK_HALF_PERIOD*4;
		
		-- Expected state: STATE_RECEIVE
		Dval_tb <= '1'; -- Serial Receiver has a valid frame to send
		wait for MCLK_HALF_PERIOD*4;
		
		-- Expected state: STATE_WRITE_TD
		Fsh_tb <= '1'; -- Client has retrieve the Ticket
		wait for MCLK_HALF_PERIOD*4;
		
		-- Expected state: STATE_TICKET_EXIT
		Fsh_tb <= '0'; 
		wait for MCLK_HALF_PERIOD*4;

		-- Expected state: STATE_DONE 
		Dval_tb <= '1'; -- busy signal from Serial Receiver is still activated
		wait for MCLK_HALF_PERIOD*4;
		
		-- Expected state: STATE_DONE 
		Dval_tb <= '0'; -- busy signal was disabled
		wait for MCLK_HALF_PERIOD*4;
		
		
		
		-- [Test 2]: Evaluate the state path when Dispatcher receives a frame with Tnl (Din LSB) = 0 
		-- End Module: LCD
		-- Frame to be received: [1011101010]
		-- Expected output: resetC, Wrl and done enabled in their respective states, Dout = "101110101"
		-- Expected state: STATE_RECEIVE 
		Dval_tb <= '1'; -- Serial Receiver has a valid frame to send
		cFlag_tb <= '0'; --  Dispatcher counter has been reseted
		Din_tb <= "1011101010"; 
		wait for MCLK_HALF_PERIOD*2;

		-- Expected state: STATE_RST_COUNTER
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected state: STATE_WRITE_LCD
		cFlag_tb <= '1'; -- Dispatcher counter has reached 15
		wait for MCLK_HALF_PERIOD*4;
		
		-- Expected state: STATE_DONE 
		Dval_tb <= '1'; -- busy signal from Serial Receiver is still active
		wait for MCLK_HALF_PERIOD*4;
		
		-- Expected state: STATE_DONE 
		Dval_tb <= '0'; -- busy signal was disabled
		wait for MCLK_HALF_PERIOD*4;
		
		wait; -- Disables stimulus generator instruction loop
		
	end process;

end;