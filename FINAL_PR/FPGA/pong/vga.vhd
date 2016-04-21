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
		clock: in std_logic;
		
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
signal hcnt: std_logic_vector(8 downto 0);	-- horizontal pixel counter
signal vcnt: std_logic_vector(9 downto 0);	-- vertical line counter


signal pintarR: std_logic; 
signal pintarG: std_logic; 
signal pintarB: std_logic; 
signal pintarBl: std_logic; 
signal pintarW: std_logic; 
signal reloj : std_logic;

begin


Nreloj_vga: divisor port map( conv_std_logic_vector(integer(3),25),reset,clock,reloj);

A: process(reloj,reset)
begin
	-- reset asynchronously clears pixel counter
	if reset='1' then
		hcnt <= "000000000";
	-- horiz. pixel counter increments on rising edge of dot clock
	elsif (reloj'event and reloj='1') then
		-- horiz. pixel counter rolls-over after 381 pixels
		if hcnt<380 then
			hcnt <= hcnt + 1;
		else
			hcnt <= "000000000";
		end if;
	end if;
end process;


B: process(hsyncb,reset)
begin
	-- reset asynchronously clears line counter
	if reset='1' then
		vcnt <= "0000000000";
	-- vert. line counter increments after every horiz. line
	elsif (hsyncb'event and hsyncb='1') then
		-- vert. line counter rolls-over after 528 lines
		if vcnt<527 then
			vcnt <= vcnt + 1;
		else
			vcnt <= "0000000000";
		end if;
	end if;
end process;

C: process(reloj,reset)
begin
	-- reset asynchronously sets horizontal sync to inactive
	if reset='1' then
		hsyncb <= '1';
	-- horizontal sync is recomputed on the rising edge of every dot clock
	elsif (reloj'event and reloj='1') then
		-- horiz. sync is low in this interval to signal start of a new line
		if (hcnt>=291 and hcnt<337) then
			hsyncb <= '0';
		else
			hsyncb <= '1';
		end if;
	end if;
end process;

E: process(hsyncb,reset)
begin
	-- reset asynchronously sets vertical sync to inactive
	if reset='1' then
		vsyncb <= '1';
	-- vertical sync is recomputed at the end of every line of pixels
	elsif (hsyncb'event and hsyncb='1') then
		-- vert. sync is low in this interval to signal start of a new frame
		if (vcnt>=490 and vcnt<492) then
			vsyncb <= '0';
		else
			vsyncb <= '1';
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
que_pintar: process(hcnt,vcnt)
begin

	pintarB<='0';
		 if hcnt > 94+78 and hcnt < 100+78 then
			if vcnt > 92+160 and vcnt < 100+160 then
				pintarB<='1';
		end if;
		end if;
	pintarG<='0';
		 if hcnt > 94+78+6 and hcnt < 100+78+6 then
			if vcnt > 92+160+7 and vcnt < 100+160+7 then
				pintarG<='1';
		end if;
		end if;
	pintarR<='0';
		 if hcnt > 94+78+12 and hcnt < 100+78+12 then
			if vcnt > 92+160+14 and vcnt < 100+160+14 then
				pintarR<='1';
		end if;
	end if;	
	pintarBl<='0';
		 if hcnt > 94+78+18 and hcnt < 100+78+18 then
			if vcnt > 92+160+14 and vcnt < 100+160+14 then
				pintarBl<='1';
		end if;
	end if;	
	pintarW<='0';
		 if hcnt > 94+78+24 and hcnt < 100+78+24 then
			if vcnt > 92+160+14 and vcnt < 100+160+14 then
				pintarW<='1';
		end if;
end if;
end process que_pintar;

colorear: process(pintarR,pintarG,pintarB,pintarBl,pintarW,hcnt,vcnt)
begin
	if pintarR='1' then
		rgb<="000000111";
	elsif pintarG='1' then
		rgb<="000111000";
	elsif pintarB='1' then
		rgb<="111000000";
	elsif pintarBl='1' then
		rgb<="000000000";
	elsif pintarW='1' then
		rgb<="111111111";

	else
		rgb<="000000001";
	end if;
end process colorear;

---------------------------------------------------------------------------
end vgacore_arch;