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
  signal ram: ram_type := ( 0 =>  "00000001",
                            1 =>  "01000000",
                            2 =>  "00001001",
                            3 =>  "00000011",
                            4 =>  "00000001",
                            5 =>  "01100000",
                            6 =>  "00001001",
                            7 =>  "10000011",
                            8 =>  "00000001",
                            9 =>  "00101001",
                            10 => "10001010",
                            11 => "00110011",
                            others => X"00");
begin

  instruction <=  ram(to_integer(unsigned(readAddress))) &
                  ram(to_integer(unsigned(readAddress)) + 1) &
                  ram(to_integer(unsigned(readAddress)) + 2) &
                  ram(to_integer(unsigned(readAddress)) + 3);

end InstructionMemory_ARCH;