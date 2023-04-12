--******************************************************************************
--*
--* Name: ImmSelectPkg
--* Designer: Alberto Caravantes
--*
--* 
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

package ImmSelectPkg is

  function I_type(  input: std_logic_vector(31 downto 0))
                    return std_logic_vector;
                    
  function B_or_S_type(  input: std_logic_vector(31 downto 0))
                    return std_logic_vector;

end package;

package body ImmSelectPkg is

  function I_type(  input: std_logic_vector(31 downto 0))
                    return std_logic_vector is
    variable ImmValue: std_logic_vector(31 downto 0) := (others => input(31));
  begin
    ImmValue(11 downto 0) := input(31 downto 20);
    return ImmValue;
  end function;

  function B_or_S_type(  input: std_logic_vector(31 downto 0))
                    return std_logic_vector is
    variable ImmValue: std_logic_vector(31 downto 0) := (others => input(31));
  begin
    ImmValue(11 downto 5) := input(31 downto 25);
    ImmValue(4 downto 0) := input(11 downto 7);
    return (ImmValue);
  end function;

end package body;
