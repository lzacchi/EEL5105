library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;		-- a + b;
use IEEE.std_logic_unsigned.all; -- a > b;

entity datapath is
	port(switches : in std_logic_vector(9 downto 0);
		  clock	  : in std_logic; 
		  reset	  : in std_logic;
		  setup	  : in std_logic; --Sinal que vem do block de controle, indica se o estado é SETUP
		  play 	  : in std_logic; --Sinal que vem do block de controle, indica se o estado é GAME
		  
		  led 	  : out std_logic_vector(9 downto 0);
		  display0 : out std_logic_vector(6 downto 0);
		  display1 : out std_logic_vector(6 downto 0);
		  display2 : out std_logic_vector(6 downto 0);
		  display3 : out std_logic_vector(6 downto 0);
		  display4 : out std_logic_vector(6 downto 0);
		  playing  : out std_logic); --Saida informa ao bloco de controle se o jogo está em andamento
end datapath;

architecture archdata of datapath is
	-- SIGNALS ---------------------------------------
	signal g_clock		 		: std_logic; --Frequencia do clock selecionado para o jogo
	signal show_result 		: std_logic; --Sinal que determina se o estado deve ser Result
	signal reset_clock 		: std_logic; --Sinal que reseta o Clock
	signal score		 		: std_logic_vector(3 downto 0); --Pontuação
	signal hex_score			: std_logic_vector(7 downto 0); --Pontuação em Hexadecimal
	signal score_multiplier : integer range 0 to 3; --Fator de multiplicação da pontuação
	signal game_lvl	 		: std_logic_vector(1 downto 0); --Nivel do jogo
	signal playing_s	 		: std_logic; --Sinal que determina se o jogo está em andamento
	signal led_s				: std_logic_vector(9 downto 0); --Sinal para mostrar a pontuação nos  leds

	
	signal number				: std_logic_vector(7 downto 0); --Sinal que determina o número da ROM a ser carregado
	
	-- DISPLAY SIGNALS ------------------------------------
	--## Sinais para multiplexar o Display 7seg##
	signal disp0_mux			: std_logic_vector(3 downto 0);
	signal disp1_mux			: std_logic_vector(3 downto 0);
	signal disp2_mux			: std_logic_vector(3 downto 0);
	signal disp3_mux			: std_logic_vector(3 downto 0);
	--#####################################################
	
	--## Sinais do display--
	signal disp0 				: std_logic_vector(6 downto 0);
	signal disp1 				: std_logic_vector(6 downto 0);
	signal disp2 				: std_logic_vector(6 downto 0);
	signal disp3 				: std_logic_vector(6 downto 0);
	--#####################################################
	
	-- ROM SIGNALS ----------------------------------------
	signal rom_sel		 		: std_logic_vector(1 downto 0); --Sinal que seleciona ROM
	signal g_rom				: std_logic_vector(3 downto 0); --Sinal que representa a rom selecionada para o jogo
	signal rom0_o				: std_logic_vector(7 downto 0); --Sinal que representa a ROM0
	signal rom1_o				: std_logic_vector(7 downto 0); --Sinal que representa a ROM1
	signal rom2_o				: std_logic_vector(7 downto 0); --Sinal que representa a ROM2
	signal rom3_o				: std_logic_vector(7 downto 0); --Sinal que representa a ROM3
	
	-- COMPONENTS -------------------------------------
	component ROM0 is
		port(address : in std_logic_vector(3 downto 0);
			  data	 : out std_logic_vector(7 downto 0));
	end component;
	
	component ROM1 is
	port(address : in std_logic_vector(3 downto 0);
		  data	 : out std_logic_vector(7 downto 0));
	end component;

	component ROM2 is
		port(address : in std_logic_vector(3 downto 0);
			  data	 : out std_logic_vector(7 downto 0));
	end component;
	
	component ROM3 is
		port(address : in std_logic_vector(3 downto 0);
			  data	 : out std_logic_vector(7 downto 0));
	end component;
	
	--DECLARANDO CLOCKLEVEL--
	component clocklevel is
		port(selector : in std_logic_vector(1 downto 0);
			  clk_in   : in std_logic;
			  reset	  : in std_logic;
			  clk_out  : out std_logic);
	end component;
	
	--DECLARANDO DECODIFICADOR--
	component decod7seg is
		port(A: in std_logic_vector(3 downto 0);
			  F: out std_logic_vector(6 downto 0));
	end component;
	
