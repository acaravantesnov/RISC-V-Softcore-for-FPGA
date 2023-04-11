--******************************************************************************
--*
--* Name: ControlUnitPkg
--* Designer: Alberto Caravantes
--*
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

package ControlUnitPkg is

  function decode(  instruction:  std_logic_vector(31 downto 0);
                    comparison:   std_logic_vector(2 downto 0))
                    return std_logic_vector;

end package;

package body ControlUnitPkg is
  
  function decode(  instruction:  std_logic_vector(31 downto 0);
                    comparison:   std_logic_vector(2 downto 0))
                    return std_logic_vector is
    variable microcode: std_logic_vector(16 downto 0);
  begin
    case instruction(6 downto 0) is
      when "0110011" => microcode := "01100001100001100"; -- R-type
      when "0000011" => -- I-type Loads
        case instruction(14 downto 12) is
          when "000"	=> microcode := "00000001000000001"; -- lb
          when "001"	=> microcode := "00000001000000011"; -- lh
          when "010"	=> microcode := "00000001000000101"; -- lw
          when "100"	=> microcode := "00000001000000000"; -- lbu
          when "101"	=> microcode := "00000001000000010"; -- lhu
          when others	=> microcode := (others => 'X');
        end case;
      when "1100111" => microcode := "00110000010000100"; -- I-type jalr
      when "0010011" => microcode := "00110001000001100"; -- I-type
      when "0100011" => -- S-type
        case instruction(14 downto 12) is
          when "000"	=> microcode := "00001000000000100"; --sb
          when "001"	=> microcode := "00001000000000100"; --sh
          when "010"	=> microcode := "00001000000000100"; --sw
          when others	=> microcode := (others => 'X');
        end case;
      when "1100011" => -- B-type
        case instruction(14 downto 12) is
          when "000" => -- beq
          	if (comparison = "000") then
          		microcode := "00010100101100100";
          	else
          		microcode := "00010100101000100";
          	end if;
          when "001" => -- bne
          	if (comparison = "000") then
          		microcode := "00010100101000100";
          	else
          		microcode := "00010100101100100";
          	end if;
          when "100" => -- blt
            if (comparison = "001") then
              microcode := "00010100000100100";
            else
              microcode := "00010100000000100";
            end if;
          when "101" => -- bge
            if ((comparison = "010") or (comparison = "000")) then
              microcode := "00010100000100100";
            else
              microcode := "00010100000000100";
            end if;
          when "110" => -- bltu
            if (comparison = "011") then
              microcode := "00010100000100100";
            else
              microcode := "00010100000000100";
            end if;
          when "111" => -- bgeu
            if (comparison = "100") then
              microcode := "00010100000100100";
            else
              microcode := "00010100000000100"; 
            end if;
        	when others	=> microcode := (others => 'X');
        end case;
      when others	=> microcode := (others => 'X');
    end case;
    return (microcode);
  end function decode;

end package body;