--******************************************************************************
--*
--* Name: StoreControl
--* Designer: Alberto Caravantes
--*
--*
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity StoreControl is
	port(
		input:				in std_logic_vector(31 downto 0);
		instruction:	in std_logic_vector(31 downto 0);
		output:				out std_logic_vector(31 downto 0)
	);
end StoreControl;

architecture StoreControl_ARCH of StoreControl is

	function storeft(	input:				std_logic_vector(31 downto 0);
										instruction:	std_logic_vector(31 downto 0))
										return std_logic_vector is
		variable vector:	std_logic_vector(31 downto 0) := (others => '0');
	begin
		if (instruction(6 downto 0) = "0100011") then 		-- Store Instruction
			if (instruction(14 downto 12) = "000") then 		-- sb
				vector(7 downto 0) := input(7 downto 0);
			elsif (instruction(14 downto 12) = "001") then	-- sh
				vector(15 downto 0) := input(15 downto 0);
			else
				vector := input;
			end if;
		end if;
		return (vector);
	end function;

begin

	output <= storeft(input, instruction);

end StoreControl_ARCH;