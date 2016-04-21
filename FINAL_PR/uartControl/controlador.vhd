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
--      bit_teclado : in std_logic;--Entrada teclado
		rx : in std_logic;
		tx : out std_logic;
		hsyncb: inout std_logic;	-- horizontal (line) sync
		vsyncb: out std_logic;	-- vertical (frame) sync
		--tecla: out std_logic_vector(5 downto 0);--Tecla pulsada
		rgb: out std_logic_vector(8 downto 0); -- SALIDA a la pantalla
		LEDS: out std_logic_vector(20 downto 0);
		caca: out std_logic_vector(7 downto 0)
	);
end main;

architecture Behavioral of main is

--=============================COMPONENTES=================================================
-- Controlador del teclado
component Keyboard is
	port (
		clk_teclado : in std_logic;
		bit_teclado : in std_logic;
		teclaLeida: in std_logic;
		tecla : out std_logic_vector(5 downto 0)
	);
end component;


component keyboardUART is
	  PORT (
		 clko     : IN STD_LOGIC;
		 Reset_n   : IN STD_LOGIC;
       UART_Rx : IN STD_LOGIC;
		 teclaLeida: in std_logic;
        tecla : out std_logic_vector(5 downto 0);
		 UART_Tx : OUT STD_LOGIC;
		 cacota : out std_logic_vector(7 downto 0)
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
	port
	(
		reset: in std_logic;	-- reset
		reloj: in std_logic;
		vcuerpo: in vectorV;
		hcuerpo: in vectorH;
		sizeSNK: in std_logic_vector(N-2 downto 0);
		pasti_vpos: in integer range 0 to maxY+sizeY;
		pasti_hpos: in integer range 0 to maxX+sizeX;
		muerto: inout std_logic;
		hsyncb: inout std_logic;	-- horizontal (line) sync
		vsyncb: out std_logic;	-- vertical (frame) sync
		rgb: out std_logic_vector(8 downto 0) -- B G R colors
	);
end component;

--SNAKE
component snake is
    Port ( 
				reset: in std_logic;
				clk_game : in  STD_LOGIC;
				pause: in std_logic;
				new_head_hpos:IN integer range 0 to maxX+sizeX;
				new_head_vpos:IN integer range 0 to maxY+sizeY;
				crece : in  STD_LOGIC;
				vcuerpo: out vectorV;
				hcuerpo: out vectorH;
				sizeSNK :out std_logic_vector(N-2 downto 0)
			 );
end component;

-- Generador de pastillas
component pastilla is
	Port ( 
				reset: in std_logic;
				clk_game : in  std_logic;
				comido : in  std_logic;
				pasti_vpos: out integer range 0 to maxY+sizeY;
				pasti_hpos: out integer range 0 to maxX+sizeX
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
--juego
signal muerto,muertisimo: std_logic :='0';
signal Kmuerto: std_logic :='0';
signal pause: std_logic :='1';
signal crece: std_logic :='0';
signal rstart,start: std_logic :='0';
signal velocidad: std_logic_vector(24 downto 0):= "0001111111111111111111110";
signal kvelocidad: std_logic_vector(24 downto 0):= "0001111111111111111111110";
--pantalla
signal hpos:integer range 0 to maxX+sizeX:= 10*sizeX;
signal vpos:integer range 0 to maxY+sizeY:=10*sizeY;
signal khpos:integer range 0 to maxX+sizeX:= 10*sizeX;
signal kvpos:integer range 0 to maxY+sizeY:=10*sizeY;
--snake
signal vcuerpo: vectorV;
signal hcuerpo: vectorH;
signal sizeSNK : std_logic_vector(N-2 downto 0):=(others=>'0');
--pastilla
signal comido: std_logic:='1';
signal pasti_hpos:integer range 0 to maxX+sizeX:= 60;
signal pasti_vpos:integer range 0 to maxY+sizeY:= 36;
signal LEDS2 :   STD_LOGIC_VECTOR(20 downto 0);


SIGNAL Reset_n : STD_LOGIC;
SIGNAL clko    : STD_LOGIC;
signal clock2 : std_logic;

--=========================END SIGNALS=================================================integer(16777000)

begin
clock2 <= clock;
--==========================PORT MAP====================================================
--Control_Teclado: keyboard port map(clk_teclado,bit_teclado,teclaLeida,Ktecla);
UART_Teclado: keyboardUART port map(clko,Reset_n,rx,teclaLeida,Ktecla,tx,caca);
Nreloj_uart: divisor2 port map( conv_std_logic_vector(integer(1),25),reset,clock,clko);
Nreloj_vga: divisor2 port map( conv_std_logic_vector(integer(3),25),reset,clock,reloj_vga);
Nreloj_mov: divisor2 port map( velocidad,reset,clock,reloj_mov);
Control_VGA: vgacore port map(reset,reloj_vga,vcuerpo,hcuerpo,sizeSNK,pasti_vpos,pasti_hpos,muerto,hsyncb,vsyncb,rgb);
Serpiente: snake port map(start,reloj_mov,pause,hpos,vpos,crece,vcuerpo,hcuerpo,sizeSNK);
Pastillas: pastilla port map(start,reloj_mov,comido,pasti_vpos,pasti_hpos);
MyScore: score port map(reloj_mov,rstart,comido,LEDS2);
--========================END PORT MAP===============================================
--inst_divisor: divisor PORT MAP(
--		CLKIN_IN => clock2,
--		RST_IN => Reset_n,
--		CLKDV_OUT => clko,
--		CLKIN_IBUFG_OUT => open,
--		CLK0_OUT => open
--);
--========================Procesar Tecla Leida============================================ 
--process(muertisimo,muerto)
--begin
--
--		if muertisimo='0' OR muerto ='0' then
			vpos<=kvpos;
			hpos<=khpos;
--		else
--			vpos<=vpos;
--			hpos<=hpos;
--		end if;
----	end if;
-- end process;
 --tecla<=Ktecla;
 muerto<=Kmuerto;
 velocidad<=kvelocidad;
 LEDS<=LEDS2;
 cKey: process(reset,Ktecla, reloj_mov)--mueve la cabeza de la serpiente
 begin
	if reset='1' OR Ktecla(5) = '1' then--reset total
		kvpos<=sizeY*10;
		khpos<=sizeX*10;
		Kmuerto<='0';
		crece<='0';
		pause<='1';
		teclaLeida<='1';
		comido<='1';
		start<='1';
		rstart<='1';
		kvelocidad<="0001111111111111111111110";
	elsif (reloj_mov'event and reloj_mov='1') then
		teclaLeida<='0';
		if vpos=0
			OR hpos=0 
			OR vpos=maxY 
			OR hpos=maxX 
			OR muerto='1'
		then --muerto antes
			khpos<=hpos;
			kvpos<=vpos;
			Kmuerto<='1';
			crece<='0';
			pause<='1';
			comido<='0';
			start<='0';
			rstart<='0';
			kvelocidad<=velocidad;
		elsif sizeSNK(N-2)='1' and hpos=pasti_hpos and vpos=pasti_vpos then --next level tamaño maximo y comido
			kvpos<=sizeY*6;
			khpos<=sizeX*6;
			Kmuerto<='0';
			crece<='0';
			pause<='1';
			teclaLeida<='1';
			comido<='0';
			comido<='0';
			start<='1';
			rstart<='0';
			kvelocidad<=velocidad-6;
		else --si no he muerto y no restart
			start<='0';
			rstart<='0';
			kvelocidad<=velocidad;
			if (hpos=pasti_hpos and vpos=pasti_vpos) then --comer pastilla
				comido<='1';
				crece<='1';
			else --no comer
				comido<='0';
				crece<='0';
			end if;
			if Ktecla(1) = '1' and vpos>0 then --arr
				kvpos<=vpos-sizeY;	
				khpos<=hpos;
				pause<='0';
			elsif Ktecla(2) = '1' and hpos < maxX then --der
				khpos<=hpos+sizeX;
				kvpos<=vpos;
				pause<='0';
			elsif Ktecla(3) = '1' and vpos < maxY then --abj
				kvpos<=vpos+sizeY;
				khpos<=hpos;
				pause<='0';
			elsif Ktecla(4) = '1' and hpos > 0 then --izq
				khpos<=hpos-sizeX;
				kvpos<=vpos;
				pause<='0';
			elsif Ktecla(0) = '1' then --pause
				khpos<=hpos;
				kvpos<=vpos;
				pause<='1';
			else
				khpos<=hpos;
				kvpos<=vpos;
				pause<=pause;
			end if;
			if muertisimo='1' then
				Kmuerto<='1';
			else
				Kmuerto<='0';
			end if;
			
		end if;
	end if;
end process cKey;
--========================FIn procesar tecla=================================================


--=============================esta MUERTO===============================================
process (vcuerpo,hcuerpo,sizeSNK,khpos,kvpos,muerto)
begin
	muertisimo<='0';
	for i in 1 to N-1 loop
		if(kvpos=vcuerpo(i) and khpos=hcuerpo(i) and sizeSNK(i-1)='1') then
			muertisimo<='1';
		end if;
	end loop;
end process;

--==============================fin================================================
Reset_n <= Reset;



end Behavioral;

