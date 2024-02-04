library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KEY_TRANSMITTER_CONTROL is

	port( MCLK, RESET, DAV, Cflag: in STD_LOGIC;
			ENR, RESET_C, ENC, DAC, TXD_INIT: out STD_LOGIC ); 
		 
end KEY_TRANSMITTER_CONTROL;

architecture behavioral of KEY_TRANSMITTER_CONTROL is

type STATE_TYPE is (STATE_IDLE, STATE_ACK, STATE_SEND);

signal currentState, NextState: STATE_TYPE; 

begin

-- Flip-Flop´s
CurrentState <= STATE_IDLE when RESET = '1' else NextState when rising_edge(MCLK);

-- Generate Next State 
GenerateNextState:
process(currentState, DAV, Cflag)
	begin 
		case CurrentState is
			when STATE_IDLE	=> if (DAV = '1') then
												NextState <= STATE_ACK;
											else 
												NextState <= STATE_IDLE;
											end if;	
	
			when STATE_ACK		=> if (DAV = '0') then
												NextState <= STATE_SEND;
											else 
												NextState <= STATE_ACK;
											end if;
									
			when STATE_SEND	=> if (CFlag = '1') then
												NextState <= STATE_IDLE;
											else 
												NextState <= STATE_SEND;
											end if;			
			
		end case;
	end process;
	
-- Generate outputs:
-- Enables Register Clock
ENR <= '1' when (CurrentState = STATE_ACK) else '0';

-- RESETS Counter
RESET_C <= '1' when (CurrentState = STATE_IDLE) else '0';

-- Key was Acknowledge 
DAC <= '1' when (CurrentState = STATE_ACK) else '0';

-- Default TXD value / Init TXD bit  
TXD_INIT <= '0' when (CurrentState = STATE_SEND) else '1';

-- Enables Counter
ENC <= '1' when (CurrentState = STATE_SEND) else '0';

end behavioral;