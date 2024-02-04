library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KEY_CONTROL is

	port( MCLK, RESET, Kack, Kpress: in STD_LOGIC;
			Kval: out STD_LOGIC;
			Kscan: out STD_LOGIC_VECTOR(1 downto 0) );
		 
end KEY_CONTROL;

architecture behavioral of KEY_CONTROL is

type STATE_TYPE is (STATE_SCAN, STATE_KEY_VALID, STATE_VERIFIED);

signal currentState, NextState: STATE_TYPE; 

begin

-- Flip-Flop´s

CurrentState <= STATE_SCAN when RESET = '1' else NextState when rising_edge(MCLK);

-- Generate Next State 

GenerateNextState:
process(currentState, Kpress, Kack)
	begin 
		case CurrentState is
			when STATE_SCAN	   	=> if (Kpress = '1') then
													NextState <= STATE_KEY_VALID;
												else 
													NextState <= STATE_SCAN;
												end if;	
									
			when STATE_KEY_VALID 	=> if (Kack = '1') then
													NextState <= STATE_VERIFIED;
												else 
													NextState <= STATE_KEY_VALID;
												end if;			
			
			when STATE_VERIFIED		=> if (Kack = '0' and Kpress = '0') then
													NextState <= STATE_SCAN;
												else 
													NextState <= STATE_VERIFIED;
												end if;
 
		end case;
	end process;
	
-- Generate outputs
Kscan <= "10" when (CurrentState = STATE_SCAN) else "01" when (CurrentState = STATE_KEY_VALID) else "00";

Kval	<= '1' when (CurrentState = STATE_KEY_VALID) else '0';

end behavioral;