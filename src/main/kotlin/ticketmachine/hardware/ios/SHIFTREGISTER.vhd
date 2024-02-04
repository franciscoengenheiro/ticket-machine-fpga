library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SHIFTREGISTER is

	port( Sin, SCLK, EN, RESET: in STD_LOGIC;
         D: out STD_LOGIC_VECTOR(9 downto 0) );
		 
end SHIFTREGISTER;

architecture arq_SHIFTREGISTER of SHIFTREGISTER is

component FFD 

	port(	CLK, RESET, SET, D, EN: in STD_LOGIC;
		   Q: out STD_LOGIC );
		
end component;

signal s: STD_LOGIC_VECTOR(9 downto 0);

begin

	FFDET0: FFD port map (
		CLK => SCLK, 
		RESET => RESET,
		SET => '0',
		D => Sin,	
		EN => EN,
		Q => s(0) );
	
	FFDET1: FFD port map (
		CLK => SCLK, 
		RESET => RESET,
		SET => '0',
		D => s(0),	
		EN => EN,
		Q => s(1) );
	
	FFDET2: FFD port map (
		CLK => SCLK, 
		RESET => RESET,
		SET => '0',
		D => s(1),	
		EN => EN,
		Q => s(2) );
	
	FFDET3: FFD port map (
		CLK => SCLK, 
		RESET => RESET,
		SET => '0',
		D => s(2),	
		EN => EN,
		Q => s(3) );
		
	FFDET4: FFD port map (
		CLK => SCLK, 
		RESET => RESET,
		SET => '0',
		D => s(3),	
		EN => EN,
		Q => s(4) );
		
	FFDET5: FFD port map (
		CLK => SCLK, 
		RESET => RESET,
		SET => '0',
		D => s(4),	
		EN => EN,
		Q => s(5) );
	
	FFDET6: FFD port map (
		CLK => SCLK, 
		RESET => RESET,
		SET => '0',
		D => s(5),	
		EN => EN,
		Q => s(6) );
	
	FFDET7: FFD port map (
		CLK => SCLK, 
		RESET => RESET,
		SET => '0',
		D => s(6),	
		EN => EN,
		Q => s(7) );
	
	FFDET8: FFD port map (
		CLK => SCLK, 
		RESET => RESET,
		SET => '0',
		D => s(7),	
		EN => EN,
		Q => s(8) );
		
	FFDET9: FFD port map (
		CLK => SCLK, 
		RESET => RESET,
		SET => '0',
		D => s(8),	
		EN => EN,
		Q => s(9) );
	
	D <= s(0) & s(1) & s(2) & s(3) & s(4) & s(5) & s(6) & s(7) & s(8) & s(9); 

end arq_SHIFTREGISTER;
