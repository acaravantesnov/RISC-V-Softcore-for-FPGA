--******************************************************************************
--*
--* Name: ProgramCounter
--* Designer: Alberto Caravantes
--*
--* Component that saves the new memory address for the Instruction Memory.
--*	The address is made up of 32 bits. They are set to '0' when reset = '1'.
--*	If rising_edge of the clock and PCEn is '1', counter sets the current
--*	address to the next address.
--*
--******************************************************************************

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

  signal counter: std_logic_vector(31 downto 0) := (others => '0');

begin

  PC_DRIVER: process(clock, reset)
  begin
    if (reset = '1') then
      counter <= (others => '0');
    elsif ((rising_edge(clock)) and (PCEn = '1')) then
      counter <= nextAddress;
    end if;
  end process;
  
  currentAddress <= counter;

end ProgramCounter_ARCH;
