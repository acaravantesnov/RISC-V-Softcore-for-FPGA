--*****************************************************************************
--*
--* Name: ControlUnit
--* Designer: Alberto Caravantes
--*
--* Component implementing a Finite State Machine which, depending on the
--*	current instruction and a comparison result, performs the neccessary
--*	Fetch-Decode-Execute cycle by setting up a custom microcode for each state.
--*	Microcode is made up of 17 bits (Consult RISCV_CPU.vhd for more info.).
--*
--*****************************************************************************

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
    microcode:    out std_logic_vector(17 downto 0);
    mcause:				out std_logic_vector(3 downto 0);
    exceptionSig:	out std_logic
  );
end ControlUnit;

architecture ControlUnit_ARCH of ControlUnit is

  ----state-machine-declarations----------------------------------------SIGNALS
  type States_t is (START, FETCH, DECODE, SAVE_TO_REG, SAVE_TO_MEM);
  signal currentState:  States_t;
  signal nextState:     States_t;

begin

	exceptionSig <= '0';
	mcause <= (others => '0');

	--EXCEPTION_HANDLER: process(instruction)
	--begin
		--if ((instruction(6 downto 0) /= "0110111") and		-- U-type lui
				--(instruction(6 downto 0) /= "0010111") and		-- U-type auipc
				--(instruction(6 downto 0) /= "1101111") and		-- J-type jal
				--(instruction(6 downto 0) /= "1100111") and		-- I-type jalr
				--(instruction(6 downto 0) /= "1100011") and		-- B-type
				--(instruction(6 downto 0) /= "0000011") and		-- I-type loads
				--(instruction(6 downto 0) /= "0100011") and		-- S-type
				--(instruction(6 downto 0) /= "0010011") and		-- I-type
				--(instruction(6 downto 0) /= "0110011") and		-- R-type
				--(instruction(6 downto 0) /= "0000000")) then	-- To be determined
			--exceptionSig <= '1';
			--mcause <= (1 => '1', others => '0');
		--end if;
	--end process EXCEPTION_HANDLER;

	--====================================================================PROCESS
	--
	--	State Register
	--
	--	The State Register is in charge of the synchronous part of the FSM.
	--	It changes the currentState into the nextState at each clock pulse.
	--	If the reset input is active, it will just assign the currentState to
	--	the START state.
	--
	--===========================================================================
  STATE_REGISTER: process(reset, clock, instruction)
  begin
    if (reset = '1') then
      currentState <= START;
    elsif (rising_edge(clock)) then
      currentState <= nextState;
    end if;
  end process STATE_REGISTER;

	--====================================================================PROCESS
	--
	--	State Transition
	--
	--	The State Transition is in charge of the combinational part of the FSM.
	--	It sets the outputs for each currentState, and assigns the nextState
	--	according to the conditions set on the FSM diagram.
	--
	--===========================================================================
  STATE_TRANSITION: process(currentState, instruction, comparison)
  begin

    microcode <= (others => '0');

    case currentState is
    	--------------------------------------------------------------------START
      when START =>
        nextState <= FETCH;
      --------------------------------------------------------------------FETCH
      when FETCH =>
        microcode(15) <= '1';
        microcode(8) <= '1';
        exceptionSig <= '0';
        nextState <= DECODE;
      -------------------------------------------------------------------DECODE
      when DECODE =>
        microcode <= decode(instruction, comparison);
        if  ((instruction(6 downto 0) = "0110011") or     -- R-type
            (instruction(6 downto 0) = "0010011") or      -- I-type
            (instruction(6 downto 0) = "1100111") or			-- I-type jalr
            (instruction(6 downto 0) = "1101111") or			-- J-type (jal)
            (instruction(6 downto 0) = "0010111")) then		-- U-type auipc
          nextState <= SAVE_TO_REG;
        elsif ((instruction(6 downto 0) = "0000011") or		-- I-type loads
        			(instruction(6 downto 0) = "0110111")) then	-- U-type lui
        	microcode(16) <= '1';
        	microcode(9) <= '1';
        	nextState <= FETCH;
        elsif (instruction(6 downto 0) = "0100011") then  -- S-type
          nextState <= SAVE_TO_MEM;
        elsif (instruction(6 downto 0) = "1100011") then  -- B-type
          microcode(16) <= '1';
          nextState <= FETCH;
        end if;
      --------------------------------------------------------------SAVE_TO_REG
      when SAVE_TO_REG =>
      	microcode <= decode(instruction, comparison);
        microcode(16) <= '1';
        microcode(9) <= '1';
        nextState <= FETCH;
      --------------------------------------------------------------SAVE_TO_MEM
      when SAVE_TO_MEM =>
      	microcode <= decode(instruction, comparison);
        microcode(16) <= '1';
        microcode(4) <= '1';
        nextState <= FETCH;
    end case;
  end process STATE_TRANSITION;

end ControlUnit_ARCH;
