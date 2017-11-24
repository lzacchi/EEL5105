library ieee;
use ieee.std_logic_1164.all;

entity ROM0 is
  port  (address : in std_logic_vector(3 downto 0);
         data : out std_logic_vector(7 downto 0) );
end ROM0;

architecture bhvr of ROM0 is
  type mem is array (0 to 9) of std_logic_vector(7 downto 0);
  constant rom_0 : mem := (
	0 => "00011000", -- 18
	1 => "11000001", -- C1
	2 => "01000000", -- 40
	3 => "11111110", -- FE
	4 => "10100101", -- A5
	5 => "00000111", -- 07
	6 => "01101100", -- 6C
	7 => "11010101", -- d5
	8 => "10111110", -- bE
	9 => "00110011"); --33
	
begin
   process (address)
   begin
     case address is
       when "0000" => data <= rom_0(0);
       when "0001" => data <= rom_0(1);
       when "0010" => data <= rom_0(2);
       when "0011" => data <= rom_0(3);
       when "0100" => data <= rom_0(4);
       when "0101" => data <= rom_0(5);
       when "0110" => data <= rom_0(6);
       when "0111" => data <= rom_0(7);
       when "1000" => data <= rom_0(8);
       when "1001" => data <= rom_0(9);
       when others => data <= "00000000";
       end case;
  end process;
end architecture bhvr;