--******************************************************************************
--*
--* Name: RegisterFile
--* Designer: Alberto Caravantes
--*
--* Component made of 32 32-bit registers.
--*	Write is synchronous while read is combinational.
--*
--*		REGISTER			ABI/ALIAS		DESCRIPTION															SAVED
--*		x0						zero				Hardwired zero													No
--*		x1						ra					Retrun Address													No
--*		x2						sp					Stack Pointer														Yes
--*		x3						gp					Global Pointer													No
--*		x4						tp					Thread Pointer													No
--*		x5						t0					Temporary / Alternate link register			No
--*		x6 - x7				t1 - t2			Temporaries															No
--*		x8						s0 / fp			Saved register / Frame Pointer					Yes
--*		x9						s1					Saved register													Yes
--*		x10 - x11			a0 - a1			Function arguments / Return value				No
--*		x12 - x17			a2 - a7			Function arguments											No
--*		x18 - x27			s2 - s11		Saved registers													No
--*		x28 - x31			t3 - t6			Temporaries															No
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BasicPkg.all;

entity RegisterFile is
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
end RegisterFile;

architecture RegisterFile_ARCH of RegisterFile is

	type t_Input is array (31 downto 0) of std_logic_vector(31 downto 0);
	signal r_Input: t_Input;

	type t_WriteEn is array (31 downto 0) of std_logic;
	signal r_WriteEn: t_WriteEn;

	type t_Output is array (31 downto 0) of std_logic_vector(31 downto 0);
	signal r_Output: t_Output;

	component singleRegister is
		port(
			input:      in std_logic_vector(31 downto 0);
			writeEn:    in std_logic;
			clock:      in std_logic;
			reset:      in std_logic;
			output:     out std_logic_vector(31 downto 0)
		);
	end component;

begin

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

  -- DEMUX
	DEMUX: process(rd, writeData, regWriteEn)
	begin
    for i in 0 to 31 loop
      r_Input(i) <= writeData;
      if (to_integer(rd) = i) then
        r_WriteEn(i) <= regWriteEn;
      else
        r_WriteEn(i) <= '0';
      end if;
    end loop;
	end process;

  -- MUX
	r1 <= r_Output(to_integer(rs1));
	r2 <= r_Output(to_integer(rs2));

end RegisterFile_ARCH;
