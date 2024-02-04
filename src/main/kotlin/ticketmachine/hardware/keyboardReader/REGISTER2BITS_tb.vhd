library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REGISTER2BITS_tb is
end REGISTER2BITS_tb;

architecture behavior of REGISTER2BITS_tb is 

-- Component Declaration for the Unit Under Test (UUT)
component REGISTER2BITS

	port( D: in STD_LOGIC_VECTOR(1 downto 0);
		   CLK, RESET, SET, EN: in STD_LOGIC;
         Q: out STD_LOGIC_VECTOR(1 downto 0) );
		 
end component;

--UUT signals
constant MCLK_PERIOD: TIME := 20 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

signal CLK_tb, RESET_tb, SET_tb, EN_tb: STD_LOGIC;
signal D_tb, Q_tb: STD_LOGIC_VECTOR(1 downto 0);
		 
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: REGISTER2BITS port map(
		D => D_tb,
		CLK => CLK_tb, 
		RESET => RESET_tb,
		SET => SET_tb,
		EN => EN_tb,
      Q => Q_tb );
	
	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 400ns
	stimulus: process
	begin
		
		RESET_tb <= '1'; -- Resets Register
		SET_tb <= '0'; -- Disables Set Register
		EN_tb <= '1'; -- Enables Register
		CLK_tb <= '0'; -- Clock starts with value zero
		wait for MCLK_HALF_PERIOD*4;
		
		RESET_tb <= '0'; -- Resets Register
		wait for MCLK_HALF_PERIOD*4;
		
		-- Expected Output: Q = "10" 
		D_tb <= "10"; -- Sets Data value
			wait for MCLK_HALF_PERIOD*2;
			CLK_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;	 	
			CLK_tb <= '0';	
		
		-- Expected Output: Q = "01"
		D_tb <= "01"; -- Sets Data value
			wait for MCLK_HALF_PERIOD*2;
			CLK_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;	 	
			CLK_tb <= '0';	
			
		EN_tb <= '0'; -- Disables Register
		wait for MCLK_HALF_PERIOD*2;	
		
		-- Expected Output: No output
		D_tb <= "10"; -- Sets Data value
			wait for MCLK_HALF_PERIOD*2;
			CLK_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;	 	
			CLK_tb <= '0';		
			
		EN_tb <= '1'; -- Enables Register
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: Q = "11" 
		SET_tb <= '1'; -- Sets output with logical value '1'
			wait for MCLK_HALF_PERIOD*2;
			CLK_tb <= '1'; 
			wait for MCLK_HALF_PERIOD*2;	 	
			CLK_tb <= '0';	
		
		wait; -- Disables stimulus generator instruction loop
	end process;

end;