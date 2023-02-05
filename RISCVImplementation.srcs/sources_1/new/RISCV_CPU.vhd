library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BasicPkg.all;
use work.ComponentsPkg.all;

entity RISCV_CPU is
  port(
    regWriteEn: in std_logic;
    memWriteEn: in std_logic;
    memReadEn:  in std_logic;
    ALUMemSel:  in std_logic;
    immSel:     in std_logic_vector(1 downto 0);
    ALUOp:      in std_logic_vector(1 downto 0);
    regImmSel:  in std_logic;
    clock:      in std_logic;
    reset:      in std_logic
  );
end RISCV_CPU;

architecture RISCV_CPU_ARCH of RISCV_CPU is
  
  signal r1Sig, r2Sig, ALUResult, memOut, MUXOutSig: std_logic_vector(31 downto 0);
  signal inst, immValue, regOrImm: std_logic_vector(31 downto 0);
  signal ALUControlSig: std_logic_vector(3 downto 0);
  signal aux: std_logic_vector(9 downto 0);
  signal currentPC, nextPC: std_logic_vector(31 downto 0);

begin

  PC_U: ProgramCounter
    port map(
      nextAddress => nextPC,
      clock => clock,
      currentAddress => currentPC
    );

  INSMEM_U: InstructionMemory
    port map(
      readAddress => currentPC,
      instruction => inst
    );

  aux <= inst(31 downto 25) & inst(14 downto 12);
  ALUCONTR_U: ALUControl
    port map(
      input => aux,
      ALUOp => ALUOp,
      output => ALUControlSig
    );
    
  IMMSEL_U: ImmSelect
    port map(
      input => inst,
      immSel => immSel,
      output => immValue
    );

  REG_U: Registers
    port map(
      rs1 => unsigned(inst(19 downto 15)),
      rs2 => unsigned(inst(24 downto 20)),
      rd => unsigned(inst(11 downto 7)),
      writeData => MUXOutSig,
      regWriteEn => regWriteEn,
      clock => clock,
      reset => reset,
      r1 => r1Sig,
      r2 => r2Sig
    );
    
  with regImmSel
    select regOrImm <=  immValue        when '0',
                        r2Sig           when '1',
                        (others => '0') when others;

  ALU_U: ALU
    port map(
      r1 => r1Sig,
      r2 => regOrImm,
      control => ALUControlSig,
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
    select MUXOutSig <= memOut          when '0',
                        ALUResult       when '1',
                        (others => '0') when others;

end RISCV_CPU_ARCH;
