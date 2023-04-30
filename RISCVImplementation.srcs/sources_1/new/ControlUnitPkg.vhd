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
    variable microcode: std_logic_vector(22 downto 0);
  begin
    case instruction(6 downto 0) is
      when "0110011" => microcode := "00000011000000110001100"; -- R-type
      when "0110111" => microcode := "00000001101100100001100"; -- U-type lui
      when "0010111" => microcode := "00001000001100100000100"; -- U-type auipc
      when "1101111" => microcode := "00000000010000000100000"; -- J-type (jal)
      when "0000011" => -- I-type Loads
        case instruction(14 downto 12) is
          when "000"	=> microcode := "00000000000000100000001"; -- lb
          when "001"	=> microcode := "00000000000000100000011"; -- lh
          when "010"	=> microcode := "00000000000000100000101"; -- lw
          when "100"	=> microcode := "00000000000000100000000"; -- lbu
          when "101"	=> microcode := "00000000000000100000010"; -- lhu
          when others	=> microcode := (others => 'X');
        end case;
      when "1100111" => microcode := "00000001100000001000100"; -- I-type jalr
      when "0010011" => microcode := "00000001100000100001100"; -- I-type
      when "0100011" => -- S-type
        case instruction(14 downto 12) is
          when "000"	=> microcode := "00000000001000000000100"; --sb
          when "001"	=> microcode := "00000000001000000000100"; --sh
          when "010"	=> microcode := "00000000001000000000100"; --sw
          when others	=> microcode := (others => 'X');
        end case;
      when "1100011" => -- B-type
        case instruction(14 downto 12) is
          when "000" => -- beq
          	if (comparison = "000") then -- rs1 == rs2
          		microcode := "00000000100100010100100";
          	else -- rs1 != rs2
          		microcode := "00000000100100010000100";
          	end if;
          when "001" => -- bne
          	if (comparison = "000") then -- rs1 == rs2
          		microcode := "00000000100100010000100";
          	else -- rs1 != rs2
          		microcode := "00000000100100010100100";
          	end if;
          when "100" => -- blt
            if (comparison = "001") then -- rs1 < rs2
              microcode := "00000000100100000100100";
            else -- rs1 >= rs2
              microcode := "00000000100100000000100";
            end if;
          when "101" => -- bge
            if ((comparison = "010") or (comparison = "000")) then -- rs1 >= rs2
              microcode := "00000000100100000100100";
            else -- rs1 < rs2
              microcode := "00000000100100000000100";
            end if;
          when "110" => -- bltu
            if (comparison = "011") then -- u(rs1) < u(rs2)
              microcode := "00000000100100000100100";
            else -- u(rs1) >= u(rs2)
              microcode := "00000000100100000000100";
            end if;
          when "111" => -- bgeu
            if (comparison = "100") then -- u(rs1) >= u(rs2)
              microcode := "00000000100100000100100";
            else -- u(rs1) < u(rs2)
              microcode := "00000000100100000000100"; 
            end if;
        	when others	=> microcode := (others => 'X');
        end case;
      when "1110011" => -- ATOMIC INS.
      	case instruction(14 downto 12) is
      		when "001" => -- csrrw
      			microcode := "00000000000001000000000";
      		when "010" => -- csrrs
      			microcode := "00100000000001000000000";
      		when "011" => -- csrrc
      			microcode := "01000000000001000000000";
      		when "101" => -- csrrwi
      			microcode := "00010000010101000000000";
      		when "110" => -- csrrsi
      			microcode := "00110000010101000000000";
      		when "111" => -- csrrci
      			microcode := "01010000010101000000000";
      		when others	=> microcode := (others => 'X');
      	end case;
      when others	=> microcode := (others => 'X');
    end case;
    return (microcode);
  end function decode;

end package body;