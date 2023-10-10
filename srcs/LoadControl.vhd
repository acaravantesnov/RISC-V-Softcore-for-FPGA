library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LoadControl is
  port(
    MUXOutSig:        in  std_logic_vector(31 downto 0);
		br:								in	std_logic_vector(31 downto 0);
		nBits:            in  std_logic_vector(1 downto 0);
		signedOrUnsigned: in  std_logic;
		auipc:						in	std_logic;
		LoadControl:      out std_logic_vector(31 downto 0)
  );
end LoadControl;

architecture LoadControl_ARCH of LoadControl is

  signal nOfBits: natural;

  --function loadft(  MUXOutSig:        std_logic_vector(31 downto 0);
  --									br:								std_logic_vector(31 downto 0);
  --                  nOfBits:          natural;
  --                  signedOrUnsigned: std_logic;
  --                  auipc:						std_logic)
  --                  return std_logic_vector is
  --  variable vector:  std_logic_vector(31 downto 0);
  --begin
  --
	--	if (auipc = '1') then
	--		vector := br;
	--	elsif (signedOrUnsigned = '0') then -- zx
  --    vector := std_logic_vector(resize(unsigned(MUXOutSig(nOfBits - 1 downto 0)), 32));
  --  else
  --    vector := std_logic_vector(resize(signed(MUXOutSig(nOfBits - 1 downto 0)), 32));
  --  end if; 
  --
  --  return (vector);
  --
  --end function;

begin

--  with nBits
--    select nOfBits <= 8 when "00",
--                      16 when "01",
--                      32 when "10",
--                      32 when others;

--  LoadControl <= loadft(MUXOutSig, br, nOfBits, signedOrUnsigned, auipc);

  -- (Mario) He rehecho la función, poniendo valores fijos en los rangos
  process(nBits,auipc,MUXOutSig,br,signedOrUnsigned)
  begin
    if (auipc = '1') then
      LoadControl <= br;
    else  
      case nBits is 
      when "00" =>
        if (signedOrUnsigned = '0') then  
          LoadControl <= std_logic_vector(resize(unsigned(MUXOutSig( 7 downto 0)), 32));
        else 
          LoadControl <= std_logic_vector(resize(  signed(MUXOutSig( 7 downto 0)), 32));          
        end if; 
      when "01" => 
        if (signedOrUnsigned = '0') then  
          LoadControl <= std_logic_vector(resize(unsigned(MUXOutSig(15 downto 0)), 32));
        else 
          LoadControl <= std_logic_vector(resize(  signed(MUXOutSig(15 downto 0)), 32));          
        end if; 
      when others =>
          LoadControl <= MUXOutSig; 
      end case;
    end if; 
  end process; 
   
end LoadControl_ARCH;
