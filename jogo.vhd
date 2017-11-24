library ieee;
use ieee.std_logic_1164.all;

entity jogo is 
	port (KEY		: in std_logic_vector(3 downto 0);
			CLOCK_50 : in std_logic;
			SW: in std_logic_vector(9 downto 0);
			
			LEDR		: out std_logic_vector(9 downto 0);
			HEX0		: out std_logic_vector(6 downto 0);
			HEX1		: out std_logic_vector(6 downto 0);
			HEX2		: out std_logic_vector(6 downto 0);
			HEX3		: out std_logic_vector(6 downto 0);
			HEX4		: out std_logic_vector(6 downto 0);
			HEX5		: out std_logic_vector(6 downto 0)
	);
end jogo;

architecture jogo_top of jogo is
	signal playingS : std_logic;
	signal playS 	 : std_logic;
	signal setupS	 : std_logic;
	signal resetS	 : std_logic;
	
	
	-- COMPONENTS -------------------------------------------------	
	component datapath is
		port(switches : in std_logic_vector(9 downto 0);
			  clock	  : in std_logic;
			  reset	  : in std_logic;
			  setup	  : in std_logic;
			  play 	  : in std_logic;
		  
			  led 	  : out std_logic_vector(9 downto 0);
			  display0 : out std_logic_vector(6 downto 0);
			  display1 : out std_logic_vector(6 downto 0);
			  display2 : out std_logic_vector(6 downto 0);
			  display3 : out std_logic_vector(6 downto 0);
			  display4 : out std_logic_vector(6 downto 0);
			  paying	  : out std_logic);
	end component;
	
	component fsm is
		port(clock 	  : in std_logic;
			  playing  : in std_logic;  -- control input from datapath
			  KEY		  : in std_logic_vector(3 downto 0);
		  
			  setup_in : out std_logic;
			  play_in  : out std_logic;
			  reset	  : out std_logic;
			  display5 : out std_logic_vector(6 downto 0));
	end component;

begin
	CONTROL_BLOCK : fsm port map(CLOCK_50, playingS, KEY, setupS, playS, resetS, HEX5); 
	DATA_BLOCK: datapath port map(SW, CLOCK_50, resetS, setupS, playS, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, playingS);
end jogo_top;
