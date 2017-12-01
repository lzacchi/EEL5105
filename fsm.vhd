library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- CONTROL BLOCK -----------------------------------------------
entity fsm is
	port(clock 	  : in std_logic;
		  playing  : in std_logic;  --entrada que informa se o jogo está em andamento
		  KEY		  : in std_logic_vector(3 downto 0);
		  
		  setup_in : out std_logic; --entrada que informa se o estado atual é 'setup'
		  play_in  : out std_logic;
		  reset	  : out std_logic;
		  display5 : out std_logic_vector(6 downto 0));
end fsm;


architecture bhv of fsm is
	signal button	: std_logic_vector(3 downto 0);
	signal setupS	: std_logic; --Sinal que representa o estado Setup
	signal playS 	: std_logic; --Sinal que representa o estado Play;
	signal resetS	: std_logic;
	
	type STATES is (Init, Setup, Game, Result);
	signal NextS, Current : STATES;
	
	--Component buttonsync:
	component ButtonSync is --Declarando ButtonSync
		port(KEY0, KEY1, KEY2, KEY3, CLK: in std_logic;
			  BTN0, BTN1, BTN2, BTN3: out std_logic);
	end component;

begin
	-- RESET --
	process (clock, button(0), Current)
	begin
		if (button(0) = '0') then --Quando 'reset', retorna para o estado Init
			Current <= Init;
			resetS <= '1'; --Sinal de reset recebe 1
		elsif (rising_edge(clock)) then
			Current <= NextS;
			resetS <= '0';
		end if;
	end process;
	
	process (Current, button(1), playing)  --Processo depende da entrada 'playing'
	begin
		case Current is
			--ESTADO INIT--
			when Init =>
				setupS <= '0'; --sinal de setup em 0 significa que não está no setup
				playS	 <= '0'; --idem para o sinal de play
							
				if (button(1) = '0') then --quando Enter é pressionado:
					NextS <= Setup; --Proximo estado é Setup
				else
					NextS <= Init;
				end if;
			
			--ESTADO SETUP--
			when Setup =>
				setupS <= '1'; --sinal que indica que o estado atual é Setup
				playS  <= '0'; --sinal indica que não é o estado Game
							 
				if (button(1) = '0') then --Quando enter é pressionado, o prox. estado é GAME
					nextS <= Game;
					playS <= '1';  --então o sinal play recebe 1
				else
					nextS <= Setup; --senão, continua no estado setup
				end if;
			
			--ESTADO GAME--
			when Game =>
				setupS <= '0'; --sinal de setup em zero
				playS  <= '1'; --sinal de GAME em 1
				
				if (playing = '1') then --enquanto a entrada playing for um, significa que o jogo está rodando
					nextS <= Game; --então continuamos no estado GAME
				else
					nextS <= Result; --quando a entrada playing for zero, significa que o jogo acabou
				end if;
				
			--ESTADO RESULT--
			when Result =>
				setupS <= '0'; --sinal de setup em zero
				playS  <= '0'; --sinal de game em zero
				
				if (button(1) = '0') then --quando o botão enter é pressionado
					nextS <= Init; --voltamos para o estado inicial
				else
					nextS <= Result;
				end if;
			
		end case;
	end process;
	
	-- ButtonSync port map -- 
	
	BTNSNC : ButtonSync port map(KEY(0), KEY(1), KEY(2), KEY(3),
										  clock, button(0), button(1), button(2), button(3));
	
	-- Conectando os sinais às devidas saídas -- 
	setup_in	<= setupS;
	play_in	<= playS;
	reset <= resetS;
	
	-- ##Displaying L## --
	--Quando estiver no estado Play(sinal play = 1) ou Setup(sinal setup =1),
	--O Display Hexadecimal 5 mostrará a letra L
	display5 <= "1000111" when playS = '1' or setupS = '1' else "1111111";
	
end bhv;