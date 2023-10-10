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

    variable microcode: std_logic_vector(23 downto 0);

  begin
    case instruction(6 downto 0) is
      when "0110011" => microcode := "000000110000001100001100"; -- R-type
      when "0110111" => microcode := "000001011011101000001100"; -- U-type lui
      when "0010111" => microcode := "000010000011001000000100"; -- U-type auipc
      when "1101111" => microcode := "000000000100000001000000"; -- J-type (jal)
      when "0000011" => -- I-type Loads
        case instruction(14 downto 12) is
          when "000"	=> microcode := "000001000000101000000001"; -- lb
          when "001"	=> microcode := "000001000000101000000011"; -- lh
          when "010"	=> microcode := "000001000000101000000101"; -- lw
          when "100"	=> microcode := "000001000000101000000000"; -- lbu
          when "101"	=> microcode := "000001000000101000000010"; -- lhu
          when others	=> microcode := (others => '0');
        end case;
      when "1100111" => microcode := "000000011000000010000100"; -- I-type jalr
      when "0010011" => microcode := "000000011000001000001100"; -- I-type
      when "0100011" => -- S-type
        case instruction(14 downto 12) is
          when "000"	=> microcode := "000000000010000000000100"; --sb
          when "001"	=> microcode := "000000000010000000000100"; --sh
          when "010"	=> microcode := "000000000010000000000100"; --sw
          when others	=> microcode := (others => '0');
        end case;
      when "1100011" => -- B-type
        case instruction(14 downto 12) is
          when "000" => -- beq
          	if (comparison = "000") then -- rs1 == rs2
          		microcode := "000001001001000101000100";
          	else -- rs1 != rs2
          		microcode := "000001001001000100000100";
          	end if;
          when "001" => -- bne
          	if (comparison = "000") then -- rs1 == rs2
          		microcode := "000001001001000100000100";
          	else -- rs1 != rs2
          		microcode := "000001001001000101000100";
          	end if;
          when "100" => -- blt
            if (comparison = "001") then -- rs1 < rs2
              microcode := "000001001001000001000100";
            else -- rs1 >= rs2
              microcode := "000001001001000000000100";
            end if;
          when "101" => -- bge
            if ((comparison = "010") or (comparison = "000")) then -- rs1 >= rs2
              microcode := "000001001001000001000100";
            else -- rs1 < rs2
              microcode := "000001001001000000000100";
            end if;
          when "110" => -- bltu
            if (comparison = "011") then -- u(rs1) < u(rs2)
              microcode := "000001001001000001000100";
            else -- u(rs1) >= u(rs2)
              microcode := "000001001001000000000100";
            end if;
          when "111" => -- bgeu
            if (comparison = "100") then -- u(rs1) >= u(rs2)
              microcode := "000001001001000001000100";
            else -- u(rs1) < u(rs2)
              microcode := "000001001001000000000100"; 
            end if;
        	when others	=> 
        	  microcode := (others => '0');
        end case;
      when "1110011" => -- ATOMIC INS.
      	case instruction(14 downto 12) is
      		when "001" => -- csrrw
      			microcode := "000000000000010000000000";
      		when "010" => -- csrrs
      			microcode := "001000000000010000000000";
      		when "011" => -- csrrc
      			microcode := "010000000000010000000000";
      		when "101" => -- csrrwi
      			microcode := "000100000101010000000000";
      		when "110" => -- csrrsi
      			microcode := "001100000101010000000000";
      		when "111" => -- csrrci
      			microcode := "010100000101010000000000";
      		when others	=> 
      		  microcode := (others => '0');
      	end case;
      when others	=> microcode := (others => '0');
    end case;
    return (microcode);
  end function decode;

end package body;