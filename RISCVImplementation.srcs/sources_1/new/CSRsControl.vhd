library ieee;
use ieee.std_logic_1164.all;

entity CSRsControl is
	port(
		r1Sig:		in	std_logic_vector(31 downto 0);
		immValue:	in	std_logic_vector(31 downto 0);
		r1orzimm:	in	std_logic;
		CSRInput:	out	std_logic_vector(31 downto 0)
	);
end CSRsControl;

architecture CSRsControl_ARCH of CSRsControl is

begin

	with r1orzimm
		select CSRInput <=	r1Sig when '0',
												immValue when '1',
												(others => '0') when others;

end architecture CSRsControl_ARCH;