library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ControlUnitPkg.all;

entity ControlUnit is
  port(
    instruction:  		in  std_logic_vector(31 downto 0);
    comparison:   		in  std_logic_vector(2 downto 0);
    ALUresult:				in	std_logic_vector(31 downto 0);
    IRQ:							in	std_logic;
    reset:        		in  std_logic;
    clock:        		in  std_logic;
    microcode:    		out std_logic_vector(23 downto 0);
    exceptionStatus:	out std_logic;
    mcause:						out std_logic_vector(31 downto 0)
  );
end ControlUnit;

architecture ControlUnit_ARCH of ControlUnit is

  ----state-machine-declarations----------------------------------------SIGNALS
  type States_t is (START, FETCH, DECODE, SAVE_TO_REG, SAVE_TO_MEM, SAVE_TO_REG_AND_CSR);
  signal currentState:  States_t;
  signal nextState:     States_t;

  signal raiseException: std_logic; 

begin
 
  EXCEPTION_STATUS: process(reset, clock)
  begin
    if (reset = '1') then
      exceptionStatus <= '0';    
    elsif (rising_edge(clock)) then 
      if (currentState = START) then
        exceptionStatus <= '0';
      elsif (raiseException = '1') then
        exceptionStatus <= '1';
      elsif (raiseException = '0') then
      	exceptionStatus <= '0';
      end if;
    end if; 
  end process EXCEPTION_STATUS;

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
  STATE_REGISTER: process(reset, clock)
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
  STATE_TRANSITION: process(currentState, instruction, comparison, ALUresult, IRQ)
  	variable tempMicrocode:	std_logic_vector(23 downto 0);
  begin

    microcode <= (others => '0');
    raiseException <= '0';
    mcause <= (others => '0');

		if (IRQ = '1') then -- Except. (IRQ)
			microcode <= (others => '0');
			raiseException <= '1';
			mcause <= (4 => '1', others => '0');
			nextState <= FETCH;
		else
			case currentState is
				--------------------------------------------------------------------START
				when START =>
					nextState <= FETCH;
				--------------------------------------------------------------------FETCH
				when FETCH =>
					microcode(17) <= '1'; -- insRegEn
					nextState <= DECODE;
				-------------------------------------------------------------------DECODE
				when DECODE =>
					tempMicrocode := decode(instruction, comparison);
					if (tempMicrocode = "000000000000000000000000") then -- Except. (Inv. Ins.)
						microcode <= (others => '0');
						raiseException <= '1';
						mcause <= (0 => '1', others => '0');
						nextState <= FETCH;
					else
						microcode <= tempMicrocode;
						case (instruction(6 downto 0)) is
							when "0110011" | "0010011" | "0000011" | "0110111" | "1100111" | "1101111" | "0010111" =>
							--			 R					 I			 I (loads)		U (lui) 	 I (jalr) 	 J (jal)		 U (auipc)
								microcode(18) <= '0'; -- PCEn
								if	instruction(6 downto 0) = "1100111" or		-- I (jalr)
										instruction(6 downto 0) = "1101111" or		-- J (jal)
										instruction(6 downto 0) = "0010111" then	-- U (auipc)
										microcode(11) <= '1'; -- regWriteEn
								end if;
								nextState <= SAVE_TO_REG;
							when "0100011" => -- S
								microcode(18) <= '0'; -- PCEn
								nextState <= SAVE_TO_MEM;
							when "1110011" => -- Atomic
								microcode(18) <= '0'; -- PCEn
								nextState <= SAVE_TO_REG_AND_CSR;
							when "1100011" => -- B
								microcode(18) <= '1'; -- PCEn
								nextState <= FETCH;
							when others => -- Except.
								microcode <= (others => '0');
								raiseException <= '1';
								mcause <= (0 => '1', others => '0');
								nextState <= FETCH;
						end case;
					end if;
				--------------------------------------------------------------SAVE_TO_REG
				when SAVE_TO_REG =>
					microcode <= decode(instruction, comparison);
					if ((instruction(6 downto 0) = "1100111") or			-- I-type jalr
							(instruction(6 downto 0) = "1101111") or			-- J-type (jal)
							(instruction(6 downto 0) = "0010111")) then		-- U-type auipc
						microcode(11) <= '0'; -- regWriteEn
					else
						microcode(11) <= '1'; -- regWriteEn
					end if;
					microcode(18) <= '1'; -- PCEn
					nextState <= FETCH;
				--------------------------------------------------------------SAVE_TO_MEM
				when SAVE_TO_MEM =>
					microcode <= decode(instruction, comparison);
					microcode(5) <= '1'; -- memWriteEn
					microcode(18) <= '1'; -- PCEn
					nextState <= FETCH;
				------------------------------------------------------SAVE_TO_REG_AND_CSR
				when SAVE_TO_REG_AND_CSR =>
					microcode <= decode(instruction, comparison);
					microcode(11) <= '1';
					microcode(23) <= '1';
					microcode(18) <= '1'; -- PCEn
					nextState <= FETCH;
				when others => -- Except.
					microcode <= (others => '0');
					raiseException <= '1';
					mcause <= (0 => '1', others => '0');
					nextState <= FETCH;
			end case;
		end if;

    if ((instruction(6 downto 0) /= "0110011") and		-- R-type
				(instruction(6 downto 0) /= "0110111") and		-- U-type lui
				(instruction(6 downto 0) /= "0010011")) then	-- I-type
			if ((unsigned(ALUresult) >= 0) and (unsigned(ALUresult) <= x"FFF")) then						-- Data memory
				microcode(4 downto 3) <= "00";
			elsif ((unsigned(ALUresult) >= x"1000") and (unsigned(ALUresult) <= x"1002")) then	-- GPIO
				microcode(4 downto 3) <= "10";
			elsif ((unsigned(ALUresult) >= x"3000") and (unsigned(ALUresult) <= x"3002")) then	-- Timer
				microcode(4 downto 3) <= "11";
			end if;
		end if;

  end process STATE_TRANSITION;

end ControlUnit_ARCH;
