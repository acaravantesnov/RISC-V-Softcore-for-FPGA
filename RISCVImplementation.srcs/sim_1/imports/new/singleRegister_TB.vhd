library ieee;
use ieee.std_logic_1164.all;

entity singleRegister_TB is
end singleRegister_TB;

architecture singleRegister_TB_ARCH of singleRegister_TB is

    constant ACTIVE: std_logic := '1';

    --unit-under-test---------------------------------------COMPONENT
    component singleRegister is
        port(
            input:      in std_logic_vector(31 downto 0);
            writeEn:    in std_logic;
            reset:      in std_logic;
            clock:      in std_logic;
            output:     out std_logic_vector(31 downto 0)
        );
    end component;

    signal input:      std_logic_vector(31 downto 0);
    signal writeEn:    std_logic;
    signal reset:      std_logic;
    signal clock:      std_logic;
    signal output:     std_logic_vector(31 downto 0);

begin

    UUT: singleRegister
        port map(
            input => input,
            writeEn => writeEn,
            reset => reset,
            clock => clock,
            output => output
        );
        
    SYSTEM_CLOCK: process
    begin
        clock <= not ACTIVE;
        wait for 5 ns;
        clock <= ACTIVE;
        wait for 5 ns;
    end process SYSTEM_CLOCK;
    
    SYSTEM_RESET: process
    begin
        reset <= ACTIVE;
        wait for 20 ns;
        reset <= not ACTIVE;
        wait;
    end process SYSTEM_RESET;
    
    SINGLE_REGISTER_DRIVER: process
    begin
        writeEn <= not ACTIVE;
        wait for 40ns;
        writeEn <= ACTIVE;
        input <= "00000000000000000000000000000001";
        wait for 100ns;
        
        input <= "00000000000000000000000000000011";
        wait for 100ns;
        
        input <= "00000000000000000000000000000111";
        wait for 100ns;
        
        input <= "00000000000000000000000000001111";
        wait for 100ns;
        
        input <= "00000000000000000000000000011111";
        wait for 100ns;
        
        input <= "00000000000000000000000000111111";
        wait for 100ns;
        
        input <= "00000000000000000000000000000011";
        wait;
    end process SINGLE_REGISTER_DRIVER;

end singleRegister_TB_ARCH;
