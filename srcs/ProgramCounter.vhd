library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ProgramCounter is
  port(
    nextAddress:    in std_logic_vector(31 downto 0);
    PCEn:           in std_logic;
    reset:          in std_logic;
    clock:          in std_logic;
    currentAddress: out std_logic_vector(31 downto 0)
  );
end ProgramCounter;

architecture ProgramCounter_ARCH of ProgramCounter is

  signal counter: std_logic_vector(31 downto 0);

begin

  PC_DRIVER: process(clock, reset)
  begin
    if (reset = '1') then
      counter <= (others => '0');
    elsif (rising_edge(clock)) then
    	if (PCEn = '1') then
      	counter <= nextAddress;
      end if;
    end if;
  end process;
  
  currentAddress <= counter;

end ProgramCounter_ARCH;
