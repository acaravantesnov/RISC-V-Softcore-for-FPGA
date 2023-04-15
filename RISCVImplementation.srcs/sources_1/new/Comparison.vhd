--******************************************************************************
--*
--* Name: Comparison
--* Designer: Alberto Caravantes
--*
--* Component which compares values from 2 registers and outputs a 3-bit signal
--*	indicating the signed or unsigned comparison result.
--*
--*					r1 = r2		r1 < r2		r1 > r2		u(r1) < u(r2)		u(r1) >= u(r2)
--*		COMP	000				001				010				011							100
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Comparison is
  port(
  	instruction:	in std_logic_vector(31 downto 0);
    r1:         	in std_logic_vector(31 downto 0);
    r2:         	in std_logic_vector(31 downto 0);
    comparison: 	out std_logic_vector(2 downto 0)
  );
end Comparison;

architecture Comparison_ARCH of Comparison is

  function comparisonft(  instruction:	std_logic_vector(31 downto 0);
  												r1: 					std_logic_vector(31 downto 0);
                          r2: 					std_logic_vector(31 downto 0))
                          return std_logic_vector is
    variable comp: std_logic_vector(2 downto 0);
  begin
    
    if (signed(r1) = signed(r2)) then
      comp := "000";
    elsif (signed(r1) < signed(r2)) then
      comp := "001";
    elsif (signed(r1) > signed(r2)) then
      comp := "010";
    end if;
    if ((instruction(14 downto 12) = "110") or (instruction(14 downto 12) = "111")) then
    	if (unsigned(r1) < unsigned(r2)) then
      	comp := "011";
    	elsif ((unsigned(r1) > unsigned(r2)) or (unsigned(r1) = unsigned(r2))) then
      	comp := "100";
    	end if;
    end if;
    return (comp);
    
  end function comparisonft;

begin

  comparison <= comparisonft(instruction, r1, r2);

end Comparison_ARCH;