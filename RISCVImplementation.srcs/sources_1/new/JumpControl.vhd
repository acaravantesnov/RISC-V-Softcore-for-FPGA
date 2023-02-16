library ieee;
use ieee.std_logic_1164.all;

entity JumpControl is
  port(
    jumpSel:    in  std_logic;
    PCPlus4:    in  std_logic_vector(31 downto 0);
    branch:     in  std_logic_vector(31 downto 0);
    PCSel:      in  std_logic;
    ALUresult:  in  std_logic_vector(31 downto 0);
    nextPC:     out std_logic_vector(31 downto 0)
  );
end JumpControl;

architecture JumpControl_ARCH of JumpControl is

begin

end JumpControl_ARCH;