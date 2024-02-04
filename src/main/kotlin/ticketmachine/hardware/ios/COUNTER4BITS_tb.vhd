library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COUNTER4BITS_tb is
end COUNTER4BITS_tb;

architecture behavior of COUNTER4BITS_tb is 

-- Component Declaration for the Unit Under Test (UUT)
component COUNTER4BITS

	port( CLR, SCLK, EN: in STD_LOGIC;
         O: out STD_LOGIC_VECTOR(3 downto 0) );
		 
end component;

--UUT signals
constant MCLK_PERIOD: TIME := 20 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

signal CLR_tb, SCLK_tb, EN_tb: STD_LOGIC;
signal O_tb: STD_LOGIC_VECTOR(3 downto 0);
		 
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: COUNTER4BITS port map(
		CLR => CLR_tb,
		SCLK => SCLK_tb,
		EN => EN_tb,
		O => O_tb );

	-- Instantiate CLK process
	clk_gen: process
	begin
		SCLK_tb <= '0';
		wait for MCLK_HALF_PERIOD;
		SCLK_tb <= '1';
		wait for MCLK_HALF_PERIOD;
	end process;
	
	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 540ns
	stimulus: process
	begin
		-- Clears Counter
		CLR_tb <= '1';
		EN_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- Disable clear
		CLR_tb <= '0';
		wait for MCLK_HALF_PERIOD*2*18;
		
		-- Stops Counter
		EN_tb <= '0';
		wait for MCLK_HALF_PERIOD*4;
		
		-- Resumes Counter
		EN_tb <= '1';
		wait for MCLK_HALF_PERIOD*8;
		
		-- Clears Counter
		CLR_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		wait; -- Disables stimulus generator instruction loop
	end process;

end;
