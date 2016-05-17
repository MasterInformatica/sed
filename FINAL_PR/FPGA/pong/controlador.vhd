----------------------------------------------------------------------------------
-- Company: JJDA
-- Engineer: Jesús Javier Doménech Arellano - 47470902Y
-- 
-- Create Date:    16:14:17 12/04/2012 
-- Design Name: 
-- Module Name:    controlador - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tiposyconstantes.all;

entity main is
	port (
		reset:in std_logic;--reset general
		clock:in std_logic;--reloj original
--		clk_teclado : in std_logic;--reloj PS2
--    bit_teclado : in std_logic;--Entrada teclado
		rx : in std_logic;
		tx : out std_logic;
		hsyncb: inout std_logic;	-- horizontal (line) sync
		vsyncb: out std_logic;	-- vertical (frame) sync
		rgb: out std_logic_vector(8 downto 0); -- SALIDA a la pantalla
		LEDS: out std_logic_vector(20 downto 0);
		
		RxErr : OUT STD_LOGIC
	);
end main;

architecture Behavioral of main is

--=============================COMPONENTES=================================================
-- Controlador del teclado
component Keyboard is
	port (
		clk_teclado : in std_logic;
		bit_teclado : in std_logic;
		teclaLeida  : in std_logic;
		tecla       : out std_logic_vector(5 downto 0)
	);
end component;


component keyboardUART is
	  PORT (
		 clko     : IN STD_LOGIC;
		 Reset_n   : IN STD_LOGIC;
		 teclaLeida: in std_logic;
       tecla : out std_logic_vector(5 downto 0);
		 leer : in std_logic_vector(7 downto 0);
		 empieza : in std_logic
	  );
end component;

  
COMPONENT RS232 IS
  GENERIC (
		F 			: natural := 100000;
		min_baud	: natural := 115200;
		NDBits 	: natural := 8
  );
  PORT
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
END COMPONENT RS232;
  



 
component paddle is
    Port ( clk : in  STD_LOGIC;
           Reset_n : in  STD_LOGIC;
           baja : in  STD_LOGIC;
           sube : in  STD_LOGIC;
           posicion_arr : out integer;
			  posicion_abj : out integer
			  );
end component;

component bola is
		Port ( reset    : in    std_logic;
			 clock    	 : in    std_logic; 
		  	 paddle_left_up   : in   integer;
			 paddle_left_bt   : in   integer;
			 paddle_right_up  : in   integer;
			 paddle_right_bt  : in   integer;
			 ball_h_pos       : out   integer;
			 ball_v_pos       : out   integer;
			 gol_left 		   : out std_logic;
			 gol_right			: out std_logic
	);
end component;
 
 
-- DIVISOR que regula los relojes
component divisor2 is
	port(
		carga: in std_logic_vector(24 downto 0);--typa=1 => reloj pantalla; typa=0 =>reloj movimiento
		reset,clk: in std_logic;
		reloj: out std_logic
	);
end component;


--VGA

component vgacore is
	port (
		-- Generales del comopnente
		reset    : in    std_logic;	          -- reset
		clock    : in    std_logic;             -- clock
		
		-- Propios del modulo de pong
		paddle_left_up   : in   integer;-- range vga_vpx_min  to vga_vpx_max;   
	   paddle_left_bt  : in   integer;-- range vga_vpx_min  to vga_vpx_max;
		
		paddle_right_up   : in   integer;-- range vga_vpx_min  to vga_vpx_max;   
	   paddle_right_bt  : in   integer;-- range vga_vpx_min  to vga_vpx_max;
		
		ball_h_pos        : in   integer ;--range vga_hpx_min  to vga_hpx_max;
		ball_v_pos        : in   integer ;--range vga_vpx_min  to vga_vpx_max;
		
		-- Propios el vga
		hsyncb   : inout std_logic;	                     -- horizontal (line) sync
		vsyncb   : out   std_logic;	                     -- vertical (frame) sync
		rgb      : out   std_logic_vector(8 downto 0)      -- B G R colors
	);
end component;

--============================END COMPONENTES========================================

--===========================SIGNALS===============================================
--- UART
SIGNAL UART_din   : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL UART_wr_en : STD_LOGIC;
SIGNAL TxBusy     : STD_LOGIC;
SIGNAL UART_dout  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL RxRdy      : STD_LOGIC;
--SIGNAL RxErr      : STD_LOGIC;

--relojes
signal reloj_mov: std_logic;--reloj_game?
signal reloj_vga: std_logic;--reloj de pantalla
--teclado
signal ktecla : std_logic_vector(5 downto 0);
signal teclaLeida : std_logic :='1';
-- pala 1
signal baja_1     : std_logic;
signal sube_1     : std_logic;
-- pala 2
signal baja_2     : std_logic;
signal sube_2     : std_logic;

