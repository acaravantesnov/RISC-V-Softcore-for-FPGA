library ieee;
use ieee.std_logic_1164.all;

entity ExceptionControl is
	port(
		input:						in 	std_logic_vector(31 downto 0);
		exceptionStatus:	in 	std_logic;
		output:						out	std_logic_vector(31 downto 0)
	);
end ExceptionControl;

architecture ExceptionControl_ARCH of ExceptionControl is
begin

	EXCEPTIONCNTRL: process(input, exceptionStatus)
	begin
		if (exceptionStatus = '1') then
			output <= "00000000010000000000001011100111"; -- jalr x5, 4(x0)
		else
			output <= input;
		end if;
		
	end process EXCEPTIONCNTRL;
	
end ExceptionControl_ARCH;