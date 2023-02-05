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

begin

  with ALUop
    select output <=  "0000"              when "00" -- lw or sw
                      "1000"              when "01" -- beq
                      ()                  when "10" -- R-type
                      (others => '0')     when others;

end ALUControl_ARCH;