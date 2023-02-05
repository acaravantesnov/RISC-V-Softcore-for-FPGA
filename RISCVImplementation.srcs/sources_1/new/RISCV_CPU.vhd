library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BasicPkg.all;
use work.ComponentsPkg.all;

entity RISCV_CPU is
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
    MUXOut:     out std_logic_vector(31 downto 0));
end RISCV_CPU;

architecture RISCV_CPU_ARCH of RISCV_CPU is
  
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
    
  MEM_U: DataMemory
    port map(
      memWriteEn => memWriteEn,
      memReadEn => memReadEn,
      address => ALUResult,
      dataIn => r2Sig,
      clock => clock,
      dataOut => memOut
    );

  with ALUMemSel
    select MUXOutSig <= memOut          when '1',
                        ALUResult       when '0',
                        (others => '0') when others;

  MUXOut <= MUXOutSig;

end RISCV_CPU_ARCH;
