library ieee;
use ieee.std_logic_1164.all;

package ControlUnitPkg is

  procedure fetch(  instruction:  std_logic_vector(31 downto 0);
                    comparison:   std_logic_vector(2 downto 0));
                    
  procedure saveToReg(  instruction:  std_logic_vector(31 downto 0);
                        comparison:   std_logic_vector(2 downto 0));

  procedure saveToMem(  instruction:  std_logic_vector(31 downto 0);
                        comparison:   std_logic_vector(2 downto 0));

end ControlUnitPkg;

package body ControlUnitPkg is

  procedure fetch(  instruction:  std_logic_vector(31 downto 0);
                    comparison:   std_logic_vector(2 downto 0)) is
  begin

    case instruction(6 downto 0) is
      when "0110011" => -- R-type
        case instruction(30) & instruction(14 downto 12) is
          when "0000" => -- add
          
          when "1000" => -- sub
          
          when "0001" => -- sll
          
          when "0010" => -- slt
          
          when "0011" => -- sltu
          
          when "0100" => -- xor
          
          when "0101" => -- srl
          
          when "1101" => -- sra
          
          when "0110" => -- or
          
          when "0111" => -- and
          
        end case;       
        
    end case;

  end procedure;
  
  procedure saveToReg(  instruction:  std_logic_vector(31 downto 0);
                        comparison:   std_logic_vector(2 downto 0)) is
  begin
  
  end procedure;
  
  procedure saveToMem(  instruction:  std_logic_vector(31 downto 0);
                        comparison:   std_logic_vector(2 downto 0)) is
  begin
  
  end procedure;

end ControlUnitPkg;