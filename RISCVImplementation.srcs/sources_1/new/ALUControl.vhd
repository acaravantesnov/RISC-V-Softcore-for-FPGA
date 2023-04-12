--******************************************************************************
--*
--* Name: ALUControl
--* Designer: Alberto Caravantes
--*
--* Component that given the ALUop signal indicationg a Load/ Store, beq, R-type
--*	or I-type instruction, and the input (made of 31 downto 25 and 14 downto 12
--*	of the 32-bit instruction), ot sets the appropriate output signal (control
--*	for ALU).
--*
--*		ALUOP		INPUT					OUTPUT	INSTRUCTION
--*		00			----------		0000		LW or SW
--*		01			----------		1000		BEQ
--*		10			0000000000		0000		ADD
--*						0100000000		1000		SUB
--*						0000000001		0001		SLL
--*						0000000010		0010		SLT
--*						0000000011		0011		SLTU
--*						0000000100		0100		XOR
--*						0000000101		0101		SRL
--*						0100000101		1101		SRA
--*						0000000110		0110		OR
--*						0000000111		0111		AND
--*		11			xxxxxxx000		0000		ADDI
--*						xxxxxxx010		0010		SLTI
--*						xxxxxxx011		0011		SLTIU
--*						xxxxxxx100		0100		XORI
--*						xxxxxxx110		0110		ORI
--*						xxxxxxx111		0111		ANDI
--*						0000000001		0001		SLLI
--*						0000000101		0101		SRLI
--*						0100000101		1101		SRAI
--*		others	----------		0000		LW or SW
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity ALUControl is
  port(
    input:  in std_logic_vector(9 downto 0);
    ALUop:  in std_logic_vector(1 downto 0);
    output: out std_logic_vector(3 downto 0)
  );
end ALUControl;

architecture ALUControl_ARCH of ALUControl is

  function R_type(  input: std_logic_vector(9 downto 0))
                    return std_logic_vector is
    variable output: std_logic_vector(3 downto 0);
  begin
  
    case input is
      when "0000000000" => output := "0000"; -- add
      when "0100000000" => output := "1000"; -- sub
      when "0000000001" => output := "0001"; -- sll
      when "0000000010" => output := "0010"; -- slt
      when "0000000011" => output := "0011"; -- sltu
      when "0000000100" => output := "0100"; -- xor
      when "0000000101" => output := "0101"; -- srl
      when "0100000101" => output := "1101"; -- sra
      when "0000000110" => output := "0110"; -- or
      when "0000000111" => output := "0111"; -- and
      when others				=> output := "0000";
    end case;
    
    return (output);
  end function R_type;
  
  function I_type(  input: std_logic_vector(9 downto 0))
                    return std_logic_vector is
    variable output: std_logic_vector(3 downto 0);
  begin
  
  	case input is
  		when "-------000" => output := "0000"; -- addi
      when "-------010" => output := "0010"; -- slti
      when "-------011" => output := "0011"; -- sltiu
      when "-------100" => output := "0100"; -- xori
      when "-------110" => output := "0110"; -- ori
      when "-------111" => output := "0111"; -- andi
      when "0000000001" => output := "0001"; -- slli
      when "0000000101" => output := "0101"; -- srli
      when "0100000101" => output := "1101"; -- srai
      when others				=> output := "0000";
  	end case;
    
    return (output);
  end function I_type;

begin

  with ALUop
    select output <=  "0000"                    when "00", -- lw or sw
                      "1000"                    when "01", -- B-type
                      R_type(input)             when "10", -- R-type
                      I_type(input)             when "11", -- I-type
                      (others => '0')           when others;

end ALUControl_ARCH;