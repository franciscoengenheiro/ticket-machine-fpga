library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IOS_tb is
end IOS_tb;

architecture behavior of IOS_tb is 

-- Component Declaration for the Unit Under Test (UUT)
component IOS 

	port( MCLK, RESET, SCLK, SDX, nSS, Fsh: in STD_LOGIC;
			Dout: out STD_LOGIC_VECTOR(8 downto 0);
			busy, Wrl, Wrt: out STD_LOGIC );
		 
end component;

--UUT signals
constant MCLK_PERIOD: TIME := 2 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

signal MCLK_tb, RESET_tb, SCLK_tb, SDX_tb, nSS_tb, FNS_tb, busy_tb, Wrl_tb, Wrt_tb: STD_LOGIC;
signal Dout_tb: STD_LOGIC_VECTOR(8 downto 0);
		 
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: IOS port map(
		MCLK => MCLK_tb,
		RESET => RESET_tb,
		SCLK => SCLK_tb,
		SDX => SDX_tb,
		nSS => nSS_tb,
		Fsh => FNS_tb,
		Dout => Dout_tb,
		busy => busy_tb,
		Wrl => Wrl_tb,
		Wrt => Wrt_tb );

	--Instantiate MCLK generator
	mclk_gen: process
	begin
		MCLK_tb <= '0';
		wait for MCLK_HALF_PERIOD/10;
		MCLK_tb <= '1';
		wait for MCLK_HALF_PERIOD/10;			
	end process;
		
	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 100ns
	stimulus: process
	begin
	
		-- Start values
		RESET_tb <= '1'; -- Reset IOS Module
		nSS_tb <= '1'; -- Control has nSS disabled
		SDX_tb <= '0'; -- This Data doesn't enter
			wait for MCLK_HALF_PERIOD*4;
		
		RESET_tb <= '0'; -- Disable Reset
		FNS_tb <= '0'; -- Client has retrieve the last printed ticket
		SCLK_tb <= '0'; -- Clock start with value 0	
			wait for MCLK_HALF_PERIOD*4;
		
						
		-- [Test 1]: Check if a valid frame reaches the end of the IOS module
		-- Since TnL (LSB) = '1', this frame is going to the Ticket Dispenser module
		-- Frame to be received: [01110100101]
		-- Expected output: Wrt and busy enabled, Dout = "001010010" 
		nSS_tb <= '0'; -- Control enabled nSS on active low
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
		SDX_tb <= '1';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';
		
		-- begin 10th element read
		SDX_tb <= '1';	
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
		nSS_tb <= '1'; -- Control disabled nSS after full frame was send
			wait for MCLK_HALF_PERIOD*4;
		FNS_tb <= '1'; -- Ticket printed
			wait for MCLK_HALF_PERIOD*4;
		FNS_tb <= '0'; -- Client has retrieve the ticket
			wait for MCLK_HALF_PERIOD*4;
			
		
		
		-- [Test 2]: Check how the IOS module reacts to an invalid frame
		-- Frame to be received: [01100101010]
		-- Expected output: No output
		nSS_tb <= '0'; -- Control enabled nSS on active low
			wait for MCLK_HALF_PERIOD*4;
		-- begin 1st element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '0';	
		
		-- begin 2nd element read	
		SDX_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '0';		
		
		-- begin 3rd element read
		SDX_tb <= '0';	
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
		SDX_tb <= '1';	
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
		
		-- *** 2nd FRAME END *** 
		nSS_tb <= '1'; -- Control disabled nSS after full frame was send
			wait for MCLK_HALF_PERIOD*4;
						
		
		-- [Test 3]: Check if a valid frame reaches the end of the IOS module
		-- Since TnL (LSB) = '0', this frame is going to the LCD module
		-- Frame to be received: [01000010110]
		-- Expected output: Wrt and busy enabled, Dout = "100001011"
		nSS_tb <= '0'; -- Control enabled nSS on active low
			wait for MCLK_HALF_PERIOD*4;
		-- begin 1st element read
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '0';	
		
		-- begin 2nd element read
		SDX_tb <= '1';	
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
		SDX_tb <= '1';	
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
		SDX_tb <= '0';	
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
		SDX_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;		
			SCLK_tb <= '1';
			wait for MCLK_HALF_PERIOD*2;
			SCLK_tb <= '0';
		
		-- begin 10th element read
		SDX_tb <= '1';	
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
		
		-- *** 3rd FRAME END *** 
		nSS_tb <= '1'; -- Control disabled nSS after full frame was send
			wait for MCLK_HALF_PERIOD*4;					
		
		wait; -- Disables stimulus generator instruction loop
		
	end process;

end;
