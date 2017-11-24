library ieee;
use ieee.std_logic_1164.all;

entity ROM1 is
  port  (address : in std_logic_vector(3 downto 0);
         data : out std_logic_vector(7 downto 0) );
end ROM1;

architecture behavioral of ROM1 is
  type mem is array (0 to 9) of std_logic_vector(7 downto 0);
	
	constant rom_1 : mem := (
	0 => "00000000", --0
	1 => "00000001", --1
	2 => "00000010", --2
	3 => "00000011", --3
	4 => "00000100", --4
	5 => "00000101", --5
	6 => "00000110", --6
	7 => "00000111", --7
	8 => "00001000", --8
	9 => "00001001"  --9
	);
	
begin
   process (address)
   begin
     case address is
       when "0000" => data <= rom_1(0);
       when "0001" => data <= rom_1(1);
       when "0010" => data <= rom_1(2);
       when "0011" => data <= rom_1(3);
       when "0100" => data <= rom_1(4);
       when "0101" => data <= rom_1(5);
       when "0110" => data <= rom_1(6);
       when "0111" => data <= rom_1(7);
       when "1000" => data <= rom_1(8);
       when "1001" => data <= rom_1(9);
       when others => data <= "00000000";
       end case;
  end process;
end architecture behavioral;