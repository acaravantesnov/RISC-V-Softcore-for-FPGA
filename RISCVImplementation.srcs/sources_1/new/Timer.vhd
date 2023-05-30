library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ComponentsPkg.all;

entity Timer is
	generic(
		CNTVALUE_SIZE: natural := 17
	);
	port(
		address:				in std_logic_vector(1 downto 0);
		dataIn:					in std_logic_vector(31 downto 0);
		writeEn:				in std_logic;
		reset:					in std_logic;
		clock:					in std_logic;
		timerInterrupt:	out	std_logic
	);
end Timer;

architecture Timer_ARCH of Timer is

	signal r_WriteEn:		std_logic_vector(2 downto 0);
	signal controlSig:	std_logic_vector(31 downto 0);
	signal arrSig:			std_logic_vector(31 downto 0);
	signal stateSig:		std_logic_vector(31 downto 0);
	signal cntValue:		unsigned(CNTVALUE_SIZE downto 0) := (others => '0');

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
			input => dataIn,
			writeEn => r_WriteEn(2),
			reset => reset,
			clock => clock,
			output => stateSig
		);

	CNT: process(clock, reset)
	begin
		if (reset = '1') then
			cntValue <= (others => '0');
			stateSig(0) <= '0';
			timerInterrupt <= '0';
		elsif (rising_edge(clock)) then
			if (controlSig(1) = '1') then -- Clear
				cntValue <= (others => '0');
				stateSig(0) <= '0';
			elsif (controlSig(0) = '1') then -- Enable
				if ((cntValue + 1) = unsigned(arrSig)) then -- Counter reaches arrSig
					stateSig(0) <= '1';
					if (controlSig(2) = '1') then -- En_Interrupt
						timerInterrupt <= '1';
					end if;
					if (controlSig(3) = '1') then -- Autoreload
						cntValue <= (others => '0');
					end if;
				else
					cntValue <= cntValue + 1;
				end if;
			end if;
		end if;
	end process CNT;

end Timer_ARCH;