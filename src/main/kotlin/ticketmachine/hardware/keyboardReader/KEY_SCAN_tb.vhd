library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KEY_SCAN_tb is
end KEY_SCAN_tb;

architecture behavior of KEY_SCAN_tb is 


-- Note: CLK_DIV must be disconnect from Key Scan module in order to use this tb correctly
-- Component Declaration for the Unit Under Test (UUT)
component KEY_SCAN is

	port( MCLK, RESET: in STD_LOGIC;
			Kscan: in STD_LOGIC_VECTOR(1 downto 0);
			Lin: in STD_LOGIC_VECTOR(3 downto 0);
			K: out STD_LOGIC_VECTOR(3 downto 0);
			Kpress: out STD_LOGIC;
			Col: out STD_LOGIC_VECTOR(3 downto 0) );
		 
end component;

--UUT signals
constant MCLK_PERIOD: TIME := 2 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

signal MCLK_tb, RESET_tb, Kpress_tb: STD_LOGIC;
signal Kscan_tb: STD_LOGIC_VECTOR(1 downto 0);
signal Lin_tb, K_tb, Col_tb: STD_LOGIC_VECTOR(3 downto 0);
		 
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: KEY_SCAN port map(
		MCLK => MCLK_tb,
		RESET => RESET_tb,
		Kscan => Kscan_tb,
		Lin => Lin_tb,
		K => K_tb, 
		Kpress => Kpress_tb,
		Col => Col_tb ); 
		
	--Instantiate MCLK generator
	mclk_gen: process
	begin
		MCLK_tb <= '0';
		wait for MCLK_HALF_PERIOD;
		MCLK_tb <= '1';
		wait for MCLK_HALF_PERIOD;			
	end process;
		
	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 250ns
	stimulus: process
	begin
		
		-- Start values:
		RESET_tb <= '1'; -- Reset FF's current state
		Kscan_tb <= "00";
		wait for MCLK_HALF_PERIOD*8;
		
		-- Disable RESET
		RESET_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;			
		
	   -- 	 Key pad (4x4) key codes (K):
		--         														
		-- 	[0000] [0100]  [1000]  [1100] 
		--
		-- 	[0001] [0101] 	[1001]  [1101] 		
		--
		-- 	[0010] [0110] 	[1010]  [1110]      
		-- 
		-- 	[0011] [0111] 	[1011]  [1111] 
		
		
		
		-- [Test 1]: Check what key value is assigned to K (key code) when more than one key is pressed at the same time by the user	
		-- Expected output: K = 1010, because the code this key corresponds to, has priority over the others and Col was "1011" 
		-- (which corresponds to the third column) before the counter was disabled
		-- 
		-- Key pad:
		--
		--  COL(0)=1 COL(1)=1 COL(2)=0 COL(3)=1  
		--																Priority:
		-- 	[ ] 	  [ ]       [ ]      [ ] LIN(0)=1    Lowest  
		--
		-- 	[ ] 	  [ ] 		[X] 		[ ] LIN(1)=0		
		--
		-- 	[ ] 	  [ ] 		[X] 		[ ] LIN(2)=0      
		--
		-- 	[ ] 	  [ ] 		[ ] 		[ ] LIN(3)=1    Highest
		--						
		
		Kscan_tb <= "10"; -- Enables Counter (column search)
			wait for MCLK_HALF_PERIOD*8;
		Lin_tb <= "1001"; -- KPRESS = 1, which means a key was pressed
			wait for MCLK_HALF_PERIOD*2;
		Kscan_tb <= "01"; -- Enables Register Clock
			wait for MCLK_HALF_PERIOD*8;
		Kscan_tb <= "00";  
		Lin_tb <= "1111"; -- KPRESS = 0, which means the key is no longer pressed
			wait for MCLK_HALF_PERIOD*8;
		
		
		
		-- [Test 2]: Check what key value is assigned when a key is pressed by the user	
		-- Expected output: K = 0110	
		--
		-- Key pad:
		--
		--  COL(0)=1 COL(1)=0 COL(2)=1 COL(3)=1  
		--																Priority:
		-- 	[ ] 	  [ ]       [ ]      [ ] LIN(0)=1    Lowest  
		--
		-- 	[ ] 	  [ ] 		[ ] 		[ ] LIN(1)=1		
		--
		-- 	[ ] 	  [X] 		[ ] 		[ ] LIN(2)=0      
		--
		-- 	[ ] 	  [ ] 		[ ] 		[ ] LIN(3)=1    Highest
		--							
		
		Kscan_tb <= "10"; -- Enables Counter (column search)
			wait for MCLK_HALF_PERIOD*8;
		Lin_tb <= "1011"; -- KPRESS = 1, which means a key was pressed
			wait for MCLK_HALF_PERIOD*2;
		Kscan_tb <= "01"; -- Enables Register Clock
			wait for MCLK_HALF_PERIOD*8;
		Kscan_tb <= "00";  
		Lin_tb <= "1111"; -- KPRESS = 0, which means the key is no longer pressed
			wait for MCLK_HALF_PERIOD*8;
		
		wait; -- Disables stimulus generator instruction loop
		
	end process;

end;