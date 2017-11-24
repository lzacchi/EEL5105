library ieee;
use ieee.std_logic_1164.all;

entity ROM3 is
  port  (address : in std_logic_vector(3 downto 0);
         data : out std_logic_vector(7 downto 0) );
end ROM3;

architecture bhv of ROM3 is
  type mem is array (0 to 9) of std_logic_vector(7 downto 0);
  constant rom_3 : mem := (
	0 => "00000000", -- 0
	1 => "00000010", -- 2
	2 => "00000100", -- 4
	3 => "00000110", -- 6
	4 => "00001000", -- 8
	5 => "00001010", -- A
	6 => "00001100", -- C
	7 => "00001110", -- E
	8 => "00010000", -- 10
	9 => "00010010");-- 12

	
begin
   process (address)
   begin
     case address is
       when "0000" => data <= rom_3(0);
       when "0001" => data <= rom_3(1);
       when "0010" => data <= rom_3(2);
       when "0011" => data <= rom_3(3);
       when "0100" => data <= rom_3(4);
       when "0101" => data <= rom_3(5);
       when "0110" => data <= rom_3(6);
       when "0111" => data <= rom_3(7);
       when "1000" => data <= rom_3(8);
       when "1001" => data <= rom_3(9);
       when others => data <= "00000000";
       end case;
  end process;
end architecture bhv;