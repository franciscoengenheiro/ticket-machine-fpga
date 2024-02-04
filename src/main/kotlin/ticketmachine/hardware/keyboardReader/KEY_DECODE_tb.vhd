library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KEY_DECODE_tb is	
end KEY_DECODE_tb;

architecture behavior of KEY_DECODE_tb is 

-- Component Declaration for the Unit Under Test (UUT)
component KEY_DECODE 

	port( KACK, MCLK, RESET: in STD_LOGIC;
			LIN: in STD_LOGIC_VECTOR(3 downto 0);
			K, COL: out STD_LOGIC_VECTOR(3 downto 0);		
			KVAL: out STD_LOGIC );
		 
end component;

signal MCLK_tb, RESET_tb, KACK_tb, KVAL_tb, KSCAN_tb: STD_LOGIC;
signal LIN_tb, K_tb, COL_tb: STD_LOGIC_VECTOR(3 downto 0);

--UUT signals
constant MCLK_PERIOD: TIME := 2 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

begin 

	U1: KEY_DECODE port map(
		KACK => KACK_tb,
		MCLK => MCLK_tb,
		RESET => RESET_tb,
		LIN => LIN_tb,
		K => K_tb,
		COL => COL_tb,
		KVAL => KVAL_tb );
	
	-- Instantiate MCLK generator
	mclk_gen: process
	begin
		MCLK_tb <= '1';
		wait for MCLK_HALF_PERIOD;
		MCLK_tb <= '0';
		wait for MCLK_HALF_PERIOD;			
	end process;
	
	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 60ns
	stimulus: process
	begin
		
		-- Start values
		RESET_tb <= '1';
		Kack_tb  <= '0';				
			wait for MCLK_HALF_PERIOD*4;
		RESET_tb <= '0';
			wait for MCLK_HALF_PERIOD*4;
		
		
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
		-- Expected output: K = 0011, because the code this key corresponds to, has priority over the others and Col was "1110" 
		-- (which corresponds to the first column) at the time the line value was inserted
		--
		-- Key pad:
		--
		--  COL(0)=0 COL(1)=1 COL(2)=1 COL(3)=1  
		--																Priority:		-- 	[X] 	  [ ]       [ ]      [ ] LIN(0)=0    Lowest  
		--
		-- 	[ ] 	  [ ] 		[ ] 		[ ] LIN(1)=1		
		--
		-- 	[X] 	  [ ] 		[ ] 		[ ] LIN(2)=0      
		--
		-- 	[X] 	  [ ] 		[ ] 		[ ] LIN(3)=0    Highest
		--
		-- Note: Since CLK_DIV was introduced to KEY_SCAN module to lower key pad scanning frequency to 200Hz(0.01s), it's not possible to
		-- see more values, on the Altera Simulator, besides Col = "1110". The only way to test other columns is to disconnect CLK_DIV
		-- from KEY_SCAN module or the new key pad scanning frequency has to be closer to 50MHz(20ns) to be able to see the increment
		-- in the counter (current column) and introduce a new Line when wanted.

		Lin_tb <= "0010"; -- KPRESS = 1, which means a key was pressed
			wait for MCLK_HALF_PERIOD*4;
		Kack_tb <= '1';
			wait for MCLK_HALF_PERIOD*4;	
		Kack_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;
		Lin_tb <= "1111"; -- KPRESS = 0, which means the key is no longer pressed
			wait for MCLK_HALF_PERIOD*12; 
		
		
		
		-- [Test 2]: Check what key value is assigned when a key is pressed by the user	
		-- Expected output: K = 0001		
		--
		-- Key pad:
		--
		--  COL(0)=0 COL(1)=1 COL(2)=1 COL(3)=1  
		--																Priority:
		-- 	[ ] 	  [ ]       [ ]      [ ] LIN(0)=1    Lowest  
		--
		-- 	[X] 	  [ ] 		[ ] 		[ ] LIN(1)=0		
		--
		-- 	[ ] 	  [ ] 		[ ] 		[ ] LIN(2)=1      
		--
		-- 	[ ] 	  [ ] 		[ ] 		[ ] LIN(3)=1    Highest
		--							
		
		Lin_tb <= "1101"; -- KPRESS = 1, which means a key was pressed
			wait for MCLK_HALF_PERIOD*4;
		Kack_tb <= '1';
			wait for MCLK_HALF_PERIOD*4;	
		Kack_tb <= '0';	
			wait for MCLK_HALF_PERIOD*2;
		Lin_tb <= "1111"; -- KPRESS = 0, which means the key is no longer pressed
			wait for MCLK_HALF_PERIOD*4;
		
		wait; -- Disables stimulus generator instruction loop
		
	end process;


end;
