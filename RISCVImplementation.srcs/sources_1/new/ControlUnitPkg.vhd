--******************************************************************************
--*
--* Name: ControlUnitPkg
--* Designer: Alberto Caravantes
--*
--* 
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

package ControlUnitPkg is

  function decode(  instruction:  std_logic_vector(31 downto 0);
                    comparison:   std_logic_vector(2 downto 0))
                    return std_logic_vector;

  function saveToReg(  instruction:  std_logic_vector(31 downto 0);
                       comparison:   std_logic_vector(2 downto 0))
                       return std_logic_vector;

  function saveToMem(  instruction:  std_logic_vector(31 downto 0);
                       comparison:   std_logic_vector(2 downto 0))
                       return std_logic_vector;

end package;

package body ControlUnitPkg is
  
  function decode(  instruction:  std_logic_vector(31 downto 0);
                    comparison:   std_logic_vector(2 downto 0))
                    return std_logic_vector is
    variable microcode: std_logic_vector(15 downto 0);
  begin
    case instruction(6 downto 0) is
      when "0110011" => -- R-type
        microcode := "1100001100001100";
      when "0000011" => -- I-type Loads
        case instruction(14 downto 12) is
          when "000" => -- lb
            microcode := "";
          when "001" => -- lh
            microcode := "";
          when "010" => -- lw
            microcode := "";
          when "100" => -- lbu
            microcode := "";
          when "101" => -- lhu
            microcode := "";
        end case;
      when "0010011" => -- I-type
        microcode := "";
    end case;
    return (microcode);
  end function decode;
  
  function saveToReg(  instruction:  std_logic_vector(31 downto 0);
                       comparison:   std_logic_vector(2 downto 0))
                       return std_logic_vector is
  begin
  
  end function saveToReg;
  
  function saveToMem(  instruction:  std_logic_vector(31 downto 0);
                       comparison:   std_logic_vector(2 downto 0))
                       return std_logic_vector is
  begin
  
  end function saveToMem;

end package body;