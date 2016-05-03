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
		--tecla: out std_logic_vector(5 downto 0);--Tecla pulsada
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
		 clko      : IN STD_LOGIC;
		 Reset_n   : IN STD_LOGIC;
       UART_Rx   : IN STD_LOGIC;
		 teclaLeida: in std_logic;
       tecla     : out std_logic_vector(5 downto 0);
		 UART_Tx   : OUT STD_LOGIC;
		 RxErr     : OUT STD_LOGIC
	  );
end component;
 
component paddle is
    Port ( clk : in  STD_LOGIC;
           Reset_n : in  STD_LOGIC;
           baja : in  STD_LOGIC;
           sube : in  STD_LOGIC;
           posicion : out integer range vga_vpx_min to vga_hpx_max
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
		paddle_left_pos   : in   integer range vga_vpx_min  to vga_vpx_max;   
	   paddle_right_pos  : in   integer range vga_vpx_min  to vga_vpx_max;
		ball_h_pos        : in   integer range vga_hpx_min  to vga_hpx_max;
		ball_v_pos        : in   integer range vga_vpx_min  to vga_vpx_max;
		
		-- Propios el vga
		hsyncb   : inout std_logic;	                     -- horizontal (line) sync
		vsyncb   : out   std_logic;	                     -- vertical (frame) sync
		rgb      : out   std_logic_vector(8 downto 0)      -- B G R colors
	);
end component;

-- SCORE
component score is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
--           size : in  STD_LOGIC_VECTOR(18 downto 0);
           comido : in  STD_LOGIC;
--           pausa : in  STD_LOGIC;
           LED : out  STD_LOGIC_VECTOR(20 downto 0)
			 );
end component;

component divisor is
   port ( CLKIN_IN        : in    std_logic; 
          RST_IN          : in    std_logic; 
          CLKDV_OUT       : out   std_logic; 
          CLKIN_IBUFG_OUT : out   std_logic; 
          CLK0_OUT        : out   std_logic
          );
end component;
--============================END COMPONENTES========================================

--===========================SIGNALS===============================================
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

signal pala_1_vpos : integer range vga_vpx_min to vga_vpx_max;
signal pala_2_vpos : integer range vga_vpx_min to vga_vpx_max;

---------------------------- OLD -------------------------------------------------
--juego
signal muerto,muertisimo: std_logic :='0';
signal Kmuerto: std_logic :='0';
signal pause: std_logic :='1';
signal crece: std_logic :='0';
signal rstart,start: std_logic :='0';
signal velocidad: std_logic_vector(24 downto 0):= "0111111111111111111111110";
signal kvelocidad: std_logic_vector(24 downto 0):= "0111111111111111111111110";
--pantalla
signal hpos:integer range 0 to vga_hpx_max   := 10*pixelH;
signal vpos:integer range 0 to vga_vpx_max   :=10*pixelV;
signal khpos:integer range 0 to vga_hpx_max  := 10*pixelH;
signal kvpos:integer range 0 to vga_vpx_max  :=10*pixelV;

signal LEDS2 :   STD_LOGIC_VECTOR(20 downto 0);


SIGNAL Reset_n : STD_LOGIC;
SIGNAL clko    : STD_LOGIC;
signal clock2 : std_logic;

--=========================END SIGNALS=================================================

begin
clock2 <= clock;
--==========================PORT MAP====================================================
--Control_Teclado: keyboard port map(clk_teclado,bit_teclado,teclaLeida,Ktecla);
Pala_1: paddle port map(clock,Reset_n,baja_1,sube_1,pala_1_vpos);
Pala_2: paddle port map(clock,Reset_n,baja_2,sube_2,pala_2_vpos);
UART_Teclado: keyboardUART port map(clock,Reset_n,rx,teclaLeida,Ktecla,tx,RxErr);
Nreloj_mov: divisor2 port map( velocidad,reset,clock,reloj_mov);
Control_VGA: vgacore port map(reset,clock,pala_1_vpos,pala_2_vpos,20,20,hsyncb,vsyncb,rgb);
--MyScore: score port map(reloj_mov,rstart,comido,LEDS2);
--========================END PORT MAP===============================================

--========================Procesar Tecla Leida============================================ 

			vpos<=kvpos;
			hpos<=khpos;

 muerto<=Kmuerto;
 velocidad<=kvelocidad;
 LEDS<=LEDS2;
 cKey: process(reset,Ktecla, reloj_mov)--mueve la cabeza de la serpiente
 begin
	if reset='1' OR Ktecla(5) = '1' then--reset total
		kvpos<=pixelV*10;
		khpos<=pixelH*10;
		Kmuerto<='0';
		pause<='1';
		teclaLeida<='1';
		start<='1';
		rstart<='1';
		kvelocidad<="0111111111111111111111110";
	elsif (reloj_mov'event and reloj_mov='1') then
		teclaLeida<='0';
		if vpos=0
			OR hpos=0 
			OR vpos=pixelV 
			OR hpos=pixelH 
			OR muerto='1'
		then --muerto antes
			khpos<=hpos;
			kvpos<=vpos;
			Kmuerto<='1';
			pause<='1';
			start<='0';
			rstart<='0';
			kvelocidad<=velocidad;

		else --si no he muerto y no restart
			start<='0';
			rstart<='0';
			kvelocidad<=velocidad;
			teclaLeida<='1';
			if Ktecla(1) = '1' and vpos > vga_vpx_min then --arr
				sube_1 <= '1';
				baja_1 <= '0';
				sube_2 <= '0';
				baja_2 <= '0';
				pause<='0';
			elsif Ktecla(2) = '1' and hpos < vga_hpx_max then --der
				sube_1 <= '0';
				baja_1 <= '0';
				sube_2 <= '1';
				baja_2 <= '0';
				pause<='0';
			elsif Ktecla(3) = '1' and vpos < vga_vpx_max then --abj
				sube_1 <= '0';
				baja_1 <= '1';
				sube_2 <= '0';
				baja_2 <= '0';
				pause<='0';
			elsif Ktecla(4) = '1' and hpos > vga_hpx_min then --izq
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
--			if muertisimo='1' then
--				Kmuerto<='1';
--			else
--				Kmuerto<='0';
--			end if;
--			
		end if;
	end if;
end process cKey;
--========================FIn procesar tecla=================================================


----=============================esta MUERTO===============================================
--process (khpos,kvpos)
--begin
--	muertisimo<='0';
--	for i in 1 to N-1 loop
--		if(kvpos=vcuerpo(i) and khpos=hcuerpo(i) and sizeSNK(i-1)='1') then
--			muertisimo<='1';
--		end if;
--	end loop;
--end process;

--==============================fin================================================
Reset_n <= Reset;



end Behavioral;

