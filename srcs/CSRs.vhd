library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CSRs is
	port(
		input:			in	std_logic_vector(31 downto 0);
		CSRWriteEn: 		in	std_logic;
		atomicOpt:		in	std_logic_vector(1 downto 0);
		CSRSel:			in	std_logic; -- natural (Mario) mejor pasar un bit
		exceptionStatus:	in	std_logic;
		mcause:			in	std_logic_vector(31 downto 0);
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
	WRITE_TO_CSR: process(reset, clock)
	begin
		if (reset = '1') then
			ram(0) <= (2 => '1', others => '0');	-- mtvec
			ram(1) <= (others => '0');						-- mcause
		elsif (rising_edge(clock)) then
		  if (CSRWriteEn = '1') then
		      if CSRSel='0' then
				case atomicOpt is
				when "00" => ram(0) <= input;												-- Read and Write
				when "01" => ram(0) <= ram(0) or input;					-- Read and Set
				when "10" => ram(0) <= ram(0) and (not input);	-- Read and Clear
				when others =>				
				end case; 
			  else
				case atomicOpt is
				when "00" => ram(1) <= input;												-- Read and Write
				when "01" => ram(1) <= ram(1) or input;					-- Read and Set
				when "10" => ram(1) <= ram(1) and (not input);	-- Read and Clear
				when others =>				
				end case; 
         	  end if;  
--                              (Mario) He deshecho los dos casos para no tene que usar un indice
--				case atomicOpt is
--					when "00" => ram(CSRSel) <= input;												-- Read and Write
--					when "01" => ram(CSRSel) <= ram(CSRSel) or input;					-- Read and Set
--					when "10" => ram(CSRSel) <= ram(CSRSel) and (not input);	-- Read and Clear
--					when others =>
--				end case;
			end if;
	 		if (exceptionstatus = '1') then
	  		  ram(1) <= mcause;
		    end if;
		end if;
	end process WRITE_TO_CSR;

	-- Read from a CSR
	output <= ram(0) when CSRSel='0' else ram(1); -- (Mario)

end architecture CSRs_ARCH;
