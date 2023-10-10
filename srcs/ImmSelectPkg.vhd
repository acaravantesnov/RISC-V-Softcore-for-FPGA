library ieee;
use ieee.std_logic_1164.all;

package ImmSelectPkg is

  function I_type(  input: std_logic_vector(31 downto 0))
                    return std_logic_vector;
                    
  function B_type(  input: std_logic_vector(31 downto 0))
                    return std_logic_vector;
                    
  function S_type(  input: std_logic_vector(31 downto 0))
                    return std_logic_vector;
                    
  function U_type(  input: std_logic_vector(31 downto 0))
                    return std_logic_vector;
                    
  function J_type(  input: std_logic_vector(31 downto 0))
                    return std_logic_vector;

	function Atomic(  input: std_logic_vector(31 downto 0))
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

  function B_type(  input: std_logic_vector(31 downto 0))
                    return std_logic_vector is
    variable ImmValue: std_logic_vector(31 downto 0) := (others => input(31));
  begin
    ImmValue(11) := input(7);
    ImmValue(10 downto 5) := input(30 downto 25);
    ImmValue(4 downto 1) := input(11 downto 8);
    ImmValue(0) := '0';
    return (ImmValue);
  end function;

  function S_type(  input:std_logic_vector(31 downto 0))
                    return std_logic_vector is
    variable ImmValue: std_logic_vector(31 downto 0) := (others => input(31));
  begin
    ImmValue(11 downto 5) := input(31 downto 25);
    ImmValue(4 downto 0) := input(11 downto 7);
    return (ImmValue);
  end function;
  
  function U_type(  input: std_logic_vector(31 downto 0))
                    return std_logic_vector is
    variable ImmValue: std_logic_vector(31 downto 0) := (others => '0');
  begin
    ImmValue(31 downto 12) := input(31 downto 12);
    return ImmValue;
  end function;
  
  function J_type(  input: std_logic_vector(31 downto 0))
                    return std_logic_vector is
    variable ImmValue: std_logic_vector(31 downto 0) := (others => '0');
  begin
    ImmValue(31 downto 20) := (others => input(31));
    ImmValue(19 downto 12) := input(19 downto 12);
    ImmValue(11) := input(20);
    ImmValue(10 downto 1) := input(30 downto 21);
    return ImmValue;
  end function;

  function Atomic(  input: std_logic_vector(31 downto 0))
                    return std_logic_vector is
  	variable ImmValue: std_logic_vector(31 downto 0) := (others => '0');
  begin
  	ImmValue(4 downto 0) := input(19 downto 15);
  	return ImmValue;
  end function;

end package body;
