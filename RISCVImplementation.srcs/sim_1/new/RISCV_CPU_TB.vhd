library ieee;
use ieee.std_logic_1164.all;

entity RISCV_CPU_TB is
end RISCV_CPU_TB;

architecture RISCV_CPU_TB_ARCH of RISCV_CPU_TB is

  component RISCV_CPU is
    port(
      clock:      in 	std_logic;
      reset:      in 	std_logic;
      outputSel:	in 	std_logic_vector(3 downto 0);
      GPIOOut:		out	std_logic_vector(31 downto 0)
    );
  end component;
  
  signal clock: 		std_logic;
  signal reset: 		std_logic;
  signal outputSel: std_logic_vector(3 downto 0);
  signal GPIOOut: 	std_logic_vector(31 downto 0);

begin

  UUT: RISCV_CPU
    port map(
      clock => clock,
      reset => reset,
      outputSel => outputSel,
      GPIOOut => GPIOOut
    );
  
  GPIO_SEL:	process
  begin
  	outputSel <= "0010";
  	wait;
  end process GPIO_SEL;
  
  SYS_CLOCK: process
  begin
    clock <= '0';
    wait for 5ns;
    clock <= '1';
    wait for 5 ns;
  end process SYS_CLOCK;
    
  SYS_RESET: process
  begin
    reset <= '1';
    wait for 100 ns;
    reset <= '0';
    wait;
  end process SYS_RESET;

end RISCV_CPU_TB_ARCH;
