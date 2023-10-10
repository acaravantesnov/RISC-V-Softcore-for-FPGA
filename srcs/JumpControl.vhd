library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

  function sel( jumpSel:    std_logic;
                PCPlus4:    std_logic_vector(31 downto 0);
                branch:     std_logic_vector(31 downto 0);
                PCSel:      std_logic;
                ALUresult:  std_logic_vector(31 downto 0))
                return std_logic_vector is
    variable vector: std_logic_vector(31 downto 0) := (others => '0');
  begin

    -- (Mario) Mejor no comprobar el limite de memoria  
    if (jumpSel = '1') then
      vector := ALUresult;
    elsif (PCSel = '0') then
      	--if (unsigned(PCPlus4) > ((2 ** 10) - 4)) then -- Ins. Mem. Limit
      	--	vector := (others => '0');
      	--else
        vector := PCPlus4;
        --end if;
    else
        vector := branch;
    end if;

    return (vector);

  end function;

begin

  nextPC <= sel(jumpSel, PCPlus4, branch, PCSel, ALUresult);

end JumpControl_ARCH;