begin
	process(play, setup, switches, g_clock, reset)
	begin
		if(reset  = '1') then --quando reset e pressionado
			playing_s 		<= '0'; --Jogo recebe zero (encerra)
			led_s 			<= "0000000000";
			show_result <= '0'; --nao deve mostrar o resultado
			reset_clock <= '1'; --reseta o clock do jogo
			score 		<= "0000";--reseta a pontuacao
		
		-- ESTADO SETUP ---------------------------------------
		elsif(setup = '1') then --se o estado for SETUP
			game_lvl 	<= switches(9 downto 8); --entradas para selecionar o nivel de jogo
			rom_sel  	<= switches(1 downto 0); --entradas para selecionar a rom
			led_s			<= "0000000000"; --leds apagados
			show_result <= '0'; --sinal de RESULT em zero
			score 		<= "0000";--Pontuacao em zero
			reset_clock <= '1'; --clock do jogo zerado
		
		-- ESTADO GAME ----------------------------------------
		elsif (play = '1' and playing_s = '0' and show_result = '0') then --Se o estado for GAME e o jogo nao estiver em andamento
			playing_s 	<= '1'; --Poe o jogo em andamento
			reset_clock <= '0'; --Nao zera a contagem do clock
			g_rom		<= "0000";
			led_s			<= "0000000000";--leds apagados
		
		elsif (rising_edge(g_clock)) then --em toda borda de subida do clock do jogo
			if ((number(7 downto 4) = switches(7 downto 4)) and --se a entrada bater com o segundo digito hexa
				 (number(3 downto 0) = switches(3 downto 0))) then --e se a entrada bater com o primeiro digito
				  
				  led_s   <= led_s(8 downto 0) & '1'; --acende um led (e o seguinte, e o seguinte...)
				  score <= score + 1; --Incrementa a pontuacao
			end if;
			
			g_rom <= g_rom + "0001"; --Le a proxima linha da ROM
			if (g_rom = "1001") then   --Verifica se eh a ultima linha
				playing_s 	<= '0'; --Encerra o jogo
				show_result <= '1'; --Indica que o prox estado e RESULT
				reset_clock <= '1'; --Reseta o clock do jogo
			end if;
		end if;
	end process;
	led <= led_s; --Conectando o sinal dos leds a saida de led
	playing <= playing_s; --conectando 
	
	-- MULTIPLYING SCORE ---------------------------------------------------------------
	score_multiplier <= 0 when game_lvl = "00" else
							  1 when game_lvl = "01" else
							  2 when game_lvl = "10" else
							  3 when game_lvl = "11";
	-- DISPLAYING GAME LEVEL -----------------------------------------------------------
	display4 <= "1000000" when game_lvl = "00" and (setup = '1' or playing_s = '1') else
					"1111001" when game_lvl = "01" and (setup = '1' or playing_s = '1') else
					"0100100" when game_lvl = "10" and (setup = '1' or playing_s = '1') else
					"0110000" when game_lvl = "11" and (setup = '1' or playing_s = '1') else
					"1111111";
					
	-- ASSIGNING DISPLAYS ---------------------------------------------------------------
	disp0_mux <= number(3 downto 0);
	disp1_mux <= number(7 downto 4);
	
	disp2_mux <= hex_score(3 downto 0);
	disp3_mux <= hex_score(7 downto 4);
	
	display0 <= "1111111" when playing_s 	= '0' else disp0;
	display1 <= "1111111" when playing_s 	= '0' else disp1;
	display2 <= "1111111" when show_result = '0' else disp2;
	display3 <= "1111111" when show_result = '0' else disp3;
	
	
	-- DISPLAYS PORT MAP ---------------------------------------------------------------
	
	HEX_DISP0 : decod7seg port map(disp0_mux, disp0);
	HEX_DISP1 : decod7seg port map(disp1_mux, disp1);
	HEX_DISP2 : decod7seg port map(disp2_mux, disp2);
	HEX_DISP3 : decod7seg port map(disp3_mux, disp3);
	
	
	-- DISPLAYING VALUES --------------------------------------------------------------
	number 	 <= rom0_o when rom_sel = "00" else
					 rom1_o when rom_sel = "01" else
					 rom2_o when rom_sel = "10" else
					 rom3_o when rom_sel = "11";
	
	--MULTIPLICANDO -- FAZENDO BITSHIFT HARDCODED
	hex_score <= "0000" & score when score_multiplier = 0 else
					 "000" & score & "0" when score_multiplier = 1 else
					 "00" & score & "00" when score_multiplier = 2 else
					 "0" & score & "000" when score_multiplier = 3;
					 
	-- CLOCK LEVEL --------------------------------------------------------------------
	clock_sel : clocklevel port map(game_lvl, clock, reset_clock, g_clock);
		
	-- ROM INSTANCES ------------------------------------------------------------------
	rom_in0 : ROM0 port map(g_rom, rom0_o);
	rom_in1 : ROM1 port map(g_rom, rom1_o);
	rom_in2 : ROM2 port map(g_rom, rom2_o);
	rom_in3 : ROM3 port map(g_rom, rom3_o);

end archdata;
	
	
	
