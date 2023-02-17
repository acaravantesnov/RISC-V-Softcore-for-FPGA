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
    microcode:    out std_logic_vector(9 downto 0)
  );
end ControlUnit;

architecture ControlUnit_ARCH of ControlUnit is

  ----state-machine-declarations---------------------------------------SIGNALS
  type States_t is (START, FETCH, IDLE, SAVE_TO_REG, SAVE_TO_MEM);
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
        nextState <= FETCH;
      when FETCH =>
        fetch(instruction, comparison);
        nextState <= IDLE;
      when IDLE =>
        microcode <= 
        if () then
          nextState <= SAVE_TO_REG;
        else
          nextState <= SAVE_TO_MEM;
        end if;
      when SAVE_TO_REG =>
        saveToReg(instruction, comparison);
        nextState <= FETCH;
      when SAVE_TO_MEM =>
        saveToMem(instruction, comparison);
        nextState <= FETCH;
  end process STATE_TRANSITION;

end ControlUnit_ARCH;
