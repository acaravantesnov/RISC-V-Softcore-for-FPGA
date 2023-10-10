library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ComponentsPkg.all;

entity RISCV_CPU is
  port(
    clk:       	 	in 		std_logic;
    reset:      	in 		std_logic;
    GPIOPins:		inout   std_logic_vector(31 downto 0)
  );
end RISCV_CPU;

architecture RISCV_CPU_ARCH of RISCV_CPU is

  signal nextPC:						std_logic_vector(31 downto 0);
  signal currentPC:					std_logic_vector(31 downto 0);
  signal newIns:            std_logic_vector(31 downto 0);
  signal newInsexception:   std_logic_vector(31 downto 0);
  signal PCPlus4:           std_logic_vector(31 downto 0);
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
  signal dataEn:						std_logic;
  signal GPIOEn:						std_logic;
  signal GPIOOut:						std_logic_vector(31 downto 0);
  signal TimerEn:						std_logic;
  signal TimerOut:					std_logic_vector(31 downto 0);
	signal clock:             std_logic;
  signal exceptionStatus:		std_logic;
  signal mcauseSig:					std_logic_vector(31 downto 0) := (others => '0');

  signal CSRInput:					std_logic_vector(31 downto 0);
  signal CSROutput:					std_logic_vector(31 downto 0);
  --signal index:					natural range 0 to 1; -- (Mario) Ya no hace falta 

  signal microcode:         std_logic_vector(23 downto 0);
  ----microcode-signals------------------------------------------------SIGNALS
  signal CSRWriteEn:				std_logic;
  signal atomicOpt:					std_logic_vector(1 downto 0);
  signal r1orzimm:					std_logic;
  signal auipc:							std_logic;
  signal PCEn:              std_logic;
  signal insRegEn:          std_logic;
  signal ALUop:             std_logic_vector(1 downto 0);
  signal immSel:            std_logic_vector(2 downto 0);
  signal regWriteEn:        std_logic;
  signal wdSel:             std_logic_vector(1 downto 0);
  signal regImmSel:         std_logic;
  signal jumpSel:           std_logic;
	signal PCSel:							std_logic;
  signal memWriteEn:        std_logic;
  signal ALUMemSel:         std_logic_vector(1 downto 0);
  signal nBits:             std_logic_vector(1 downto 0);
  signal signedOrUnsigned:  std_logic;
  signal IRQ:								std_logic;

	component clk_wiz_0
		port
		(
			 clk_out1          : out    std_logic;
			 reset             : in     std_logic;
			 locked            : out    std_logic;
			 clk_in1           : in     std_logic
		 );
	end component;

begin

	CLK50: clk_wiz_0
	 port map
	 ( 
		 clk_out1 => clock,
		 reset => reset,
		 locked => open,
		 clk_in1 => clk
	 	);

	CSRWriteEn				<= microcode(23);
	atomicOpt					<= microcode(22 downto 21);
	r1orzimm					<= microcode(20);
	auipc							<= microcode(19);
  PCEn              <= microcode(18);
  insRegEn          <= microcode(17);
  ALUOp             <= microcode(16 downto 15);
  immSel            <= microcode(14 downto 12);
  regWriteEn        <= microcode(11);
  wdSel             <= microcode(10 downto 9);
  regImmSel         <= microcode(8);
  jumpSel           <= microcode(7);
  PCSel       			<= microcode(6);
  memWriteEn        <= microcode(5);
  ALUMemSel         <= microcode(4 downto 3);
  nBits             <= microcode(2 downto 1);
  signedOrUnsigned  <= microcode(0);

  PC_U: ProgramCounter
    port map(
      nextAddress => nextPC,
      PCEn => PCEn,
      reset => reset,
      clock => clock,
      currentAddress => currentPC
    );

  INSMEM_U: InstructionMemory
    port map(
      readAddress => currentPC,
      instruction => newIns
    );

	PCPlus4 <= std_logic_vector(unsigned(currentPC) + 4);

	EXCEPTIONCNTRL_U: ExceptionControl
		port map(
			input => newIns,
			exceptionstatus => exceptionStatus,
			output => newInsException
		);

  INSREG_U: singleRegister
  	generic map(
  		REGSIZE => 32
  	)
    port map(
      input => newInsException,
      writeEn => insRegEn,
      reset => reset,
      clock => clock,
      output => inst
    );

  ALUCONTR_U: ALUControl
    port map(
      input => inst,
      ALUop => ALUop,
      output => ALUControlSig
    );

  IMMSEL_U: ImmSelect
    port map(
      input => inst,
      immSel => immSel,
      output => immValue
    );

  with wdSel
    select writeData <= PCPlus4					when "00",
                        loadControlOut	when "01",
                        CSROutput				when "10",
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
								
  CSRS_U: CSRs
  	port map(
  		input => CSRInput,
  		CSRWriteEn => CSRWriteEn,
  		atomicOpt => atomicOpt,
  		CSRSel => inst(20),
  		exceptionStatus => exceptionStatus,
  		mcause => mcauseSig,
  		clock => clock,
  		reset => reset,
  		output => CSROutput
  	);

  CU_U: ControlUnit
    port map(
      instruction => inst,
      comparison => comp,
      ALUresult => ALUresult,
      IRQ => IRQ,
      reset => reset,
      clock => clock,
      microcode => microcode,
      exceptionStatus => exceptionStatus,
      mcause => mcauseSig
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
                        r2Sig           when others;

  br <= std_logic_vector(signed(currentPC) + signed(immValue));

  ALU_U: ALU
    port map(
      r1 => r1Sig,
      r2 => regOrImm,
      control => ALUControlSig,
      overflow => open, --overflowSig,
      resultValue => ALUResult
    );

  STOREC_U: StoreControl
  	port map(
  		input => r2Sig,
  		instruction => inst,
  		output => dataIn
  	);

  with r1orzimm
  select CSRInput <= r1Sig when '0',
                     immValue when others;

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
      clock => clock,
      dataOut => memOut
    );

  GPIOEn <= memWriteEn and ALUresult(12) and (not ALUresult(13));
  GPIO_U: GPIO
  	port map(
  		writeEn => GPIOEn,
  		address => ALUresult(1 downto 0),
  		dataIn => dataIn,
  		reset => reset,
  		clock => clock,
  		dataOut => GPIOOut,
  		data => GPIOPins
  	);
  	
  TimerEn <= memWriteEn and ALUresult(12) and ALUresult(13);
  TIMER_U: Timer
  	port map(
  		address => ALUresult(1 downto 0),
  		dataIn => dataIn,
  		writeEn => TimerEn,
  		reset => reset,
  		clock => clock,
  		dataOut => TimerOut,
  		timerInterrupt => IRQ
  	);

  with ALUMemSel
    select MUXOutSig <= memOut          when "00",
                        ALUResult       when "01",
                        GPIOOut					when "10",
                        TimerOut				when others;

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
