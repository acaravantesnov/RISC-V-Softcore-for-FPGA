library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CSRs is
	port(
		input:			in	std_logic_vector(31 downto 0);
		CSRWriteEn: in	std_logic;
		atomicOpt:	in	std_logic_vector(1 downto 0);
		CSRSel:			in	natural;
		clock:			in	std_logic;
		reset:			in	std_logic;
		output:			out std_logic_vector(31 downto 0)
	);
end CSRs;

architecture CSRs_ARCH of CSRs is

	-- Register 0: mtvec
	-- Register 1: mcause
	type ram_type is array(0 to 1) of std_logic_vector(31 downto 0);
  signal ram: ram_type := (others => (others => '0'));

begin

	-- Write to a CSR
	WRITE_TO_CSR: process(reset, clock, CSRWriteEn)
	begin
		if (reset = '1') then
			ram(0) <= (2 => '1', others => '0');
			ram(1) <= (others => '0');
		elsif (rising_edge(clock)) then
			if (CSRWriteEn = '1') then
				case atomicOpt is
					when "00" => ram(CSRSel) <= input;												-- Read and Write
					when "01" => ram(CSRSel) <= ram(CSRSel) or input;					-- Read and Set
					when "10" => ram(CSRSel) <= ram(CSRSel) and (not input);	-- Read and Clear
					when others =>
				end case;
			end if;
		end if;
	end process WRITE_TO_CSR;

	-- Read from a CSR
	output <= ram(CSRSel);

end architecture CSRs_ARCH;
