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
  signal newIns:            std_logic_vector(31 downto 0);
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

  -- insRegEn & regWriteEn & ALUOp & immSel & regImmSel & branch & memWriteEn & ALUMemSel
  signal microcode:         std_logic_vector(9 downto 0);

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
      instruction => newIns
    );
  
  ADDALU_1_U: ALU
    port map(
      r1 => currentPC,
      r2 => std_logic_vector(to_unsigned(4, 32)),
      control => "0000",
      resultValue => PCPlus4
    );
    
  INS_REG: singleRegister
    port map(
      input => newIns,
      writeEn => microcode(9),
      reset => reset,
      clock => clock,
      output => inst
    );

  aux1 <= inst(31 downto 25) & inst(14 downto 12);
  ALUCONTR_U: ALUControl
    port map(
      input => aux1,
      ALUOp => microcode(7 downto 6),
      output => ALUControlSig
    );
    
  IMMSEL_U: ImmSelect
    port map(
      input => inst,
      immSel => microcode(5 downto 4),
      output => immValue
    );

  REG_U: Registers
    port map(
      rs1 => unsigned(inst(19 downto 15)),
      rs2 => unsigned(inst(24 downto 20)),
      rd => unsigned(inst(11 downto 7)),
      writeData => MUXOutSig,
      regWriteEn => microcode(8),
      clock => clock,
      reset => reset,
      r1 => r1Sig,
      r2 => r2Sig
    );

  CU_U: ControlUnit
    port map(
      instruction => inst,
      clock => clock,
      microcode => microcode
    );

  with microcode(3)
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
  
  PCSel <= microcode(2) and zeroSig;
  with PCSel
    select nextPC <=  PCPlus4         when '0',
                      br              when '1',
                      (others => '0') when others;
    
  MEM_U: DataMemory
    port map(
      memWriteEn => microcode(1),
      address => ALUResult,
      dataIn => r2Sig,
      clock => clock,
      dataOut => memOut
    );

  with microcode(0)
    select MUXOutSig <= memOut          when '0',
                        ALUResult       when '1',
                        (others => '0') when others;

end RISCV_CPU_ARCH;
