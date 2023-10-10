library ieee;
use ieee.std_logic_1164.all;
use work.ImmSelectPkg.all;

entity ImmSelect is
  port (
    input:  in 	std_logic_vector(31 downto 0);
    immSel: in 	std_logic_vector(2 downto 0);
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