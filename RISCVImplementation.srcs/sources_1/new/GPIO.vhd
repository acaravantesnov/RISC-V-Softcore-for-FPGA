library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ComponentsPkg.all;

entity GPIO is
	port(
		writeEn:		in 		std_logic;
		address:		in 		std_logic_vector(1 downto 0);
		dataIn:			in 		std_logic_vector(31 downto 0);
		reset:			in 		std_logic;
		clock:			in 		std_logic;
		data:				inout std_logic_vector(31 downto 0)
	);
end GPIO;

architecture GPIO_ARCH of GPIO is

	signal r_WriteEn:	std_logic_vector(2 downto 0);
	signal dOut:			std_logic_vector(31 downto 0);
	signal dIn:				std_logic_vector(31 downto 0);
	signal tri:				std_logic_vector(31 downto 0);


begin

	DATOSOUT: singleRegister
		generic map(32)
		port map(
			input => dataIn,
			writeEn => r_WriteEn(0),
			reset => reset,
			clock => clock,
			output => dOut
		);
		
	DATOSIN: singleRegister
		generic map(32)
		port map(
			input => dIn,
			writeEn => r_WriteEn(1),
			reset => reset,
			clock => clock
			-- output?
		);
		
	TRISTATE: singleRegister
		generic map(32)
		port map(
			input => dataIn,
			writeEn => r_WriteEn(2),
			reset => reset, -- Todos a 0, entrada por defecto. Evita cortos.
			clock => clock,
			output => tri
		);
		
	-- DEMUX for writeEn
	DEMUX: process(address, writeEn)
	begin
    for i in 0 to 2 loop
      if (to_integer(unsigned(address)) = i) then
        r_WriteEn(i) <= writeEn;
      else
        r_WriteEn(i) <= '0';
      end if;
    end loop;
	end process;
		
	PINS: process(data, tri, dOut, dIn)
	begin
		for i in 0 to 31 loop
			if (tri(i) = '1') then
				data(i) <= dOut(i);
			else
				data(i) <= 'Z';
			end if;
		end loop;
		dIn <= data;
	end process PINS;

end architecture GPIO_ARCH;