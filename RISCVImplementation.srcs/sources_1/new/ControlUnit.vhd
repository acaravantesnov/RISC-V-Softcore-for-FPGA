--******************************************************************************
--*
--* Name: ControlUnit
--* Designer: Alberto Caravantes
--*
--* 
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BasicPkg.all;
use work.ControlUnitPkg.all;

entity ControlUnit is
  port(
    instruction:  in  std_logic_vector(31 downto 0);
    comparison:   in  std_logic_vector(2 downto 0);
    reset:        in  std_logic;
    clock:        in  std_logic;
    microcode:    out std_logic_vector(15 downto 0)
  );
end ControlUnit;

architecture ControlUnit_ARCH of ControlUnit is

  ----state-machine-declarations---------------------------------------SIGNALS
  type States_t is (START, FETCH, DECODE, SAVE_TO_REG, SAVE_TO_MEM);
  signal currentState:  States_t;
  signal nextState:     States_t;

begin

  STATE_REGISTER: process(reset, clock)
  begin
    if (reset = '1') then
      currentState <= START;
    elsif (rising_edge(clock)) then
      currentState <= nextState;
    end if;
  end process STATE_REGISTER;

  STATE_TRANSITION: process(currentState, instruction, comparison)
  begin

    case currentState is
      when START =>
        microcode <= (others => '0');
        nextState <= FETCH;
      when FETCH =>
        microcode(15) <= '1';
        nextState <= DECODE;
      when DECODE =>
        microcode <= decode(instruction, comparison);
        if () then
          nextState <= SAVE_TO_REG;
        else
          nextState <= SAVE_TO_MEM;
        end if;
      when SAVE_TO_REG =>
        microcode <= saveToReg(instruction, comparison);
        nextState <= FETCH;
      when SAVE_TO_MEM =>
        microcode <= saveToMem(instruction, comparison);
        nextState <= FETCH;
    end case;
  end process STATE_TRANSITION;

end ControlUnit_ARCH;
