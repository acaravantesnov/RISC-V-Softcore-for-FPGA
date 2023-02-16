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