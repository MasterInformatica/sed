library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.numeric_std.all;


entity principal is
	port (
		reset_n: in std_logic;	                 -- reset
		ClkIN: in std_logic;
		
		hsyncb: inout std_logic;	           -- horizontal (line) sync
		vsyncb: out std_logic;	              -- vertical (frame) sync
		rgb: out std_logic_vector(8 downto 0); -- B G R colors
		
		Rx: in std_logic;
		Tx: out std_logic;
		
		leds: out std_logic_vector(7 downto 0)
		
	);
end principal;

architecture Behavioral of principal is
		component vgacore is
			port (
				reset: in std_logic;	                 -- reset
				clock: in std_logic;
				hsyncb: inout std_logic;	           -- horizontal (line) sync
				vsyncb: out std_logic;	              -- vertical (frame) sync
				rgb: out std_logic_vector(8 downto 0) -- B G R colors
			);
		end component;


	  component RS232 is
	  generic
	  (
			F 			: natural := 100000;
			min_baud	: natural := 115200;
			NDBits 	: natural := 8
	  );
	  port
	  (
			clk	: in  STD_LOGIC;
			reset	: in  STD_LOGIC;
			Rx		: in  STD_LOGIC;
			Tx		: out STD_LOGIC;

			datoAEnviar	: in std_logic_vector(NDBits-1 downto 0);
			enviarDato	: in std_logic;
			TxBusy		: out std_logic;

			datoRecibido	: out std_logic_vector(NDBits-1 downto 0);
			RxErr				: out std_logic;		
			RxRdy				: out std_logic
	  );
	end component RS232;
	
	
	
--	signal Reset_n: std_logic;
	signal clko : std_logic;
	signal leer: std_logic_vector(7 downto 0);
	signal empieza: std_logic;
	
	signal datos: std_logic_vector(7 downto 0);
	signal Clk: std_logic;
begin

Clk <= ClkIN;

clko <= ClkIN;

UART: RS232
  GENERIC MAP( F => 100000,
               min_baud => 19200,
					NDBits => 8
              )
  PORT MAP
  (
		clk   => clko,
		reset	=> Reset_n,
		Rx		=> Rx,
		Tx		=> Tx,

		datoAEnviar	=> "11111111",
		enviarDato	=> '0',
		TxBusy		=> open,

		datoRecibido	=> leer,
		RxErr				=> open,
		RxRdy				=> empieza
  );


	
	pantalla: vgacore port map(
		reset => Reset_n,	                 -- reset
		clock => ClkIN,
		hsyncb => hsyncb,
		vsyncb => vsyncb,
		rgb => rgb
	);
		
		
	leds <= datos;
	
process(empieza, clko, Reset_n, datos)
begin
	if (Reset_n = '1') then
		datos<=(others => '0');
		
	elsif (clko'event and clko='1' and empieza='1') then
		datos <= leer;
	else
		datos <= datos;
	end if;
end process;


end Behavioral;

