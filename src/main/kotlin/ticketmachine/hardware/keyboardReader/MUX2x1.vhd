library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Mux 2x1 for 2 Bit vectors
entity MUx2x1 is

    port( A, B: in STD_LOGIC_VECTOR(1 downto 0);
          S: in STD_LOGIC;
          O: out STD_LOGIC_VECTOR (1 downto 0) );

end MUx2x1;

architecture arq_MUx2x1 of MUx2x1 is

begin

   O(0) <= (not S and A(0)) or (S and B(0));
	O(1) <= (not S and A(1)) or (S and B(1));

end arq_MUx2x1;