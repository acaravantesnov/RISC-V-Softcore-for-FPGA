library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.basic.all;

entity DataMemory is
  port(
    memWriteEn: in std_logic;
    address:    in std_logic_vector(31 downto 0);
    dataIn:     in std_logic_vector(31 downto 0);
    clock:      in std_logic;
    dataOut:    out std_logic_vector(31 downto 0)
  );
end DataMemory;

architecture DataMemory_ARCH of DataMemory is

  type ram_type is array(0 to (2 ** 16) - 1) of std_logic_vector(31 downto 0);
  signal ram: ram_type;
  signal readAddress: std_logic_vector(31 downto 0);

begin

  -- Store: Write register value to memory.
  STORE: process(clock)
  begin
    if (rising_edge(clock)) then
      if (memWriteEn = ACTIVE) then
        ram(to_integer(unsigned(address))) <= dataIn;
      end if;
      readAddress <= address;
    end if;
  end process STORE;

  -- Load: Read memory and update register.
  dataOut <= ram(to_integer(unsigned(readAddress)));

end architecture DataMemory_ARCH;
