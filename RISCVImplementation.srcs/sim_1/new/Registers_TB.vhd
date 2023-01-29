library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.basic.all;

entity Registers_TB is
end Registers_TB;

architecture Registers_TB_ARCH of Registers_TB is

  component Registers is
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
  end component;
  
  signal rs1, rs2, rd: unsigned(4 downto 0);
  signal writeData: std_logic_vector(31 downto 0);
  signal regWriteEn, clock, reset: std_logic;
  signal r1, r2: std_logic_vector(31 downto 0);

begin

  UUT: Registers
    port map(
      rs1 => rs1,
      rs2 => rs2,
      rd => rd,
      writeData => writeData,
      regWriteEn => regWriteEn,
      clock => clock,
      reset => reset,
      r1 => r1,
      r2 => r2
    );

  SYS_CLOCK: process
  begin
    clock <= not ACTIVE;
    wait for 5ns;
    clock <= ACTIVE;
    wait for 5 ns;
  end process SYS_CLOCK;
    
  SYS_RESET: process
  begin
    reset <= ACTIVE;
    wait for 100 ns;
    reset <= not ACTIVE;
    wait;
  end process SYS_RESET;
    
  REGISTERS_DRIVER: process
  begin
    regWriteEn <= not ACTIVE;
    writeData <= std_logic_vector(to_unsigned(1, 32));
    rs1 <= to_unsigned(0, 5);
    rs2 <= to_unsigned(0, 5);
    rd <= to_unsigned(0, 5);
    wait for 50 us;
    regWriteEn <= ACTIVE;
    wait;
  end process REGISTERS_DRIVER;
    
end Registers_TB_ARCH;
