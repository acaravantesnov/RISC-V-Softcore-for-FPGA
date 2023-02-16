library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BasicPkg.all;

entity ControlUnit is
  port(
    instruction:  in  std_logic_vector(31 downto 0);
    comparison:   in  std_logic_vector(2 downto 0);
    reset:        in  std_logic;
    clock:        in  std_logic;
    microcode:    out std_logic_vector(9 downto 0)
  );
end ControlUnit;

architecture ControlUnit_ARCH of ControlUnit is

begin

end ControlUnit_ARCH;
