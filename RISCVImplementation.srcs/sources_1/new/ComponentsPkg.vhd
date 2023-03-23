--******************************************************************************
--*
--* Name: ComponentsPkg
--* Designer: Alberto Caravantes
--*
--* 
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ComponentsPkg is

  component ProgramCounter is
    port(
      nextAddress:    in std_logic_vector(31 downto 0);
      PCEn:           in std_logic;
      reset:          in std_logic;
      clock:          in std_logic;
      currentAddress: out std_logic_vector(31 downto 0)
    );
  end component;
  
  component InstructionMemory is
    port(
      readAddress: in std_logic_vector(31 downto 0);
      instruction: out std_logic_vector(31 downto 0)
    );
  end component;
  
  component singleRegister is
		port(
			input:   in std_logic_vector(31 downto 0);
			writeEn: in std_logic;
			reset:   in std_logic;
			clock:   in std_logic;
			output:  out std_logic_vector(31 downto 0)
		);
	end component;

  component RegisterFile is
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
  
  component ControlUnit is
    port(
      instruction:  in  std_logic_vector(31 downto 0);
      comparison:   in  std_logic_vector(2 downto 0);
      reset:        in  std_logic;
      clock:        in  std_logic;
      microcode:    out std_logic_vector(16 downto 0)
    );
  end component;
  
  component Comparison is
  port(
    r1:         in std_logic_vector(31 downto 0);
    r2:         in std_logic_vector(31 downto 0);
    comparison: out std_logic_vector(2 downto 0)
  );
  end component;
    
  component ALU is
    port (
      r1:           in std_logic_vector(31 downto 0);
      r2:           in std_logic_vector(31 downto 0);
      control:      in std_logic_vector(3 downto 0);
      zero:         out std_logic;
      cOut:         out std_logic;
      overflow:     out std_logic;
      resultValue:  out std_logic_vector(31 downto 0)
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
  
  component BranchControl is
    port(
      branch:       in  std_logic;
      forceBranch:  in  std_logic;
      zero:         in  std_logic;
      PCSel:        out std_logic
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
  
  component ImmSelect is
    port (
      input:  in std_logic_vector(31 downto 0);
      immSel: in std_logic_vector(1 downto 0);
      output: out std_logic_vector(31 downto 0)
    );
  end component;
  
  component ALUControl is
    port(
      input:  in std_logic_vector(9 downto 0);
      ALUop:  in std_logic_vector(1 downto 0);
      output: out std_logic_vector(3 downto 0)
    );
  end component;
  
  component LoadControl is
    port(
      MUXOutSig:        in  std_logic_vector(31 downto 0);
      nBits:            in  std_logic_vector(1 downto 0);
      signedOrUnsigned: in  std_logic;
      LoadControl:      out std_logic_vector(31 downto 0)
    );
  end component;

end package;