library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GPIO is
	port(
		writeEn:		in 		std_logic;
		address:		in 		std_logic_vector(1 downto 0);
		dataIn:			in 		std_logic_vector(31 downto 0);
		reset:			in 		std_logic;
		clock:			in 		std_logic;
		dataOut:		out		std_logic_vector(31 downto 0);
		data:				inout std_logic_vector(31 downto 0)
	);
end GPIO;

architecture GPIO_ARCH of GPIO is

	component singleRegister is
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
	end component;

	signal r_WriteEn:	std_logic_vector(1 downto 0);
	signal dOut:			std_logic_vector(31 downto 0);
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
			input => data,
			writeEn => '1',
			reset => reset,
			clock => clock,
			output => dataOut
		);
		
	TRISTATE: singleRegister
		generic map(32)
		port map(
			input => dataIn,
			writeEn => r_WriteEn(1),
			reset => reset, -- Todos a 0, entrada por defecto. Evita cortos.
			clock => clock,
			output => tri
		);

	r_WriteEn(0) <= '1' when address="00" and writeEn = '1' else '0'; -- writeEn for DatosOut reg.
	r_WriteEn(1) <= '1' when address="10" and writeEn = '1' else '0'; -- writeEn for TRI reg.

	PINS: process(tri, dOut)
	begin
		for i in 0 to 31 loop
			if (tri(i) = '1') then
				data(i) <= dOut(i);
			else
				data(i) <= 'Z';
			end if;
		end loop;
	end process PINS;

end architecture GPIO_ARCH;