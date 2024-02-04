library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux2x1_tb is
end Mux2x1_tb;

architecture behavior of Mux2x1_tb is 

-- Component Declaration for the Unit Under Test (UUT)
component MUx2x1 

    port( A, B: in STD_LOGIC_VECTOR(1 downto 0);
          S: in STD_LOGIC;
          O: out STD_LOGIC_VECTOR (1 downto 0) );

end component;

--UUT signals
constant MCLK_PERIOD: TIME := 20 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

signal S_tb: STD_LOGIC;
signal A_tb, B_tb, O_tb: STD_LOGIC_VECTOR(1 downto 0);
		 
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: MUx2x1 port map(
		A => A_tb,
		B => B_tb,
      S => S_tb,
      O => O_tb );
	
	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 200ns
	stimulus: process
	begin
		
		A_tb <= "01"; -- Set A data
		B_tb <= "10"; -- Set B data
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: O = "01"
		S_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: O = "10"
		S_tb <= '1';
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: O = "01"
		S_tb <= '0';
		wait for MCLK_HALF_PERIOD*2;
		
		wait; -- Disables stimulus generator instruction loop
	end process;

end;
