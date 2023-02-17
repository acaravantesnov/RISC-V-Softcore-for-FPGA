--******************************************************************************
--*
--* Name: ALU
--* Designer: Alberto Caravantes
--*
--* 
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BasicPkg.all;
use work.ALUPkg.all;

entity ALU is
  port (
    r1:           in std_logic_vector(31 downto 0);
    r2:           in std_logic_vector(31 downto 0);
    control:      in std_logic_vector(3 downto 0);
    zero:         out std_logic;
    cOut:         out std_logic;
    overflow:     out std_logic;
    resultValue:  out std_logic_vector(31 downto 0)
  );
end ALU;

architecture ALU_ARCH of ALU is
  
  signal result: std_logic_vector(32 downto 0);                    

begin

  with control
    select result <=  std_logic_vector(add_ins(signed(r1), signed(r2)))       when "0000", -- add
                      std_logic_vector(sub_ins(signed(r1), signed(r2)))       when "1000", -- sub
                      std_logic_vector(sll_ins(unsigned(r1), unsigned(r2)))   when "0001", -- sll
                      std_logic_vector(slt_ins(signed(r1), signed(r2)))       when "0010", -- slt
                      std_logic_vector(sltu_ins(unsigned(r1), unsigned(r2)))  when "0011", -- sltu
                      ('0' & (r1 xor r2))                                     when "0100", -- xor
                      std_logic_vector(srl_ins(unsigned(r1), unsigned(r2)))   when "0101", -- srl
                      std_logic_vector(sra_ins(unsigned(r1), unsigned(r2)))   when "1101", -- sra
                      ('0' & (r1 or r2))                                      when "0110", -- or
                      ('0' & (r1 and r2))                                     when "0111", -- and
                      (others => '1')                                         when others;
  resultValue <= result(31 downto 0);
  cOut <= result(32);

end ALU_ARCH;
