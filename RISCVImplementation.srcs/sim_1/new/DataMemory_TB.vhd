library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.basic.all;

entity DataMemory_TB is
end DataMemory_TB;

architecture DataMemory_TB_ARCH of DataMemory_TB is

  component DataMemory is
    port(
      memWriteEn: in std_logic;
      address:    in std_logic_vector(31 downto 0);
      dataIn:     in std_logic_vector(31 downto 0);
      clock:      in std_logic;
      dataOut:    out std_logic_vector(31 downto 0)
    );
  end component;
  
  signal memWriteEn, clock: std_logic;
  signal address, dataIn, dataOut: std_logic_vector(31 downto 0);

begin

  UUT: DataMemory
    port map(
      memWriteEn => memWriteEn,
      address => address,
      dataIn => dataIn,
      clock => clock,
      dataOut => dataOut
    );

  SYS_CLOCK: process
  begin
    clock <= '0';
    wait for 5ns;
    clock <= '1';
    wait for 5 ns;
  end process SYS_CLOCK;
    
  DATAMEMORY_DRIVER: process
  begin
    memWriteEn <= '0';
    dataIn <= std_logic_vector(to_unsigned(1, 32));
    address <= (2 => '1', 0 => '1', others => '0');
    wait for 50 us;
    memWriteEn <= '1';
    wait;
  end process DATAMEMORY_DRIVER;
    
end DataMemory_TB_ARCH;
