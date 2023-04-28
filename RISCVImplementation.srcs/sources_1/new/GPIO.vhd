library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BasicPkg.all;

entity GPIO is
	port(
		writeEn:		in 	std_logic;
		address:		in 	std_logic_vector(3 downto 0);
		dataIn:			in 	std_logic_vector(31 downto 0);
		outputsel:	in 	std_logic_vector(3 downto 0);
		reset:			in 	std_logic;
		clock:			in 	std_logic;
		dataOut:		out std_logic_vector(31 downto 0)
	);
end GPIO;

architecture GPIO_ARCH of GPIO is

	type ram_type is array(0 to 15) of std_logic_vector(31 downto 0);
  signal ram: ram_type := (others => (others => '0'));

begin

	-- Write register value to GPIO.
  STORE: process(clock)
  begin
  	if (reset = '1') then
  		ram <= (others => (others => '0'));
    elsif (rising_edge(clock)) then
      if (writeEn = '1') then
        ram(to_integer(unsigned(address))) <= dataIn;
      end if;
    end if;
  end process STORE;
  
  -- Read from GPIO
  dataOut <= ram(to_integer(unsigned(outputSel)));

end architecture GPIO_ARCH;