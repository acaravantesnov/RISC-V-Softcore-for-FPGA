library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BasicPkg.all;
use work.ComponentsPkg.all;

entity RISCV_CPU_TB is
end RISCV_CPU_TB;

architecture RISCV_CPU_TB_ARCH of RISCV_CPU_TB is

  component RISCV_CPU is
    port(
      rs1:        in unsigned(4 downto 0);
      rs2:        in unsigned(4 downto 0);
      rd:         in unsigned(4 downto 0);
      regWriteEn: in std_logic;
      memWriteEn: in std_logic;
      memReadEn:  in std_logic;
      ALUControl: in std_logic_vector(3 downto 0);
      ALUMemSel:  in std_logic;
      clock:      in std_logic;
      reset:      in std_logic;
      MUXOut:     out std_logic_vector(31 downto 0)
    );
  end component;

  signal rs1, rs2, rd: unsigned(4 downto 0);
  signal regWriteEn, memWriteEn, memReadEn, ALUMemSel, clock, reset: std_logic;
  signal ALUControl: std_logic_vector(3 downto 0);
  signal MUXOut: std_logic_vector(31 downto 0);

begin

  UUT: RISCV_CPU
    port map(
      rs1 => rs1,
      rs2 => rs2,
      rd => rd,
      regWriteEn => regWriteEn,
      memWriteEn => memWriteEn,
      memReadEn => memReadEn,
      ALUControl => ALUControl,
      ALUMemSel => ALUMemSel,
      clock => clock,
      reset => reset,
      MUXOut => MUXOut
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
    
  RISCV_CPUDRIVER: process
  begin
    rs1 <= (others => '0');
    rs2 <= (others => '0');
    rd <= (others => '0');
    regWriteEn <= ACTIVE;
    ALUControl <= "0000";
    memReadEn <= not ACTIVE;
    memWriteEn <= not ACTIVE;
    ALUMemSel <= ACTIVE;
    wait for 50 us;
    rs1 <= to_unsigned(1, 5);
    rs2 <= to_unsigned(2, 5);
    rd <= to_unsigned(3, 5);
    wait;
  end process;

end RISCV_CPU_TB_ARCH;