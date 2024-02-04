	library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PARITY_CHECK_tb is
end PARITY_CHECK_tb;

architecture behavior of PARITY_CHECK_tb is 

-- Component Declaration for the Unit Under Test (UUT)

component PARITY_CHECK 

	port( DATA, SCLK, INIT: in STD_LOGIC;
         ERR: out STD_LOGIC);
		 
end component;

--UUT signals
constant MCLK_PERIOD: TIME := 20 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

signal DATA_tb, SCLK_tb, INIT_tb: STD_LOGIC;
signal ERR_tb, PB_tb: STD_LOGIC;
		 
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: PARITY_CHECK port map(
		DATA => DATA_tb,
		SCLK => SCLK_tb,
		INIT => INIT_tb,
		ERR => ERR_tb );

	-- Instantiate CLK process
	clk_gen: process
	begin
		SCLK_tb <= '0';
		wait for MCLK_HALF_PERIOD;
		SCLK_tb <= '1';
		wait for MCLK_HALF_PERIOD;
	end process;
	
	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 850ns
	stimulus: process
	begin
	
		-- Starting values
		INIT_tb <= '1';
		DATA_tb <= '0'; -- Doesn't enter
		wait for MCLK_HALF_PERIOD*4;
		
		
		
		-- [Test 1]: Frame to be inserted: [11010100100]
		-- Parity: Odd
		-- Expected output: ERR enabled (invalid frame)
		-- Begin 1st element read	
		INIT_tb <= '0';
		DATA_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 2nd element read
		DATA_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 3rd element read
		DATA_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 4th element read
		DATA_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 5th element read
		DATA_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 6th element read
		DATA_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 7th element read
		DATA_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 8th element read
		DATA_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 9th element read
		DATA_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 10th element read
		DATA_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 11th element read 
		DATA_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- **1st FRAME END** 
		INIT_tb <= '1';
		wait for MCLK_HALF_PERIOD*4; 
		
		
		
		-- [Test 2]: Frame to be inserted: [10011100101]
		-- Parity: Even
		-- Expected output: ERR disabled (valid frame)
		-- Begin 1st element read		
		INIT_tb <= '0';		
		DATA_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 2nd element read
		DATA_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 3rd element read
		DATA_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 4th element read
		DATA_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 5th element read
		DATA_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 6th element read
		DATA_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 7th element read
		DATA_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 8th element read
		DATA_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 9th element read
		DATA_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 10th element read
		DATA_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 11th element read 
		DATA_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- **2nd FRAME END** 
		INIT_tb <= '1';
		wait for MCLK_HALF_PERIOD*4; 
		
		
		
		-- [Test 3]: Frame to be inserted: [11010100100]
		-- Parity: Odd
		-- Expected output: ERR enabled (invalid frame)
		-- Begin 1st element read	
		INIT_tb <= '0';
		DATA_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 2nd element read
		DATA_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 3rd element read
		DATA_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 4th element read
		DATA_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 5th element read
		DATA_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
	
		-- 6th element read
		DATA_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 7th element read
		DATA_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 8th element read
		DATA_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 9th element read
		DATA_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 10th element read
		DATA_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 11th element read 
		DATA_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- **3rd FRAME END** 
		INIT_tb <= '1';
		wait for MCLK_HALF_PERIOD*4; 
		
		wait; -- Disables stimulus generator instruction loop

	end process;
	
end;
