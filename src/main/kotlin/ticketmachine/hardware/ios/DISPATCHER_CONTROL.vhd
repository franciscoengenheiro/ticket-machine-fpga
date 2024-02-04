library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DISPATCHER_CONTROL is

	port( MCLK, Fsh, Dval, RESET, cFlag: in STD_LOGIC;
			Din: in STD_LOGIC_VECTOR (9 downto 0);
			Wrt, Wrl, done, resetC: out STD_LOGIC;
			Dout: out STD_LOGIC_VECTOR (8 downto 0) );
		 
end DISPATCHER_CONTROL;

architecture behavioral of DISPATCHER_CONTROL is

type STATE_TYPE is (STATE_RECEIVE, STATE_WRITE_TD, STATE_RST_COUNTER, STATE_WRITE_LCD, STATE_TICKET_EXIT, STATE_DONE);

signal currentState, NextState: STATE_TYPE;
signal Tnl: STD_LOGIC;

begin

-- Flip-Flop´s
CurrentState <= STATE_RECEIVE when RESET = '1' else NextState when rising_edge(MCLK);

--Generate Next State 
GenerateNextState:
process(currentState, Dval, Tnl, Fsh, cFlag)
	begin 
		case CurrentState is
			when STATE_RECEIVE			=> if (Dval = '1' and Tnl = '1') then
														NextState <= STATE_WRITE_TD;
													elsif (Dval = '1' and Tnl = '0') then
														NextState <= STATE_RST_COUNTER;
													else 
														NextState <= STATE_RECEIVE;
													end if;	
			
			when STATE_WRITE_TD		 	=> if (Fsh = '1') then
														NextState <= STATE_TICKET_EXIT;
													else 
														NextState <= STATE_WRITE_TD;
													end if;	
			
			when STATE_RST_COUNTER     => NextState <= STATE_WRITE_LCD;
									
			when STATE_WRITE_LCD			=> if (cFlag = '1') then 
														NextState <= STATE_DONE;
													else 
														NextState <= STATE_WRITE_LCD;
													end if;												
											
			when STATE_TICKET_EXIT 		=> if (Fsh = '0') then 
														NextState <= STATE_DONE;
													else 
														NextState <= STATE_TICKET_EXIT;
													end if;
											
			when STATE_DONE      		=> if (Dval = '0') then 
														NextState <= STATE_RECEIVE;
													else 
														NextState <= STATE_DONE;
													end if;
													
		end case;
	end process;
	
-- Generate inputs
Tnl <= Din(0);

-- Generate outputs
Wrt    <= '1' when (CurrentState = STATE_WRITE_TD) else '0';

Wrl    <= '1' when (CurrentState = STATE_WRITE_LCD) else '0';

resetC <= '1' when (CurrentState = STATE_RST_COUNTER) else '0';
			
done   <= '1' when (CurrentState = STATE_DONE) else '0';

Dout(8 downto 0) <= Din(9 downto 1);

end behavioral;