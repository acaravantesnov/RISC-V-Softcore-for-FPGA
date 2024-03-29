library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ComponentsPkg is

  component ProgramCounter is
    port(
      nextAddress:    in	std_logic_vector(31 downto 0);
      PCEn:           in	std_logic;
      reset:          in	std_logic;
      clock:          in	std_logic;
      currentAddress: out	std_logic_vector(31 downto 0)
    );
  end component;

  component InstructionMemory is
    port(
      readAddress:			in	std_logic_vector(31 downto 0);
      instruction:			out	std_logic_vector(31 downto 0)
    );
  end component;

  component ExceptionControl is
		port(
			input:						in 	std_logic_vector(31 downto 0);
			exceptionStatus:	in 	std_logic;
			output:						out	std_logic_vector(31 downto 0)
		);
	end component;

  component singleRegister is
  	generic(
			REGSIZE: natural
		);
		port(
			input:   in		std_logic_vector(REGSIZE - 1 downto 0);
			writeEn: in		std_logic;
			reset:   in		std_logic;
			clock:   in		std_logic;
			output:  out	std_logic_vector(REGSIZE - 1 downto 0)
		);
	end component;

  component RegisterFile is
    port(
      rs1:        in	unsigned(4 downto 0);
      rs2:        in	unsigned(4 downto 0);
      rd:         in	unsigned(4 downto 0);
      writeData:  in	std_logic_vector(31 downto 0);
      regWriteEn: in	std_logic;
      clock:			in	std_logic;
      reset:      in	std_logic;
      r1:         out	std_logic_vector(31 downto 0);
      r2:         out	std_logic_vector(31 downto 0)
     );
  end component;

  component CSRs is
		port(
			input:			in	std_logic_vector(31 downto 0);
			CSRWriteEn: 		in	std_logic;
			atomicOpt:		in	std_logic_vector(1 downto 0);
			CSRSel:			in	std_logic; -- natural (Mario) mejor pasar un bit
			exceptionStatus:	in	std_logic;
			mcause:			in	std_logic_vector(31 downto 0);
			clock:			in	std_logic;
			reset:			in	std_logic;
			output:			out std_logic_vector(31 downto 0)
		);
	end component;

  component ControlUnit is
    port(
      instruction:  		in  std_logic_vector(31 downto 0);
      comparison:   		in  std_logic_vector(2 downto 0);
      ALUresult:				in	std_logic_vector(31 downto 0);
      IRQ:							in	std_logic;
      reset:        		in  std_logic;
      clock:        		in  std_logic;
      microcode:    		out std_logic_vector(23 downto 0);
      exceptionStatus:	out std_logic;
      mcause:						out std_logic_vector(31 downto 0)
    );
  end component;

  component Comparison is
		port(
			instruction:	in	std_logic_vector(31 downto 0);
			r1:         	in	std_logic_vector(31 downto 0);
			r2:         	in	std_logic_vector(31 downto 0);
			comparison: 	out	std_logic_vector(2 downto 0)
		);
  end component;

  component ALU is
    port (
      r1:           in	std_logic_vector(31 downto 0);
      r2:           in	std_logic_vector(31 downto 0);
      control:      in	std_logic_vector(3 downto 0);
      overflow:     out	std_logic;
      resultValue:  out	std_logic_vector(31 downto 0)
    );
  end component;

  component StoreControl is
		port(
			input:				in	std_logic_vector(31 downto 0);
			instruction:	in	std_logic_vector(31 downto 0);
			output:				out	std_logic_vector(31 downto 0)
		);
	end component;

  component JumpControl is
    port(
      jumpSel:    in  std_logic;
      PCPlus4:    in  std_logic_vector(31 downto 0);
      branch:     in  std_logic_vector(31 downto 0);
      PCSel:      in  std_logic;
      ALUresult:  in  std_logic_vector(31 downto 0);
      nextPC:     out std_logic_vector(31 downto 0)
    );
  end component;

  component DataMemory is
    port(
      writeEn: 		in	std_logic;
      address:    in	std_logic_vector(11 downto 0);
      dataIn:     in	std_logic_vector(31 downto 0);
      clock:      in	std_logic;
      dataOut:    out	std_logic_vector(31 downto 0)
    );
  end component;
  
  component GPIO is
		port(
			writeEn:		in 		std_logic;
			address:		in 		std_logic_vector(1 downto 0);
			dataIn:			in 		std_logic_vector(31 downto 0);
			reset:			in 		std_logic;
			clock:			in 		std_logic;
			dataOut:		out		std_logic_vector(31 downto 0);
			data:				inout std_logic_vector(31 downto 0)
		);
	end component;
	
	component Timer is
		port(
			address:				in	std_logic_vector(1 downto 0);
			dataIn:					in	std_logic_vector(31 downto 0);
			writeEn:				in	std_logic;
			reset:					in	std_logic;
			clock:					in	std_logic;
			dataOut:				out	std_logic_vector(31 downto 0);
			timerInterrupt:	out	std_logic
		);
	end component;
  
  component ImmSelect is
    port (
      input:  in	std_logic_vector(31 downto 0);
      immSel: in	std_logic_vector(2 downto 0);
      output: out	std_logic_vector(31 downto 0)
    );
  end component;
  
  component ALUControl is
    port(
      input:  in	std_logic_vector(31 downto 0);
      ALUop:  in	std_logic_vector(1 downto 0);
      output: out	std_logic_vector(3 downto 0)
    );
  end component;
  
  component LoadControl is
    port(
      MUXOutSig:        in  std_logic_vector(31 downto 0);
      br:								in	std_logic_vector(31 downto 0);
      nBits:            in  std_logic_vector(1 downto 0);
      signedOrUnsigned: in  std_logic;
      auipc:						in	std_logic;
      LoadControl:      out std_logic_vector(31 downto 0)
    );
  end component;

end package;
