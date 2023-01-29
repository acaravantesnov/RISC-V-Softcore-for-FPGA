library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.basic.all;

entity ALU_TB is
end ALU_TB;

architecture ALU_TB_ARCH of ALU_TB is

  component ALU is
    port (
      r1:       in std_logic_vector(31 downto 0);
      r2:       in std_logic_vector(31 downto 0);
      control:  in std_logic_vector(3 downto 0);
      cout:     out std_logic;
      overflow: out std_logic;
      resultValue:   out std_logic_vector(31 downto 0)
    );
  end component;
  
  signal r1, r2: std_logic_vector (31 downto 0);
  signal resultValue: std_logic_vector(31 downto 0);
  signal control: std_logic_vector(3 downto 0);
  signal cout, overflow: std_logic;

begin

  UUT: ALU
    port map(
      r1 => r1,
      r2 => r2,
      control => control,
      cout => cout,
      overflow => overflow,
      resultValue => resultValue
    );

    REGISTERS_DRIVER: process
    begin
      r1 <= (0 => '1', others => '0');
      r2 <= (1 => '1', others => '0');
      control <= "0000";
      wait for 50 us;
      control <= "1000";
      wait for 50 us;
      control <= "0010";
      wait for 50 us;
      control <= "0011";
      wait for 50 us;
      control <= "0100";
      wait for 50 us;
      control <= "0110";
      wait for 50 us;
      control <= "0111";
      wait;
    end process REGISTERS_DRIVER;

end ALU_TB_ARCH;
