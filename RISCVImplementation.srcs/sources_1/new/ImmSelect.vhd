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
                      B_type(input) when "01", --B-type
                      S_type(input) when "10", --S-type
                      (others => '0') when others;

end ImmSelect_ARCH;
