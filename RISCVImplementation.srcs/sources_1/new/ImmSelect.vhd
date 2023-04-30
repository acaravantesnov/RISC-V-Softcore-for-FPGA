--******************************************************************************
--*
--* Name: ImmSelect
--* Designer: Alberto Caravantes
--*
--* Component that given the immSel signal indicating an I-type, B-type or
--*	S-type instruction, it outputs the appropriate sign-extended 32-bit
--*	immValue.
--*
--*		IMMSEL				OUTPUT (IMMVALUE)
--*		00 (I-type)		Sign extend inst[31:20]
--*		01 (B-type)		Sign extend inst[31|7|30:25|11:8|'0']
--*		10 (S-type)		Sign extend inst[31:25|11:7]
--*		others				others => '0'
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use work.ImmSelectPkg.all;

entity ImmSelect is
  port (
    input:  in std_logic_vector(31 downto 0);
    immSel: in std_logic_vector(2 downto 0);
    output: out std_logic_vector(31 downto 0)
  );
end ImmSelect;

architecture ImmSelect_ARCH of ImmSelect is

begin

  with immSel
    select output <=  I_type(input) when "000", -- I-type
                      B_type(input) when "001", -- B-type
                      S_type(input) when "010", -- S-type
                      U_type(input) when "011", -- U-type
                      J_type(input) when "100", -- J-type
                      Atomic(input) when "101",	-- Atomic ins.
                      (others => '0') when others;

end ImmSelect_ARCH;