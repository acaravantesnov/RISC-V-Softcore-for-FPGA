library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BasicPkg.all;

entity ControlUnit is
  port(
    instruction:  in  std_logic_vector(6 downto 0);
    regWriteEn:   out std_logic;
    ALUOp:        out std_logic_vector(1 downto 0);
    immSel:       out std_logic_vector(1 downto 0);
    regImmSel:    out std_logic;
    branch:       out std_logic;
    memWriteEn:   out std_logic;
    ALUMemSel:    out std_logic
  );
end ControlUnit;

architecture ControlUnit_ARCH of ControlUnit is

begin

end ControlUnit_ARCH;
