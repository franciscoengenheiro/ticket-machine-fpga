library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SERIAL_CONTROL is

	port( nSS, accept, dFlag, pFlag, RXerror, MCLK, RESET: in STD_LOGIC;
			wr, init, DXval, busy: out STD_LOGIC );
		 
end SERIAL_CONTROL;

architecture behavioral of SERIAL_CONTROL is

type STATE_TYPE is (STATE_INIT, STATE_WRITE, STATE_OFF, STATE_BUSY, STATE_WAIT);

signal currentState, NextState: STATE_TYPE;

begin

-- Flip-Flop´s
CurrentState <= STATE_INIT when RESET = '1' else NextState when rising_edge(MCLK);

-- Generate Next State 
GenerateNextState:
process(currentState, nSS, dFlag, pFlag, RXerror, accept)
	begin 
		case CurrentState is
			when STATE_INIT	=> if (nSS = '0') then
											NextState <= STATE_WRITE;
										else 
											NextState <= STATE_INIT;
										end if;	
									
		   when STATE_WRITE  => if (nSS = '1') then
											NextState <= STATE_INIT;	
										elsif (nSS = '0' and dFlag = '1') then 
											NextState <= STATE_OFF;
										else 
											NextState <= STATE_WRITE;
										end if;	
			
		   when STATE_OFF		=> if (nSS = '1' and pFlag = '0') then
											NextState <= STATE_INIT;
										elsif (nSS = '1' and pFlag = '1' and RXerror = '1') then 
											NextState <= STATE_INIT;
										elsif (nSS = '1' and pFlag = '1' and RXerror = '0') then 
											NextState <= STATE_BUSY;
										else 
											NextState <= STATE_OFF;
										end if;
										
		   when STATE_BUSY   => if (accept = '1') then
											NextState <= STATE_WAIT;
										else 
											NextState <= STATE_BUSY;
										end if;	

			when STATE_WAIT   => if (accept = '0') then
											NextState <= STATE_INIT;
										else 
											NextState <= STATE_WAIT;
										end if;	
											
		end case;
	end process;

-- Generate outputs
init <= '1' when (CurrentState = STATE_INIT) else '0';

wr	<= '1' when (CurrentState = STATE_WRITE) else '0';
			
DXval <= '1' when (CurrentState = STATE_BUSY) else '0';

busy  <= '1' when (CurrentState = STATE_BUSY) else '0';  

end behavioral;