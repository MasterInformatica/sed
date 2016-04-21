-- 
-- MODULO PARA CONTROLAR LA PANTALLA A PARTIR DE LAS SENYALES DE PADDLE Y BOLA
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.numeric_std.all;
entity vgacore is
	port
	(
		reset: in std_logic;                  -- reset
		reloj: in std_logic;
		
		hsyncb: inout std_logic;	           -- horizontal (line) sync
		vsyncb: out std_logic;	              -- vertical (frame) sync
		rgb: out std_logic_vector(8 downto 0) -- B G R colors
		
		-- pong stuff
		-- state(gameover, menu, start, win1, win2...)
		-- /paddle1/paddle2/ball/
		-- scrore
	);
end vgacore;


architecture vgacore_arch of vgacore is
-- DIVISOR que regula los relojes
component divisor is
	port(
		carga: in std_logic_vector(24 downto 0);--typa=1 => reloj pantalla; typa=0 =>reloj movimiento
		reset,clk: in std_logic;
		reloj: out std_logic
	);
end component;

------------------
-- CTES DE VGA  --
------------------
constant H_PIXELS: INTEGER:=640;
constant H_FRONT: INTEGER:=16;
constant H_BACK: INTEGER:=48;
constant H_SYNCTIME: INTEGER:=96;
constant H_PERIOD: INTEGER:= H_SYNCTIME + H_PIXELS + H_FRONT + H_BACK;

constant V_LINES: INTEGER:=480;
constant V_FRONT: INTEGER:=11;
constant V_BACK: INTEGER:=32;
constant V_SYNCTIME: INTEGER:=2;
constant V_PERIOD: INTEGER:= V_SYNCTIME + V_LINES + V_FRONT + V_BACK;




signal hcnt: std_logic_vector(9 downto 0);	-- horizontal pixel counter
signal vcnt: std_logic_vector(9 downto 0);	-- vertical line counter

signal clock : std_logic;
signal enable : std_logic;

begin


Nreloj_vga: divisor port map( conv_std_logic_vector(integer(3),25),reset,reloj,clock);


A: process(clock,reset)
begin
	-- reset asynchronously clears horizontal counter
	if reset = '0' then
		hcnt <= (others => '0');
	-- horiz. counter increments on rising edge of dot clock
	elsif (clock'event and clock = '1') then
		-- horiz. counter restarts after the horizontal period (set by the constants)
		if hcnt < H_PERIOD then
			hcnt <= hcnt + 1;
		else
			hcnt <= (others => '0');
		end if;
	end if;
end process;


B: process(hsyncb,reset)
begin
	-- reset asynchronously clears line counter
	if reset='0' then
		vcnt <= (others => '0');
	-- vert. line counter increments after every horiz. line
	elsif (hsyncb'event and hsyncb = '1') then
		-- vert. line counter rolls-over after the set number of lines (set by the constants)
		if vcnt < V_PERIOD then
			vcnt <= vcnt + 1;
		else
			vcnt <= (others => '0');
		end if;
	end if;
end process;


C: process(clock,reset)
begin
	-- reset asynchronously sets horizontal sync to inactive
	if reset = '0' then
		hsyncb <= '1';
	-- horizontal sync is recomputed on the rising edge of every dot clock
	elsif (clock'event and clock = '1') then
		-- horiz. sync is low in this interval to signal start of a new line
		if (hcnt >= (H_PIXELS + H_FRONT) and hcnt < (H_PIXELS + H_SYNCTIME + H_FRONT)) then
			hsyncb <= '0';
		else
			hsyncb <= '1';
		end if;
	end if;
end process;

-- set the vertical sync high time and low time according to the constants
D: process(hsyncb, reset)
begin
	-- reset asynchronously sets vertical sync to inactive
	if reset = '0' then
		vsyncb <= '1';
	-- vertical sync is recomputed at the end of every line of pixels
	elsif (hsyncb'event and hsyncb = '1') then
		-- vert. sync is low in this interval to signal start of a new frame
		if (vcnt >= (V_LINES + V_FRONT) and vcnt < (V_LINES + V_SYNCTIME + V_FRONT)) then
			vsyncb <= '0';
		else
			vsyncb <= '1';
		end if;
	end if;
end process;


E: process (clock)
begin
	if clock'EVENT and clock = '1' then
		-- if we are outside the visible range on the screen then tell the RAMDAC to blank
		-- in this section by putting enable low
		if hcnt >= H_PIXELS or vcnt >= V_LINES then
			enable <= '0';
		 else 
		 	enable <= '1';
		 end if;
	end if;
end process;

----------------------------------------------------------------------------
--
-- A partir de aqui escribir la parte de dibujar en la pantalla
--
-- Tienen que generarse al menos dos process uno que actua sobre donde
-- se va a pintar, decide de qué pixel a que pixel se va a pintar
-- Puede haber tantos process como señales pintar (figuras) diferentes 
-- queramos dibujar
--
-- Otro process (tipo case para dibujos complicados) que dependiendo del
-- valor de las diferentes señales pintar genera diferentes colores (rgb)
-- Sólo puede haber un process para trabajar sobre rgb
--
----------------------------------------------------------------------------
--
----------------------------------------------------------------------------
--6px horizontal equivalen a 10 en vertical
--
--que_pintar: process(hcnt,vcnt)
--begin
--	pintar <='0';
--	if hcnt <=640 then
--		if vcnt <= 480 then
--			pintar<='1';
--		end if;
--	end if;
--
--end process que_pintar;
--
--colorear: process(pintar,hcnt,vcnt)
--begin
--	if pintar ='1' then
--		rgb<="111000000";
--	else
--		rgb<="000000111";
--	end if;
--end process colorear;

rgb<="111000000";

---------------------------------------------------------------------------
end vgacore_arch;