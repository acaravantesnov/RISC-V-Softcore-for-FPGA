--******************************************************************************
--*
--* Name: JumpControl
--* Designer: Alberto Caravantes
--*
--* Component that selects the nextPC based on the jumpSel and PCSel 1-bit
--*	signals.
--*
--*	If jumpSel is equal to '1', the nextPC will be ALUresult.
--*	However, if jumpSel is equal to '0', the nextPc will be PCPlus4 if PCSel is
--*	'0', and branch if PCSel is '1'.
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity JumpControl is
  port(
    jumpSel:    in  std_logic;
    PCPlus1:    in  std_logic_vector(31 downto 0);
    branch:     in  std_logic_vector(31 downto 0);
    PCSel:      in  std_logic;
    ALUresult:  in  std_logic_vector(31 downto 0);
    nextPC:     out std_logic_vector(31 downto 0)
  );
end JumpControl;

architecture JumpControl_ARCH of JumpControl is

  function sel( jumpSel:    std_logic;
                PCPlus1:    std_logic_vector(31 downto 0);
                branch:     std_logic_vector(31 downto 0);
                PCSel:      std_logic;
                ALUresult:  std_logic_vector(31 downto 0))
                return std_logic_vector is
    variable vector: std_logic_vector(31 downto 0) := (others => '0');
  begin
  
    if (jumpSel = '1') then
      vector := ALUresult;
    else
      if (PCSel = '0') then
        vector := PCPlus1;
      elsif (PCSel = '1') then
        vector := branch;
      end if;
    end if;
    return (vector);

  end function;

begin

  nextPC <= sel(jumpSel, PCPlus1, branch, PCSel, ALUresult);

end JumpControl_ARCH;