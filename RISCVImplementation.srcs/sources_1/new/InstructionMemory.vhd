--******************************************************************************
--*
--* Name: InstructionMemory
--* Designer: Alberto Caravantes
--*
--* Component that given the memory address by the Program Counter, it outputs
--*	the 32 bit instruction asynchronously.
--*
--*	256 bytes of byte addressable big endian memory. Instruction is made up of
--*	the concatenation of the 4 consecutive bytes from the readAddress input.
--*
--******************************************************************************

library ieee, std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BasicPkg.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity InstructionMemory is
  generic(
    INS_MEM_SIZE: integer := 2 ** 8;
    TEXT_FILE:		string := "slti.mem"
  );
  port(
    readAddress: in std_logic_vector(31 downto 0);
    instruction: out std_logic_vector(31 downto 0)
  );
end InstructionMemory;

architecture InstructionMemory_ARCH of InstructionMemory is

  type ram_type is array(0 to (INS_MEM_SIZE) - 1) of std_logic_vector(31 downto 0);
  signal ram: ram_type := (others => (others => '0'));

begin

	BUILD_MEM: process

		file			input_file: text;
		variable	input_line: line;
		variable	value:			std_logic_vector(31 downto 0);
		variable	i:					integer;

	begin

		file_open(input_file, TEXT_FILE, read_mode);

		i:= 0;
		while not endfile(input_file) loop
			readline(input_file, input_line);
			read(input_line, value);
			ram(i) <= value;
			i := i + 1;
		end loop;
		wait;

	end process;

	instruction <=  ram(to_integer(unsigned(readAddress)));

end InstructionMemory_ARCH;
