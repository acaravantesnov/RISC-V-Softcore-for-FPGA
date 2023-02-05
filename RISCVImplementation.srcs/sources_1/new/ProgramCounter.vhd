library ieee;
use ieee.std_logic_1164.all;

entity ProgramCounter is
  port(
    nextAddress:    in std_logic_vector(31 downto 0);
    clock:          in std_logic;
    currentAddress: out std_logic_vector(31 downto 0)
  );
end ProgramCounter;

architecture ProgramCounter_ARCH of ProgramCounter is

  signal counter: std_logic_vector(31 downto 0) := (others => '0');

begin

  PC_DRIVER: process(clock)
  begin
    if (rising_edge(clock)) then
      counter <= nextAddress;
    end if;
  end process;
  
  currentAddress <= counter;

end ProgramCounter_ARCH;
