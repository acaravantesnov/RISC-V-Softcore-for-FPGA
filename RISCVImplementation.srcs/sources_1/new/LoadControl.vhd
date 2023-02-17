--******************************************************************************
--*
--* Name: LoadControl
--* Designer: Alberto Caravantes
--*
--* 
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LoadControl is
  port(
    MUXOutSig:        in  std_logic_vector(31 downto 0);
    nBits:            in  std_logic_vector(1 downto 0);
    signedOrUnsigned: in  std_logic;
    LoadControl:      out std_logic_vector(31 downto 0)
  );
end LoadControl;

architecture LoadControl_ARCH of LoadControl is

  signal nOfBits: natural;

  function loadft(  MUXOutSig:        std_logic_vector(31 downto 0);
                    nOfBits:          natural;
                    signedOrUnsigned: std_logic)
                    return std_logic_vector is
    variable vector:  std_logic_vector(31 downto 0);
  begin

    if (signedOrUnsigned = '0') then -- zx
      vector := (others => '0');
    elsif (signedOrUnsigned = '1') then -- sx
      if (MUXOutSig(nOfBits - 1) = '1') then
        vector := (others => '1');
      elsif (MUXOutSig(nOfBits - 1) = '0') then
        vector := (others => '0');
      end if;
    end if;
    vector(nOfBits - 1 downto 0) := MUXOutSig(nOfBits - 1 downto 0);
    return (vector);

  end function;

begin

  with nBits
    select nOfBits <= 8 when "00",
                      16 when "01",
                      32 when "10",
                      32 when others;

  LoadControl <= loadft(MUXOutSig, nOfBits, signedOrUnsigned);

end LoadControl_ARCH;