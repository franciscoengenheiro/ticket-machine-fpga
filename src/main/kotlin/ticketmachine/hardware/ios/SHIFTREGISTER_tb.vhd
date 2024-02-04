library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SHIFTREGISTER_tb is
end SHIFTREGISTER_tb;

architecture behavior of SHIFTREGISTER_tb is 

-- Component Declaration for the Unit Under Test (UUT)
component SHIFTREGISTER 

	port( Sin, SCLK, EN, RESET: in STD_LOGIC;
         D: out STD_LOGIC_VECTOR(9 downto 0) );
		 
end component;

--UUT signals
constant MCLK_PERIOD: TIME := 20 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

signal Sin_tb, SCLK_tb, EN_tb, RESET_tb: STD_LOGIC;
signal D_tb: STD_LOGIC_VECTOR(9 downto 0);
	
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: SHIFTREGISTER port map(
		Sin => Sin_tb,
		SCLK => SCLK_tb,
		EN => EN_tb,
		RESET => RESET_tb,
		D => D_tb );
		 
	-- Instantiate CLK process
	clk_gen: process
	begin
		SCLK_tb <= '0';
		wait for MCLK_HALF_PERIOD;
		SCLK_tb <= '1';
		wait for MCLK_HALF_PERIOD;
	end process;
		
	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 250ns
	stimulus: process
	begin
		-- Read disabled
		Sin_tb <= '1';
		EN_tb <= '0';
		RESET_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- Test: Frame to be inserted: [0010010101]
		-- Expected output: [0010010101]
		-- Begin 1st element read
		RESET_tb <= '0';
		EN_tb <='1';
		Sin_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 2nd element read
		Sin_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 3rd element read
		Sin_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 4th element read
		Sin_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 5th element read
		Sin_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 6th element read
		Sin_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 7th element read
		Sin_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 8th element read
		Sin_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 9th element read
		Sin_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 10th element read
		Sin_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- Read disabled
		EN_tb <= '0';
		wait; -- Disables stimulus generator instruction loop
		
		-- This data should not alter the previous inserted frame
		-- Begin 1st element read
		Sin_tb <= '0';
		EN_tb <='1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- 2nd element read
		Sin_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
	end process;

end;
