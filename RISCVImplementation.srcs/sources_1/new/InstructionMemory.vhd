--******************************************************************************
--*
--* Name: InstructionMemory
--* Designer: Alberto Caravantes
--*
--* 
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BasicPkg.all;

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
  type ram_type is array(0 to (INS_MEM_SIZE) - 1) of std_logic_vector(7 downto 0);
  signal ram: ram_type := ( 0 =>  "00000001", -- ADDI x18, x0, 20
                            1 =>  "01000000", -- "00000001010000000000100100010011"
                            2 =>  "00001001",
                            3 =>  "00010011",
                            4 =>  "00000001", -- ADDI x19, x0, 22
                            5 =>  "01100000", -- "00000001011000000000100110010011"
                            6 =>  "00001001",
                            7 =>  "10010011",
                            8 =>  "00000001", -- ADD x20, x18, x19
                            9 =>  "00101001", -- "00000001001010011000101000110011"
                            10 => "10001010",
                            11 => "00110011",
                            12 => "00000001", -- SB x18, 0(x20)
                            13 => "00101010", -- "00000001001010100000000000000000"
                            14 => "00000000",
                            15 => "00000000",
                            others => X"00");
begin

  instruction <=  ram(to_integer(unsigned(readAddress))) &
                  ram(to_integer(unsigned(readAddress)) + 1) &
                  ram(to_integer(unsigned(readAddress)) + 2) &
                  ram(to_integer(unsigned(readAddress)) + 3);

end InstructionMemory_ARCH;