library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Registers is
	port(
		rs1, rs2, rd:	in std_logic_vector(4 downto 0);
		writeData:		in std_logic_vector(31 downto 0);
		regWriteEn:		in std_logic;
		clock:			in std_logic;
		r1, r2:			out std_logic_vector(31 downto 0)
	);
end Registers;

architecture Registers_ARCH of Registers is

	component singleRegister is
		port(
			input:			in std_logic_vector(31 downto 0);
			writeEn:		in std_logic;
			reset, clock:	in std_logic;
			output:			out std_logic_vector(31 downto 0)
		);
	end component;

	--Internal-signals---------------------------------------------------SIGNALS
	type t_Input is array (0 to 31) of std_logic_vector(31 downto 0);
	signal r_Input: t_Input;

	type t_WriteEn is array (0 to 31) of std_logic;
	signal r_WriteEn: t_WriteEn;

	type t_Output is array (0 to 31) of std_logic_vector(31 downto 0);
	signal r_Output: t_Output;

begin

	--===================================================================PROCESS
	--
	--	Demultipexer
	--
	--==========================================================================
	DEMUX: process(rd)
	begin
		for i in 0 to 31 loop
			if (to_integer(unsigned(rd)) = i) then
				r_Input(i) <= writeData;
				r_WriteEn(i) <= regWriteEn;
			end if;
		end loop;
	end process;

	--===================================================================PROCESS
	--
	--	Multiplexer
	--
	--==========================================================================
	MUX: process(rs1, rs2)
	begin
		for i in 0 to 31 loop
			if (to_integer(unsigned(rs1)) = i) then
				r1 <= r_Output(i);
			end if;
		end loop;
		for i in 0 to 31 loop
			if (to_integer(unsigned(rs2)) = i) then
				r2 <= r_Output(i);
			end if;
		end loop;
	end process;

	--==================================================================GENERATE
	--
	--
	--
	--==========================================================================
	GENERATE_32_REGISTERS: for i in 0 to 31 generate
		REGX: singleRegister port map(r_Input(i), r_WriteEn(i), reset, clock,
		r_Output(i));
	end generate;

end Registers_ARCH;
