library ieee, std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity InstructionMemory is
  generic(
    INS_MEM_SIZE: 		integer := 2 ** 10; -- 1024
    TEXT_FILE:				string := "EXInsertionSort.mem"
  );
  port(
    readAddress:			in  std_logic_vector(31 downto 0);
    instruction:			out std_logic_vector(31 downto 0)
  );
end InstructionMemory;

architecture InstructionMemory_ARCH of InstructionMemory is

  -- Big endian
  type ram_type is array(0 to (INS_MEM_SIZE / 4) - 1) of std_logic_vector(31 downto 0);
  signal ram: ram_type :=(
    0 => "00000000"&"00000000"&"00000100"&"01100011", -- beq x0, x0, 8
    1 => "00000000"&"00000010"&"10000011"&"01100111", -- jalr x6, 0(x5)
    others => (others => '0')
  );

begin

	BUILD_MEM: process

		file			input_file: text;
		variable	input_line: line;
		variable	value:			std_logic_vector(31 downto 0);
		variable	i:					integer;

	begin

		file_open(input_file, TEXT_FILE, read_mode);

		i := 2;
		while not endfile(input_file) loop
			readline(input_file, input_line);
			read(input_line, value);
      ram(i) <= value;
			i := i + 1;
		end loop;
		wait;

	end process BUILD_MEM;

	instruction <=  ram(to_integer(unsigned(readAddress(31 downto 2))));

end InstructionMemory_ARCH;
