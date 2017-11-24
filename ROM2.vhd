library ieee;
use ieee.std_logic_1164.all;

entity ROM2 is
  port  (address : in std_logic_vector(3 downto 0);
         data : out std_logic_vector(7 downto 0) );
end ROM2;

architecture beh of ROM2 is
  type mem is array (0 to 9) of std_logic_vector(7 downto 0);
  constant rom_2 : mem := (
	0 => "00001001", -- 9
	1 => "00001000", -- 8
	2 => "00000111", -- 7
	3 => "00000110", -- 6
	4 => "00000101", -- 5
	5 => "00000100", -- 4
	6 => "00000011", -- 3
	7 => "00000010", -- 2
	8 => "00000001", -- 1
	9 => "00000000");-- 0

	
begin
   process (address)
   begin
     case address is
       when "0000" => data <= rom_2(0);
       when "0001" => data <= rom_2(1);
       when "0010" => data <= rom_2(2);
       when "0011" => data <= rom_2(3);
       when "0100" => data <= rom_2(4);
       when "0101" => data <= rom_2(5);
       when "0110" => data <= rom_2(6);
       when "0111" => data <= rom_2(7);
       when "1000" => data <= rom_2(8);
       when "1001" => data <= rom_2(9);
       when others => data <= "00000000";
       end case;
  end process;
end architecture beh;