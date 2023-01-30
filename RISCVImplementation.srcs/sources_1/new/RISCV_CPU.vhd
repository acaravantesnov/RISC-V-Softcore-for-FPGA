library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.basic.all;

entity RISCV_CPU is
  port(
    rs1:        in unsigned(4 downto 0);
    rs2:        in unsigned(4 downto 0);
    rd:         in unsigned(4 downto 0);
    regWriteEn: in std_logic;
    memWriteEn: in std_logic;
    ALUControl: in std_logic_vector(3 downto 0);
    ALUMemSel:  in std_logic;
    clock:      in std_logic;
    reset:      in std_logic;
    MUXOut:     out std_logic_vector(31 downto 0));
end RISCV_CPU;

architecture RISCV_CPU_ARCH of RISCV_CPU is

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
    
    component ALU is
      port (
        r1:           in std_logic_vector(31 downto 0);
        r2:           in std_logic_vector(31 downto 0);
        control:      in std_logic_vector(3 downto 0);
        cOut:         out std_logic;
        overflow:     out std_logic;
        resultValue:  out std_logic_vector(31 downto 0)
      );
    end component;

  component DataMemory is
    port(
      memWriteEn: in std_logic;
      address:    in std_logic_vector(31 downto 0);
      dataIn:     in std_logic_vector(31 downto 0);
      clock:      in std_logic;
      dataOut:    out std_logic_vector(31 downto 0)
    );
  end component;
  
  signal r1Sig, r2Sig, ALUResult, memOut, MUXOutSig: std_logic_vector(31 downto 0);

begin

  REG_U: Registers
    port map(
      rs1 => rs1,
      rs2 => rs2,
      rd => rd,
      writeData => MUXOutSig,
      regWriteEn => regWriteEn,
      clock => clock,
      reset => reset,
      r1 => r1Sig,
      r2 => r2Sig
    );
    
    ALU_U: ALU
      port map(
        r1 => r1Sig,
        r2 => r2Sig,
        control => ALUControl,
        resultValue => ALUResult
      );
      
    DMEM_U: DataMemory
      port map(
        memWriteEn => memWriteEn,
        address => ALUResult,
        dataIn => r2Sig,
        clock => clock,
        dataOut => memOut
      );
      
    with ALUMemSel select MUXOutSig <=
      memOut when ACTIVE,
      ALUResult when not ACTIVE;

end RISCV_CPU_ARCH;
