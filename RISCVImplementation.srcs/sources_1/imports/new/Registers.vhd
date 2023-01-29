library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.basic.all;

entity Registers is
	port(
		rs1:        in unsigned(4 downto 0);
		rs2:        in unsigned(4 downto 0);
		rd:         in unsigned(4 downto 0);
		writeData:  in std_logic_vector(31 downto 0);
		regWriteEn: in std_logic;
		clock:			in std_logic;
		reset:      in std_logic;
		r1:         out std_logic_vector(31 downto 0);
		r2:         out std_logic_vector(31 downto 0)
	);
end Registers;

architecture Registers_ARCH of Registers is

	component singleRegister is
		port(
			input:   in std_logic_vector(31 downto 0);
			writeEn: in std_logic;
			reset:   in std_logic;
			clock:   in std_logic;
			output:  out std_logic_vector(31 downto 0)
		);
	end component;

	type t_Input is array (31 downto 0) of std_logic_vector(31 downto 0);
	signal r_Input: t_Input;

	type t_WriteEn is array (31 downto 0) of std_logic;
	signal r_WriteEn: t_WriteEn;

	type t_Output is array (31 downto 0) of std_logic_vector(31 downto 0);
	signal r_Output: t_Output;
	
begin

	DEMUX: process(rd, writeData, regWriteEn)
	begin
    for i in 0 to 31 loop
      r_Input(i) <= writeData;
      if (to_integer(rd) = i) then
        r_WriteEn(i) <= regWriteEn;
      else
        r_WriteEn(i) <= not ACTIVE;
      end if;
    end loop;
	end process;

  --MUX
	r1 <= r_Output(to_integer(rs1));
	r2 <= r_Output(to_integer(rs2));

	GENERATE_32_REGISTERS: for i in 0 to 31 generate
		REGX: singleRegister
		  port map(
		    input => r_Input(i),
		    writeEn => r_WriteEn(i),
		    reset => reset,
		    clock => clock,
		    output => r_Output(i)
		  );
	end generate GENERATE_32_REGISTERS;

end Registers_ARCH;
