library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SERIAL_RECEIVER_tb is
end SERIAL_RECEIVER_tb;

architecture behavior of SERIAL_RECEIVER_tb is 

-- Component Declaration for the Unit Under Test (UUT)
component SERIAL_RECEIVER 

	port( SDX, SCLK, MCLK, SS, accept, RESET: in STD_LOGIC;
         D: out STD_LOGIC_VECTOR(9 downto 0);
			DXval, busy: out STD_LOGIC );
		 
end component;

--UUT signals
constant MCLK_PERIOD: TIME := 2 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

signal SDX_tb, SCLK_tb, MCLK_tb, SS_tb, accept_tb, DXval_tb, busy_tb, RESET_tb: STD_LOGIC;
signal D_tb: STD_LOGIC_VECTOR(9 downto 0);
		 
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: SERIAL_RECEIVER port map(

		SDX => SDX_tb,
		SCLK => SCLK_tb,
		MCLK => MCLK_tb,
		SS => SS_tb, 
		accept => accept_tb,
        D => D_tb,
		DXval => DXval_tb,
		busy => busy_tb,
		RESET => RESET_tb);

	-- Instantiate MCLK generator
	mclk_gen: process
	begin
		MCLK_tb <= '1';
		wait for MCLK_HALF_PERIOD;
		MCLK_tb <= '0';
		wait for MCLK_HALF_PERIOD;			
	end process;
	
	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 250ns
	stimulus: process
	begin
		
		-- Start values
		RESET_tb <= '1'; -- Reset enabled
		SS_tb <= '1'; -- Control has SS disabled 
		SDX_tb <= '0'; -- This Data doesn't enter
			wait for MCLK_HALF_PERIOD*4;
		
		accept_tb <= '1';	-- Dispatcher is ready to receive another valid frame			
		SCLK_tb <= '0'; -- Clock start with value 0	
		RESET_tb <= '0'; -- Reset disabled
			wait for MCLK_HALF_PERIOD*4;
			
	

		-- [Test 1]: Check if a valid frame is considered valid by the Serial Receiver	
		-- Frame to be received: [00010100101]
		-- Expected output: DXval set to logical '1'
		SS_tb <= '0'; -- Control enabled SS on active low
			wait for MCLK_HALF_PERIOD*4;
		-- begin 1st element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '0';	
		
		-- begin 2nd element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '0';		
		
		-- begin 3rd element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';		
		
		-- begin 4th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';		
		
		-- begin 5th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';		
		
		-- begin 6th element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';

		-- begin 7th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';

		-- begin 8th element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';

		-- begin 9th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';
		
		-- begin 10th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';
		
		-- begin 11th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';
		
		-- *** 1st FRAME END *** 
		
		SS_tb <= '1'; -- Control disabled SS after full frame was send
			wait for MCLK_HALF_PERIOD*4;
	
		 
		-- [Test 2]: Check if an invalid frame is considered invalid by the Serial Receiver	
		-- Frame to be received: [10101001100]
		-- Expected output: -> DXval set to logical '0'
		SS_tb <= '0'; -- Control enabled SS on active low
			wait for MCLK_HALF_PERIOD*4;
		-- begin 1st element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '0';	
		
		-- begin 2nd element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '0';		
		
		-- begin 3rd element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';		
		
		-- begin 4th element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';		
		
		-- begin 5th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';		
		
		-- begin 6th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';

		-- begin 7th element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';

		-- begin 8th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';

		-- begin 9th element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';
		
		-- begin 10th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';
		
		-- begin 11th element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';
		
		-- *** 2nd FRAME END *** 
		
		SS_tb <= '1'; -- Control disabled SS after full frame was send
			wait for MCLK_HALF_PERIOD*4;
			
			
			
		 
		-- [Test 3]: Check what happens to the circuit when Control disables SS on active low mid-read
		-- Frame to be received: [10101100101]
		-- Expected output: Serial Receiver State should revert to STATE_INIT
		SS_tb <= '0'; -- Control enabled SS on active low
			wait for MCLK_HALF_PERIOD*4;
		-- begin 1st element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '0';	
		
		-- begin 2nd element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '0';		
		
		-- begin 3rd element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';		
		
		-- begin 4th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';		
		
		-- begin 5th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';		
		
		-- begin 6th element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';

		-- begin 7th element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';
			
		-- Control disables SS 
		SS_tb <= '1';
			
		-- begin 8th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';
		
		-- begin 9th element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';	
		
		-- begin 10th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';
			
		-- begin 11th element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';
			
		-- *** 3rd FRAME END *** 
		
		SS_tb <= '1'; -- Control disabled SS after full frame was send
			wait for MCLK_HALF_PERIOD*4;
			
			
			
		-- [Test 4]: Check if a valid frame is considered valid by the Serial Receiver after previous tests
		-- Frame to be received: [00010100101]
		-- Expected output: DXval set to logical '1'
		SS_tb <= '0'; -- Control enabled SS on active low
			wait for MCLK_HALF_PERIOD*4;
		-- begin 1st element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '0';	
		
		-- begin 2nd element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '0';		
		
		-- begin 3rd element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';		
		
		-- begin 4th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';		
		
		-- begin 5th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';		
		
		-- begin 6th element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';

		-- begin 7th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';
			
		-- begin 8th element read
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';
		
		-- begin 9th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';	
		
		-- begin 10th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';
			
		-- begin 11th element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';
		 
		-- *** 4th FRAME END *** 	
			
		SS_tb <= '1'; -- Control disabled SS after full frame was send
			wait for MCLK_HALF_PERIOD*4;
			
		wait; -- Disables stimulus generator instruction loop
		
	end process;

end;
