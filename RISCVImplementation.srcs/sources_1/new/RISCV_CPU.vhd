--******************************************************************************
--*
--* Name: RISCV_CPU
--* Designer: Alberto Caravantes
--*
--* Single core RV32I embedded design implemented in VHDL.
--*	32 32-bit registers. Total memory of 256kB. Byte addressable, big endian.
--*	Made up of 13 different components:
--*
--*		-	Program Counter
--*		-	Instruction Memory
--*		-	Instruction Register
--*		-	ALU Control								
--*		-	Immediate Select
--*		-	Register File
--*		-	Control Unit
--*		-	Comparison
--*		-	ALU
--*		-	Jump Control
--*		- Data Memory
--*		- Load Control
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BasicPkg.all;
use work.ComponentsPkg.all;

entity RISCV_CPU is
  port(
    clock:      in 	std_logic;
    reset:      in 	std_logic;
    outputSel:	in 	std_logic_vector(3 downto 0);
    GPIOOut:		out std_logic_vector(31 downto 0)
  );
end RISCV_CPU;

architecture RISCV_CPU_ARCH of RISCV_CPU is

  signal nextPC:						std_logic_vector(31 downto 0);
  signal currentPC:					std_logic_vector(31 downto 0);
  signal newIns:            std_logic_vector(31 downto 0);
  signal PCPlus4:           std_logic_vector(31 downto 0);
  signal aux1:              std_logic_vector(9 downto 0);
  signal inst:              std_logic_vector(31 downto 0);
  signal MUXOutSig:         std_logic_vector(31 downto 0);
  signal writeData:         std_logic_vector(31 downto 0);
  signal ALUControlSig:     std_logic_vector(3 downto 0);
  signal immValue:          std_logic_vector(31 downto 0);
  signal r1Sig:							std_logic_vector(31 downto 0);
  signal r2Sig:      				std_logic_vector(31 downto 0);
  signal dataIn:						std_logic_vector(31 downto 0);
  signal regOrImm:          std_logic_vector(31 downto 0);
  signal br:                std_logic_vector(31 downto 0);
  signal ALUResult:         std_logic_vector(31 downto 0);
  signal memOut:            std_logic_vector(31 downto 0);
  signal loadControlOut:    std_logic_vector(31 downto 0);
  signal comp:              std_logic_vector(2 downto 0);
  signal mcauseIn:					std_logic_vector(3 downto 0);
  signal mcause:						std_logic_vector(3 downto 0);
  signal dataEn:						std_logic;
  signal GPIOEn:						std_logic;
  
  signal exceptionSig:			std_logic;

  signal microcode:         std_logic_vector(17 downto 0);
  ----microcode-signals------------------------------------------------SIGNALS
  signal auipc:							std_logic;
  signal PCEn:              std_logic;
  signal insRegEn:          std_logic;
  signal ALUOp:             std_logic_vector(1 downto 0);
  signal immSel:            std_logic_vector(2 downto 0);
  signal regWriteEn:        std_logic;
  signal wdSel:             std_logic;
  signal regImmSel:         std_logic;
  signal jumpSel:           std_logic;
	signal PCSel:							std_logic;
  signal memWriteEn:        std_logic;
  signal ALUMemSel:         std_logic;
  signal nBits:             std_logic_vector(1 downto 0);
  signal signedOrUnsigned:  std_logic;

begin

	auipc							<= microcode(17);
  PCEn              <= microcode(16);
  insRegEn          <= microcode(15);
  ALUOp             <= microcode(14 downto 13);
  immSel            <= microcode(12 downto 10);
  regWriteEn        <= microcode(9);
  wdSel             <= microcode(8);
  regImmSel         <= microcode(7);
  jumpSel           <= microcode(6);
  PCSel       			<= microcode(5);
  memWriteEn        <= microcode(4);
  ALUMemSel         <= microcode(3);
  nBits             <= microcode(2 downto 1);
  signedOrUnsigned  <= microcode(0);

  PC_U: ProgramCounter
    port map(
      nextAddress => nextPC,
      PCEn => PCEn,
      reset => reset,
      clock => clock,
      exception => exceptionSig,
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

  INSREG_U: singleRegister
  	generic map(
  		REGSIZE => 32
  	)
    port map(
      input => newIns,
      writeEn => insRegEn,
      reset => reset,
      clock => clock,
      output => inst
    );

  ALUCONTR_U: ALUControl
    port map(
      input => inst,
      ALUOp => ALUOp,
      output => ALUControlSig
    );

  IMMSEL_U: ImmSelect
    port map(
      input => inst,
      immSel => immSel,
      output => immValue
    );

  with wdSel
    select writeData <= PCPlus4					when '0',
                        loadControlOut	when '1',
                        (others => '0')	when others;

  REGFILE_U: RegisterFile
    port map(
      rs1 => unsigned(inst(19 downto 15)),
      rs2 => unsigned(inst(24 downto 20)),
      rd => unsigned(inst(11 downto 7)),
      writeData => writeData,
      regWriteEn => regWriteEn,
      clock => clock,
      reset => reset,
      r1 => r1Sig,
      r2 => r2Sig
    );

  CU_U: ControlUnit
    port map(
      instruction => inst,
      comparison => comp,
      reset => reset,
      clock => clock,
      microcode => microcode,
      mcause => mcauseIn,
      exceptionSig => exceptionSig
    );

  COMP_U: Comparison
    port map(
    	instruction => inst,
      r1 => r1Sig,
      r2 => r2Sig,
      comparison => comp
    );

  with regImmSel
    select regOrImm <=  immValue        when '0',
                        r2Sig           when '1',
                        (others => '0') when others;

  ADDALU_2_U: ALU
    port map(
      r1 => currentPC,
      r2 => immValue,
      control => "0000",
      resultValue => br
    );

  ALU_U: ALU
    port map(
      r1 => r1Sig,
      r2 => regOrImm,
      control => ALUControlSig,
      resultValue => ALUResult
    );
    
  STOREC_U: StoreControl
  	port map(
  		input => r2Sig,
  		instruction => inst,
  		output => dataIn
  	);

  MCAUSEREG_U: singleRegister
  	generic map(
  		REGSIZE => 4
  	)
  	port map(
  		input => mcauseIn,
  		writeEn => '1',
  		reset => reset,
  		clock => clock,
  		output => mcause
  	);

  JUMPC_U: JumpControl
    port map(
      jumpSel => jumpSel,
      PCPlus4 => PCPlus4,
      branch => br,
      PCSel => PCSel,
      ALUresult => ALUresult,
      nextPC => nextPC
    );

	dataEn <= memWriteEn and (not ALUresult(12));
  MEM_U: DataMemory
    port map(
      writeEn => dataEn,
      address => ALUResult(11 downto 0),
      dataIn => dataIn,
      reset => reset,
      clock => clock,
      dataOut => memOut
    );
    
  GPIOEn <= memWriteEn and ALUresult(12);
  GPIO_U: GPIO
  	port map(
  		writeEn => GPIOEn,
  		address => ALUresult(3 downto 0),
  		dataIn => dataIn,
  		outputSel => outputSel,
  		reset => reset,
  		clock => clock,
  		dataOut => GPIOOut
  	);

  with ALUMemSel
    select MUXOutSig <= memOut          when '0',
                        ALUResult       when '1',
                        (others => '0') when others;

  LOADC_U: LoadControl
    port map(
      MUXOutSig => MUXOutSig,
      br => br,
      nBits => nBits,
      signedOrUnsigned => signedOrUnsigned,
      auipc => auipc,
      LoadControl => LoadControlOut
    );

end RISCV_CPU_ARCH;
