--******************************************************************************
--*
--* Name: singleRegister
--* Designer: Alberto Caravantes
--*
--* 
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BasicPkg.all;

entity singleRegister is
	generic(
		REGSIZE: natural
	);
  port(
    input:      in std_logic_vector(REGSIZE - 1 downto 0);
    writeEn:    in std_logic;
    clock:      in std_logic;
    reset:      in std_logic;
    output:     out std_logic_vector(REGSIZE - 1 downto 0)
  );
end singleRegister;

architecture singleRegister_ARCH of singleRegister is

begin

  SINGLEREGISTER_DRIVER: process(reset, clock)
  begin
    if (reset = '1') then
      output <= (others => '0');
    elsif (rising_edge(clock)) then
      if (writeEn = '1') then
        output <= input;
      end if;
    end if;
  end process SINGLEREGISTER_DRIVER;

end singleRegister_ARCH;
