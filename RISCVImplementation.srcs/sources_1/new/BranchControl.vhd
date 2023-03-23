--******************************************************************************
--*
--* Name: BranchControl
--* Designer: Alberto Caravantes
--*
--* Component that will activate PCSel depending on the branch and forceBranch
--*	signals.
--*
--*	If the Control Unit states that the system needs to branch no matter what
--* the zero value from the ALU is, it will activate the forceBranch signal, and
--*	so the PCSel will be set to '1'.
--*	On the other hand, if forceBranch is '0', this component will set PCSel to
--*	'1' only if branch and zero signals are '1', '0' otherwise.
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity BranchControl is
  port(
    branch:       in  std_logic;
    forceBranch:  in  std_logic;
    zero:         in  std_logic;
    PCSel:        out std_logic
  );
end BranchControl;

architecture BranchControl_ARCH of BranchControl is

  function sel( branch:       std_logic;
                forceBranch:  std_logic;
                zero:         std_logic)
                return std_logic is
    variable PCSel: std_logic;
  begin
    if (((branch = '1') and (zero = '1')) or (forceBranch = '1')) then
      PCSel := '1';
    else
      PCSel := '0';
    end if;
    return (PCSel);   
  end function;

begin

  PCSel <= sel(branch, forceBranch, zero);

end BranchControl_ARCH;