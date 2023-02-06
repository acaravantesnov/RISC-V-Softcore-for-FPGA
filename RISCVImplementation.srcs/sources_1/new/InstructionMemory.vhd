library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BasicPkg.all;

entity InstructionMemory is
  port(
    readAddress: in std_logic_vector(31 downto 0);
    instruction: out std_logic_vector(31 downto 0)
  );
end InstructionMemory;

architecture InstructionMemory_ARCH of InstructionMemory is
  type ram_type is array(0 to (RAM_SIZE) - 1) of std_logic_vector(7 downto 0);
  signal ram: ram_type := (
    (others => X"00")
  );
begin
  instruction <= ram(to_integer(unsigned(readAddress)));
end InstructionMemory_ARCH;