-- VGA 

signal pala_1_vpos_arr : integer ;
signal pala_2_vpos_arr : integer ;
signal pala_1_vpos_abj : integer ;
signal pala_2_vpos_abj : integer ;

signal bola_h : integer;
signal bola_v : integer;


---------------------------- OLD -------------------------------------------------
--juego


signal pause: std_logic :='1';
signal rstart,start: std_logic :='0';
signal velocidad: std_logic_vector(24 downto 0):= "0001111111111111111111110";
signal kvelocidad: std_logic_vector(24 downto 0):= "0001111111111111111111110";
--pantalla

signal LEDS2 :   STD_LOGIC_VECTOR(20 downto 0);


SIGNAL Reset_n : STD_LOGIC;
SIGNAL clko    : STD_LOGIC;
signal clock2 : std_logic;

--=========================END SIGNALS=================================================

begin
clock2 <= clock;
Reset_n <= Reset;
--==========================PORT MAP====================================================
--Control_Teclado: keyboard port map(clk_teclado,bit_teclado,teclaLeida,Ktecla);
Nreloj_mov: divisor2 port map( velocidad,reset,clock,reloj_mov);
Pala_1: paddle port map(clock,Reset_n,baja_1,sube_1,pala_1_vpos_arr,pala_1_vpos_abj);
Pala_2: paddle port map(clock,Reset_n,baja_2,sube_2,pala_2_vpos_arr,pala_2_vpos_abj);
UART_Teclado: keyboardUART port map(clock,Reset_n,teclaLeida,Ktecla,UART_dout,RxRdy);
Bola_inst: bola port map( Reset_n, reloj_mov, pala_1_vpos_arr,  pala_1_vpos_abj,
												     pala_2_vpos_arr,  pala_2_vpos_abj, bola_h, bola_v, open, open);

Control_VGA: vgacore port map(reset,clock,pala_1_vpos_arr,pala_1_vpos_abj,pala_2_vpos_arr,pala_2_vpos_abj,bola_h,bola_v,hsyncb,vsyncb,rgb);
--MyScore: score port map(reloj_mov,rstart,,LEDS2);
UART: RS232
  GENERIC MAP( F => 100000,
               min_baud => 115200,
					NDBits => 8
              )
  PORT MAP
  (
		clk   => clock,
		reset	=> Reset_n,
		Rx		=> rx,
		Tx		=> tx,

		datoAEnviar	=> UART_din,
		enviarDato	=> UART_wr_en,
		TxBusy		=> TxBusy,

		datoRecibido	=> UART_dout,
		RxErr				=> RxErr,
		RxRdy				=> RxRdy
  );
--========================END PORT MAP===============================================

--========================Procesar Tecla Leida============================================ 

 velocidad<=kvelocidad;
 LEDS<=LEDS2;
 cKey: process(reset,Ktecla, clock)--mueve la cabeza de la serpiente
 begin
	if reset='1' OR Ktecla(5) = '1' then--reset total
		pause<='1';
		teclaLeida<='1';
		start<='1';
		rstart<='1';
		kvelocidad<="0001111111111111111111110";
	elsif (clock'event and clock='1') then
			start<='0';
			rstart<='0';
			kvelocidad<=velocidad;
			teclaLeida<='1';
			if Ktecla(1) = '1' then --arr
				sube_1 <= '1';
				baja_1 <= '0';
				sube_2 <= '0';
				baja_2 <= '0';
				pause<='0';
			elsif Ktecla(2) = '1' then --der
				sube_1 <= '0';
				baja_1 <= '0';
				sube_2 <= '1';
				baja_2 <= '0';
				pause<='0';
			elsif Ktecla(3) = '1' then --abj
				sube_1 <= '0';
				baja_1 <= '1';
				sube_2 <= '0';
				baja_2 <= '0';
				pause<='0';
			elsif Ktecla(4) = '1' then --izq
			   sube_1 <= '0';
				baja_1 <= '0';
				sube_2 <= '0';
				baja_2 <= '1';
				pause<='0';
			elsif Ktecla(0) = '1' then --pause
				sube_1 <= '0';
				baja_1 <= '0';
				sube_2 <= '0';
				baja_2 <= '0';
				pause<='1';
			else
				sube_1 <= '0';
				baja_1 <= '0';
				sube_2 <= '0';
				baja_2 <= '0';
				pause<=pause;
				teclaLeida<='0';
			end if;
		end if;
end process cKey;
--========================FIn procesar tecla=================================================





end Behavioral;

