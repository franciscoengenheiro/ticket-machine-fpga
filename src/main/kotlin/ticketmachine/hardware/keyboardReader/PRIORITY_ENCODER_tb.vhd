library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PRIORITY_ENCODER_tb is
end PRIORITY_ENCODER_tb;

architecture behavior of PRIORITY_ENCODER_tb is 

-- Component Declaration for the Unit Under Test (UUT)
component PRIORITY_ENCODER 

	port( EN: in STD_LOGIC; 
			I: in STD_LOGIC_VECTOR(3 downto 0);
	      Y: out STD_LOGIC_VECTOR(1 downto 0);
			GS: out STD_LOGIC );

end component;

--UUT signals
constant MCLK_PERIOD: TIME := 20 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

signal EN_tb, GS_tb: STD_LOGIC;
signal I_tb: STD_LOGIC_VECTOR(3 downto 0);
signal Y_tb: STD_LOGIC_VECTOR(1 downto 0);
		 
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: PRIORITY_ENCODER port map (
		EN => EN_tb,
		I => I_tb,
		Y => Y_tb,
		GS => GS_tb );
		
	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 300ns
	stimulus: process
	begin
		
		-- Note: Highest Priority: I3
		--			 Lowest Priority: I0
		-- 
		EN_tb <= '1'; -- Enables Priority Enconder
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: GS = '1' | Y= "11" 
		I_tb <= "1011"; 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: GS = '1' | Y= "10"
		I_tb <= "0111"; 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: GS = '1' | Y= "01"
		I_tb <= "0011"; 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: GS = '1' | Y= "00"
		I_tb <= "0001"; 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: GS = '0' | Y= "XX"
		EN_tb <= '0'; -- Disables Priority Enconder
		I_tb <= "0000"; 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: GS = '1' | Y= "10"
		EN_tb <= '1'; -- Enables Priority Enconder
		I_tb <= "0101"; 
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: GS = '0' | Y= "00"
		I_tb <= "0000"; 
		wait for MCLK_HALF_PERIOD*2;
		
		wait; -- Disables stimulus generator instruction loop
		
	end process;

end;