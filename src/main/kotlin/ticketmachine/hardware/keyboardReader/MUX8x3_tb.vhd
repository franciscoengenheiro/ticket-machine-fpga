library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux8x3_tb is
end Mux8x3_tb;

architecture behavior of Mux8x3_tb is 

-- Component Declaration for the Unit Under Test (UUT)
component Mux8x3 

    port( A: in STD_LOGIC_VECTOR(7 downto 0);
          S: in STD_LOGIC_VECTOR(2 downto 0);
          O: out STD_LOGIC );

end component;

--UUT signals
constant MCLK_PERIOD: TIME := 20 ns;
constant MCLK_HALF_PERIOD: TIME := MCLK_PERIOD / 2;

signal O_tb: STD_LOGIC;
signal S_tb: STD_LOGIC_VECTOR(2 downto 0);
signal A_tb: STD_LOGIC_VECTOR(7 downto 0);
		 
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: Mux8x3 port map(
		A => A_tb,
      S => S_tb,
      O => O_tb );
	
	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 200ns
	stimulus: process
	begin
		
		A_tb <= "00110011"; -- Set data
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: A(0) = '1'
		S_tb <= "000";
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: A(1) = '1'
		S_tb <= "001";
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: A(2) = '0'
		S_tb <= "010";
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: A(3) = '0'
		S_tb <= "011";
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: A(4) = '1'
		S_tb <= "100";
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: A(5) = '1'
		S_tb <= "101";
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: A(6) = '0'
		S_tb <= "110";
		wait for MCLK_HALF_PERIOD*2;
		
		-- Expected Output: A(7) = '0'
		S_tb <= "111";
		wait for MCLK_HALF_PERIOD*2;
		
		wait; -- Disables stimulus generator instruction loop
	end process;

end;
