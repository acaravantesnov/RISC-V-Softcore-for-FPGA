library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BasicPkg.all;
use work.ComponentsPkg.all;

entity RISCV_CPU is
  port(
    clock:      in std_logic;
    reset:      in std_logic
  );
end RISCV_CPU;

architecture RISCV_CPU_ARCH of RISCV_CPU is
  
  signal nextPC, currentPC: std_logic_vector(31 downto 0);
  signal PCPlus4:           std_logic_vector(31 downto 0);
  signal aux1:              std_logic_vector(9 downto 0);
  signal inst:              std_logic_vector(31 downto 0);
  signal MUXOutSig:         std_logic_vector(31 downto 0);
  signal ALUControlSig:     std_logic_vector(3 downto 0);
  signal immValue:          std_logic_vector(31 downto 0);
  signal r1Sig, r2Sig:      std_logic_vector(31 downto 0);
  signal regOrImm:          std_logic_vector(31 downto 0);
  signal aux2:              std_logic_vector(31 downto 0);
  signal br:                std_logic_vector(31 downto 0);
  signal PCSel:             std_logic;
  signal zeroSig:           std_logic;
  signal ALUResult:         std_logic_vector(31 downto 0);
  signal memOut:            std_logic_vector(31 downto 0);
  
  signal regWriteEn:        std_logic;
  signal ALUOp:             std_logic_vector(1 downto 0);
  signal immSel:            std_logic_vector(1 downto 0);
  signal regImmSel:         std_logic;
  signal branch:            std_logic;
  signal memWriteEn:        std_logic;
  signal ALUMemSel:         std_logic;

begin

  PC_U: ProgramCounter
    port map(
      nextAddress => nextPC,
      clock => clock,
      currentAddress => currentPC
    );
    
  ADDALU_1_U: ALU
    port map(
      r1 => currentPC,
      r2 => std_logic_vector(to_unsigned(4, 32)),
      control => "0000",
      resultValue => PCPlus4
    );

  INSMEM_U: InstructionMemory
    port map(
      readAddress => currentPC,
      instruction => inst
    );

  aux1 <= inst(31 downto 25) & inst(14 downto 12);
  ALUCONTR_U: ALUControl
    port map(
      input => aux1,
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
    
  CU_U: ControlUnit
    port map(
      instruction => inst,
      regWriteEn => regWriteEn,
      ALUOp => ALUOp,
      immSel => immSel,
      regImmSel => regImmSel,
      branch => branch,
      memWriteEn => memWriteEn,
      ALUMemSel => ALUMemSel
    );

  with regImmSel
    select regOrImm <=  immValue        when '0',
                        r2Sig           when '1',
                        (others => '0') when others;

  aux2 <= std_logic_vector(shift_left(unsigned(immValue), 1));
  ADDALU_2_U: ALU
    port map(
      r1 => PCPlus4,
      r2 => aux2,
      control => "0000",
      resultValue => br
    );

  ALU_U: ALU
    port map(
      r1 => r1Sig,
      r2 => regOrImm,
      control => ALUControlSig,
      zero => zeroSig,
      resultValue => ALUResult
    );
  
  PCSel <= branch and zeroSig;
  with PCSel
    select nextPC <=  PCPlus4         when '0',
                      br              when '1',
                      (others => '0') when others;
    
  MEM_U: DataMemory
    port map(
      memWriteEn => memWriteEn,
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
