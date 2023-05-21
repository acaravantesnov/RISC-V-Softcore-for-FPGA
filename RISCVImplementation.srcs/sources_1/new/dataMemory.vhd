--******************************************************************************
--*
--* Name: DataMemory
--* Designer: Alberto Caravantes
--*
--* 
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataMemory is
  generic(
    RAM_SIZE:   integer := 2 ** 12
  );
  port(
    writeEn: 		in std_logic;
    address:    in std_logic_vector(11 downto 0);
    dataIn:     in std_logic_vector(31 downto 0);
    clock:      in std_logic;
    dataOut:    out std_logic_vector(31 downto 0)
  );
end DataMemory;

architecture DataMemory_ARCH of DataMemory is

  type ram_type is array(0 to (RAM_SIZE) - 1) of std_logic_vector(31 downto 0);
  signal ram: ram_type := (others => (others => '0'));

begin

  -- Store: Write register value to memory.
  STORE: process(clock)
  begin
    if (rising_edge(clock)) then
      if (writeEn = '1') then
        ram(to_integer(unsigned(address))) <= dataIn;
      end if;
    end if;
  end process STORE;

	
  -- Load: Read memory and update register.
  LOAD: process(address)
  begin
  	if ((to_integer(unsigned(address)) >= 0) and
  	(to_integer(unsigned(address)) <= (RAM_SIZE - 1))) then
  		dataOut <= ram(to_integer(unsigned(address)));
  	else
  		dataOut <= (others => '0');
  	end if;
  end process LOAD;

end architecture DataMemory_ARCH;
