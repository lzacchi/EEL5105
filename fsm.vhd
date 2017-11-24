library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- CONTROL BLOCK -----------------------------------------------
entity fsm is
	port(clock 	  : in std_logic;
		  playing  : in std_logic;  -- control input from datapath
		  KEY		  : in std_logic_vector(3 downto 0);
		  
		  setup_in : out std_logic;
		  play_in  : out std_logic;
		  reset	  : out std_logic;
		  display5 : out std_logic_vector(6 downto 0));
end fsm;


architecture bhv of fsm is
	signal button	: std_logic_vector(3 downto 0);  --reset
	signal setupS	: std_logic; 
	signal playS 	: std_logic;
	signal resetS	: std_logic;
	
	type STATES is (Init, Setup, Game, Result);
	signal NextS, Current : STATES;
	
	--Component buttonsync:
	component ButtonSync is 
		port(KEY0, KEY1, KEY2, KEY3, CLK: in std_logic;
			  BTN0, BTN1, BTN2, BTN3: out std_logic);
	end component;

begin
	-- RESET --
	process (clock, button(0), Current)
	begin
		if (button(0) = '0') then
			Current <= Init;
			resetS <= '1';
		elsif (rising_edge(clock)) then
			Current <= NextS;
			resetS <= '0';
		end if;
	end process;
	
	process (Current, button(1), playing)
	begin
		case Current is
			when Init =>	
				setupS <= '0';
				playS	 <= '0';
							
				if (button(1) = '0') then
					NextS <= Setup;
				else
					NextS <= Init;
				end if;
			
			when Setup =>
				setupS <= '1';
				playS  <= '0';
							 
				if (button(1) = '0') then
					nextS <= Game;
					playS <= '1';
				else
					nextS <= Setup;
				end if;
				
			when Game =>
				setupS <= '0';
				playS  <= '1';
				
				if (playing = '1') then
					nextS <= Game;
				else
					nextS <= Result;
				end if;
				
			when Result =>
				setupS <= '0';
				playS  <= '0';
				
				if (button(1) = '0') then
					nextS <= Init;
				else
					nextS <= Result;
				end if;
			
		end case;
	end process;
	
	-- ButtonSync port map -- 
	
	BTNSNC : ButtonSync port map(KEY(0), KEY(1), KEY(2), KEY(3),
										  clock, button(0), button(1), button(2), button(3));
	
	-- Connecting -- 
	setup_in	<= setupS;
	play_in	<= playS;
	reset <= resetS;
	
	-- Displaying L --
	
	display5 <= "1000111" when playS = '1' or setupS = '1' else "0000000";
	
end bhv;