library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- This Counter was modified to only count 0-2, essentially a mod 3 Counter
entity COUNTER_MOD3 is

	port( CLR, SCLK, EN: in STD_LOGIC;
         O: out STD_LOGIC_VECTOR(1 downto 0) );
		 
end COUNTER_MOD3;

architecture arq_COUNTER_MOD3 of COUNTER_MOD3 is

component SUM2BITS 

	port( A, B: in STD_LOGIC_VECTOR(1 downto 0);
	      Cin: in STD_LOGIC;
		   S: out STD_LOGIC_VECTOR(1 downto 0);
         Cout: out STD_LOGIC );
		 
end component;

component MUx2x1 

    port( A, B: in STD_LOGIC_VECTOR(1 downto 0);
          S: in STD_LOGIC;
          O: out STD_LOGIC_VECTOR (1 downto 0) );

end component;

component REGISTER2BITS 

	port( D: in STD_LOGIC_VECTOR(1 downto 0);
		   CLK, RESET, SET, EN: in STD_LOGIC;
         Q: out STD_LOGIC_VECTOR(1 downto 0) );
		 
end component;

signal STOP_LINK: STD_LOGIC;
signal S_LINK, O_LINK, R_LINK: STD_LOGIC_VECTOR(1 downto 0);

begin

	M0: SUM2BITS port map( 
		A => "00", -- Default value
		B => R_LINK, -- Value from Register
		Cin => '1', -- Enables sum concatenation 
		S => S_LINK ); 
		
	-- Active flag when counter equals to 3 (11)
	STOP_LINK <= S_LINK(1) and S_LINK(0);
		
	M1: Mux2x1 port map (
		A => S_LINK, -- Output from 2 bits sum
		B => "00", -- Value used when active flag is active to reset counter 
      S => STOP_LINK, 
      O => O_LINK );
	
	M2: REGISTER2BITS port map(
		D => O_LINK, -- Output from Multiplexer exit
	   CLK => SCLK,
		RESET => CLR,
		SET => '0',
		EN => EN,
	   Q => R_LINK );
		
	-- Final output
	O <= R_LINK;
	
end arq_COUNTER_MOD3;
