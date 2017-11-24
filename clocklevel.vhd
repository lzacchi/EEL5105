library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clocklevel is 
	port(selector : in std_logic_vector(1 downto 0);
		  clk_in   : in std_logic;
		  reset	  : in std_logic;
		  clk_out  : out std_logic);
end clocklevel;

architecture bhv of clocklevel is
	signal count1, count2, count3, count4 : integer range 0 to 499999999 := 0;
	signal clockout: std_logic;
	signal clock1, clock2, clock3, clock4: std_logic;
begin

	clocklevel: process(reset, clk_in)
	begin
		if (reset = '1') then
			count1 <= 0;
			count2 <= 0;
			count3 <= 0;
			count4 <= 0;
		elsif rising_edge(clk_in) then
			if (count1 = 4999999) then
				count1 <=   0;
				clock1 <= '1';
			else
				clock1 <= '0';
				count1 <= count1 + 1;
			end if;
			
			if (count2 = 199999999) then
				count2 <=   0;
				clock2 <= '1';
			else
				clock2 <= '0';
				count2 <= count2 + 1;
			end if;
			
			if (count3 = 149999999) then
				count3 <=   0;
				clock3 <= '1';
			else
				clock3 <= '0';
				count3 <= count3 + 1;
			end if;
			
			if (count4 <= 99999999) then
				count4 <=   0;
				clock4 <= '1';
			else
				clock4 <= '0';
				count4 <= count4 + 1;
			end if;
			
			-- SELECTOR --
			if (selector = "00") then
				clockout <= clock1;
			elsif (selector = "01") then
				clockout <= clock2;
			elsif (selector = "10") then
				clockout <= clock3;
			elsif (selector = "11") then
				clockout <= clock4;
			end if;
		end if;
	end process;
	
	clk_out <= clockout;
end bhv;