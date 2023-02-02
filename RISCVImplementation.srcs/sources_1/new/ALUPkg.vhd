library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package ALUPkg is

  function add_ins( r1: std_logic_vector(31 downto 0);
                    r2: std_logic_vector(31 downto 0))
                    return std_logic_vector;
  
  function sub_ins( r1: std_logic_vector(31 downto 0);
                    r2: std_logic_vector(31 downto 0))
                    return std_logic_vector;
  
  function sll_ins( r1: unsigned(31 downto 0);
                    r2: unsigned(31 downto 0))
                    return unsigned;
                    
  function slt_ins( r1: std_logic_vector(31 downto 0);
                    r2: std_logic_vector(31 downto 0))
                    return std_logic_vector;                  

  function sltu_ins(  r1: unsigned(31 downto 0);
                      r2: unsigned(31 downto 0))
                      return unsigned; 

  function srl_ins( r1: unsigned(31 downto 0);
                    r2: unsigned(31 downto 0))
                    return unsigned;

  function sra_ins( r1: unsigned(31 downto 0);
                    r2: unsigned(31 downto 0))
                    return unsigned;

end package;

package body ALUPkg is

  function add_ins( r1: std_logic_vector(31 downto 0);
                    r2: std_logic_vector(31 downto 0))
                    return std_logic_vector is
    variable temp: std_logic_vector(32 downto 0);
  begin
    temp := ('0' & r1) + ('0' & r2);
    return (temp);
  end function;
  
  function sub_ins( r1: std_logic_vector(31 downto 0);
                    r2: std_logic_vector(31 downto 0))
                    return std_logic_vector is
    variable temp: std_logic_vector(32 downto 0);
  begin
    temp := ('0' & r1) - ('0' & r2);
    return (temp);
  end function;
  
  function sll_ins( r1: unsigned(31 downto 0);
                    r2: unsigned(31 downto 0))
                    return unsigned is
    variable sizeToShift: integer;
    variable temp: unsigned(32 downto 0);
  begin
    sizeToShift := to_integer(r2(4 downto 0));
    temp := '0' & shift_left(unsigned(r1), sizeToShift);
    return (temp);
  end function;
  
  function slt_ins( r1: std_logic_vector(31 downto 0);
                    r2: std_logic_vector(31 downto 0))
                    return std_logic_vector is
  variable temp: std_logic_vector(32 downto 0);
  begin
    if (to_integer(signed(r1)) < to_integer(signed(r2))) then
      temp := (0 => '1', others => '0');
    else
      temp := (others => '0');
    end if;
    return (temp);
  end function;                

  function sltu_ins(  r1: unsigned(31 downto 0);
                      r2: unsigned(31 downto 0))
                      return unsigned is
  variable temp: unsigned(32 downto 0);
  begin
    if (r1 < r2) then
      temp := (0 => '1', others => '0');
    else
      temp := (others => '0');
    end if;
    return (temp);
  end function;

  function srl_ins( r1: unsigned(31 downto 0);
                    r2: unsigned(31 downto 0))
                    return unsigned is
    variable sizeToShift: integer;
    variable temp: unsigned(32 downto 0);
  begin
    sizeToShift := to_integer(r2(4 downto 0));
    temp := '0' & shift_right(unsigned(r1), sizeToShift);
    return (temp);
  end function;
  
  function sra_ins( r1: unsigned(31 downto 0);
                    r2: unsigned(31 downto 0))
                    return unsigned is
    variable sizeToShift: integer;
    variable temp: unsigned(32 downto 0);
  begin
    sizeToShift := to_integer(r2(4 downto 0));
    temp := '0' & shift_right(unsigned(r1), sizeToShift);
    return (temp);
  end function;

end package body;
