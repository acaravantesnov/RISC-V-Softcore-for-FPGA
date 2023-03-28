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

entity InstructionMemory is
  generic(
    INS_MEM_SIZE: integer := 2 ** 8
  );
  port(
    readAddress: in std_logic_vector(31 downto 0);
    instruction: out std_logic_vector(31 downto 0)
  );
end InstructionMemory;

architecture InstructionMemory_ARCH of InstructionMemory is

--	impure function	fileSize( str: string) return natural is

--		file			input_file: text;
--		variable	input_line: line;
--		variable 	size: natural := 0;
	
--	begin

--		file_open(input_file, str, read_mode);
--		while not endfile(input_file) loop
--			readline(input_file, input_line);
--			size := size + 1;
--		end loop;

--		file_close(input_file);
--		return (size);
	
--	end function;

--	impure function readFile(	str: string;
--														size: natural) return std_logic_vector is

--		file			input_file: text;
--		variable	input_line: line;
--		variable	buf:				string(32 downto 1);
--		variable	output:			std_logic_vector(size - 1 downto 0);
	
--	begin

--		file_open(input_file, str, read_mode);
--		while not endfile(input_file) loop
--			readline(input_file, input_line);
--			read(input_line, buf);
--			for i in buf'range loop
--				if buf(i) = '0' then
--					output := output & '0';
--				elsif buf(i) = '1' then
--					output := output & '1';
--				end if;
--			end loop;
--		end loop;

--		file_close(input_file);
--		return output;

--	end function;

  type ram_type is array(0 to (INS_MEM_SIZE) - 1) of std_logic_vector(7 downto 0);
  --signal ram: ram_type := (others => (others => '0'));
	signal ram: ram_type := ( 0 =>  "00000001", -- ADDI x18, x0, 20
														1 =>  "01000000", -- "00000001010000000000100100010011"
														2 =>  "00001001",
														3 =>  "00010011",
														4 =>  "00000001", -- ADDI x19, x0, 22
														5 =>  "01100000", -- "00000001011000000000100110010011"
														6 =>  "00001001",
														7 =>  "10010011",
														8 =>  "00000001", -- ADD x20, x18, x19
														9 =>  "00111001", -- "00000001001010011000101000110011"
														10 => "00001010",
														11 => "00110011",
														12 => "00000001", -- SB x18, 0(x20)
														13 => "00101010", -- "00000001001010100000000000100011"
														14 => "00000000",
														15 => "00100011",
														others => X"00");
  --signal vector: std_logic_vector(fileSize("test_1_bin") - 1 downto 0);

begin

--	vector <= readFile("test_1_bin", fileSize("test_1_bin"));

--	BUILD_MEM: process(vector)
--	begin
--		for i in vector'range loop
--			if ((i + 1) mod 8 = 0) then
--				ram(((i + 1) / 8) - 1) <= vector(i downto i - 7);
--			end if;
--		end loop;
--	end process;

  instruction <=  ram(to_integer(unsigned(readAddress))) &
                  ram(to_integer(unsigned(readAddress)) + 1) &
                  ram(to_integer(unsigned(readAddress)) + 2) &
                  ram(to_integer(unsigned(readAddress)) + 3);

end InstructionMemory_ARCH;