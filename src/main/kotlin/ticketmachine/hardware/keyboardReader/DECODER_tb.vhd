library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DECODER_tb is
end DECODER_tb;

architecture behavior of DECODER_tb is 

-- Component Declaration for the Unit Under Test (UUT)
component DECODER 

	port( EN: in STD_LOGIC;  
			S: in STD_LOGIC_VECTOR(1 downto 0);  
	      O: out STD_LOGIC_VECTOR(3 downto 0) );

end component;

--UUT signals
constant MCLK_PERIOD: TIME := 20 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

signal EN_tb: STD_LOGIC;
signal S_tb: STD_LOGIC_VECTOR(1 downto 0);
signal O_tb: STD_LOGIC_VECTOR(3 downto 0);
		 
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: DECODER port map(
		EN => EN_tb,
		S => S_tb,
		O => O_tb );
	
	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 200ns
	stimulus: process
	begin
	
		EN_tb <= '1'; -- Enables Decoder
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: O(0) 
		S_tb <= "00"; 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: O(1) 
		S_tb <= "01"; 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: No output
		EN_tb <= '0'; -- Disables Decoder
		S_tb <= "10"; 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: O(2) 
		EN_tb <= '1'; -- Enables Decoder
		S_tb <= "10"; 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: O(3) 
		S_tb <= "11"; 
		wait for MCLK_HALF_PERIOD*2;
		
		wait; -- Disables stimulus generator instruction loop
	end process;

end;
