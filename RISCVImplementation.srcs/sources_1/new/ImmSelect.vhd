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
    immSel: in std_logic_vector(1 downto 0);
    output: out std_logic_vector(31 downto 0)
  );
end ImmSelect;

architecture ImmSelect_ARCH of ImmSelect is

begin

  with immSel
    select output <=  I_type(input) when "00", -- I-type
                      B_type(input) when "01", -- B-type
                      S_type(input) when "10", -- S-type
                      (others => '0') when others;

end ImmSelect_ARCH;