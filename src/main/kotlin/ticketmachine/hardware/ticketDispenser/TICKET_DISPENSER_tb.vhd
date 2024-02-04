library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TICKET_DISPENSER_tb is
end TICKET_DISPENSER_tb;

architecture behavior of TICKET_DISPENSER_tb is 

-- Component Declaration for the Unit Under Test (UUT)
component TICKET_DISPENSER

	port ( Prt, CollectTicket: in STD_LOGIC;
			 Dout: in STD_LOGIC_VECTOR(8 downto 0);
			 Fn: out STD_LOGIC;
			 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out STD_LOGIC_VECTOR(7 downto 0) );
			
end component;

--UUT signals
constant DELAY: TIME := 10 ns;

signal Prt_tb, CollecTicket_tb, Fn_tb: STD_LOGIC;
signal Dout_tb: STD_LOGIC_VECTOR(8 downto 0);
signal HEX0_tb, HEX1_tb, HEX2_tb, HEX3_tb, HEX4_tb, HEX5_tb, HEX6_tb: STD_LOGIC_VECTOR(7 downto 0);
		 
begin

	-- Instantiate the Unit Under Test (UUT)
	UUT: TICKET_DISPENSER port map(
		Prt => Prt_tb,
		CollectTicket => CollecTicket_tb,
		Dout => Dout_tb,
		Fn => Fn_tb,
		HEX0 => HEX0_tb,
		HEX1 => HEX1_tb,
		HEX2 => HEX2_tb,
		HEX3 => HEX3_tb, 
		HEX4 => HEX4_tb, 
		HEX5 => HEX5_tb );

	-- Instantiate Stimulus process
	-- ModelSim Run-Length: 150ns
	stimulus: process
	begin
		
		-- Start values
		CollecTicket_tb <= '0'; -- Last printed ticket was collected
		Prt_tb <= '0'; -- Ticket Dispenser hasn't received confirmation to print a ticket
		wait for DELAY*2;
		
		
		
		-- [Test 1]: Print a ticket with specific data
		-- Frame to be received: [101000010]
		-- Expected Output: [b0oAd1]
		-- Means: "bilhete de ida e volta, da estação de origem com o código (0001) para a estação de destino com o código (1010)"
		dout_tb <= "101000010";
		Prt_tb <= '1'; -- Ticket Dispenser has received confirmation to print a ticket
		wait for DELAY;
		
		CollecTicket_tb <= '1'; -- Ticket ready to be collected
		wait for DELAY;
		
		CollecTicket_tb <= '0'; -- Client retrieved the ticket
		wait for DELAY;
		
		Prt_tb <= '0'; -- Ticket Dispenser hasn't received confirmation to print a ticket
		wait for DELAY;
		
		
		
		-- [Test 2]: Print a ticket with specific data
		-- Frame to be received: [010011001]
		-- Expected Output: [b1o4dC]
		-- Means: "bilhete de ida, da estação de origem com o código (0100) para a estação de destino com o código (1100)"
		dout_tb <= "010011001";
		Prt_tb <= '1'; -- Ticket Dispenser has received confirmation to print a ticket
		wait for DELAY;
		
		CollecTicket_tb <= '1'; -- Ticket ready to be collected
		wait for DELAY;
		
		CollecTicket_tb <= '0'; -- Client retrieved the ticket
		wait for DELAY;

		wait; -- Disables stimulus generator instruction loop
		
	end process;

end;