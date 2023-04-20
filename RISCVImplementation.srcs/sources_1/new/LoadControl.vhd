--******************************************************************************
--*
--* Name: LoadControl

--* Designer: Alberto Caravantes
--*
--* Component that restricts the size of the input that will be carried to the
--*	output. It is useful for loads which differ by the size (i.e. LB, LH and LW
--*	are 8, 16 and 32 bits respectively).
--*	It also manages if the word will be obtained through sign extension or not.
--*
--*		NBITS			#BITS				|													SIGNEDORUNSIGNED
--*		00				8						|													'0' (zx)	'1' (sx)
--*		01				16					|		MUXOUTSIG[#BITS - 1]	--------	'1'			'0'
--*		10				32					|													all '0'		all '1'	all '0'
--*		others		32					|
--*
--******************************************************************************

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

  function loadft(  MUXOutSig:        std_logic_vector(31 downto 0);
  									br:								std_logic_vector(31 downto 0);
                    nOfBits:          natural;
                    signedOrUnsigned: std_logic;
                    auipc:						std_logic)
                    return std_logic_vector is
    variable vector:  std_logic_vector(31 downto 0);
  begin

		if (auipc = '1') then
			vector := br;
			return (vector);
		end if;
    if (signedOrUnsigned = '0') then -- zx
      vector := (others => '0');
    elsif (signedOrUnsigned = '1') then -- sx
      if (MUXOutSig(31) = '1') then
        vector := (others => '1');
      elsif (MUXOutSig(31) = '0') then
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

  LoadControl <= loadft(MUXOutSig, br, nOfBits, signedOrUnsigned, auipc);

end LoadControl_ARCH;