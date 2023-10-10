library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Timer is
	port(
		address:				in 	std_logic_vector(1 downto 0);
		dataIn:					in 	std_logic_vector(31 downto 0);
		writeEn:				in 	std_logic;
		reset:					in 	std_logic;
		clock:					in 	std_logic;
		dataOut:				out	std_logic_vector(31 downto 0);
		timerInterrupt:	out	std_logic
	);
end Timer;

architecture Timer_ARCH of Timer is

	component singleRegister is
		generic(
			REGSIZE: natural
		);
		port(
			input:      in std_logic_vector(REGSIZE - 1 downto 0);
			writeEn:    in std_logic;
			clock:      in std_logic;
			reset:      in std_logic;
			output:     out std_logic_vector(REGSIZE - 1 downto 0)
		);
	end component singleRegister;

	signal r_WriteEn:		std_logic_vector(1 downto 0);
	signal controlSig:	std_logic_vector(31 downto 0);
	signal arrSig:			std_logic_vector(31 downto 0);
	signal stateSig:		std_logic_vector(31 downto 0) := (others => '0');
	signal cntValue:		unsigned(31 downto 0) := (others => '0');

begin

	CONTROL: singleRegister
		generic map(32)
		port map(
			input => dataIn,
			writeEn => r_WriteEn(0),
			reset => reset,
			clock => clock,
			output => controlSig
		);
		
	ARR: singleRegister
		generic map(32)
		port map(
			input => dataIn,
			writeEn => r_WriteEn(1),
			reset => reset,
			clock => clock,
			output => arrSig
		);
	
	
	STATE: singleRegister
		generic map(32)
		port map(
			input => stateSig,
			writeEn => '1',
			reset => reset,
			clock => clock
		);

	r_WriteEn(0) <= '1' when ((to_integer(unsigned(address)) = 0) and (writeEn = '1')) else '0'; -- writeEn for Control reg.
	r_WriteEn(1) <= '1' when ((to_integer(unsigned(address)) = 1) and (writeEn = '1')) else '0'; -- writeEn for ARR reg.

	CNT: process(clock, reset)
	begin
		if (reset = '1') then
			cntValue <= (others => '0');
			stateSig <= (others => '0');
			timerInterrupt <= '0';
		elsif (rising_edge(clock)) then
		  timerInterrupt <= '0';
			if (controlSig(1) = '1') then -- Clear
				cntValue <= (others => '0');
				stateSig(0) <= '0';
			elsif (controlSig(0) = '1') then -- Enable
				if (((cntValue + 1) = unsigned(arrSig)) and (stateSig(0) = '0')) then -- Counter reaches arrSig
					stateSig <= (0 => '1', others => '0');
					if (controlSig(2) = '1') then -- En_Interrupt
						timerInterrupt <= '1';
					end if;
					if (controlSig(3) = '1') then -- Autoreload
						cntValue <= (others => '0');
					end if;
				elsif ((cntValue + 1) /= unsigned(arrSig)) then
					cntValue <= cntValue + 1;
				end if;
			end if;
		end if;
	end process CNT;
	
	dataOut <= std_logic_vector(cntValue);

end Timer_ARCH;
