--******************************************************************************
--*
--* Name: Comparison
--* Designer: Alberto Caravantes
--*
--* 
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity Comparison is
  port(
    r1:         in std_logic_vector(31 downto 0);
    r2:         in std_logic_vector(31 downto 0);
    comparison: out std_logic_vector(2 downto 0)
  );
end Comparison;

architecture Comparison_ARCH of Comparison is

  function comparisonft(  r1: std_logic_vector(31 downto 0);
                          r2: std_logic_vector(31 downto 0))
                          return std_logic_vector is
    variable comp: std_logic_vector(2 downto 0);
  begin
    
    return (comp);
  end function comparisonft;

begin

  comparison <= comparisonft(r1, r2);

end Comparison_ARCH;