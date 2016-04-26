----------------------------------------------------------------------------------
-- Company: JJDA
-- Engineer: Jesús Javier Doménech Arellano - 47470902Y
-- 
-- Create Date:    12:41:21 11/26/2012 
-- Design Name: 
-- Module Name:    vga - Behavioral 
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
use IEEE.numeric_std.all;

entity vgacore is
	port
	(
		reset: in std_logic;	-- reset
		clock: in std_logic;
	
		hsyncb: inout std_logic;	-- horizontal (line) sync
		vsyncb: out std_logic;	-- vertical (frame) sync
		rgb: out std_logic_vector(8 downto 0) -- B G R colors
	);
end vgacore;



architecture vgacore_arch of vgacore is

signal hcnt: std_logic_vector(8 downto 0);	-- horizontal pixel counter
signal vcnt: std_logic_vector(9 downto 0);	-- vertical line counter
signal pintar: std_logic;
signal reloj: std_logic;

signal cuenta: std_logic_vector(1 downto 0);

begin

as: process(reset, clock, cuenta)
begin
	if(reset='1') then
		cuenta <= "00";
	elsif(clock'event and clock='1') then
		if(cuenta="11") then
			reloj <= not reloj;
			cuenta <= "00";
		else
			cuenta <= cuenta + 1;
		end if;
	end if;
end process;
	
	
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
	pintar<='0';
		 if hcnt > 94 and hcnt < 100 then
			if vcnt > 90 and vcnt < 100 then
				pintar<='1';
			end if;
		end if;
	--pinta snk
--	
--		if hcnt > 94+hcuerpo(0) and hcnt < 100+hcuerpo(0) then
--			if vcnt > 90+vcuerpo(0) and vcnt < 100+vcuerpo(0) then
--				pintar_snk<='1';
--			end if;
--		end if;
--		for i in 1 to N-1 loop
--			if hcnt > 94+hcuerpo(i) and hcnt < 100+hcuerpo(i) then
--				if vcnt > 90+vcuerpo(i) and vcnt < 100+vcuerpo(i) then
--					pintar_snk<=sizeSNK(i-1);
--				end if;
--			end if;
--		end loop;
----		if hcnt > 94+hcuerpo(2) and hcnt < 100+hcuerpo(2) then
----			if vcnt > 90+vcuerpo(2) and vcnt < 100+vcuerpo(2) then
----				pintar_snk<=sizeSNK(1);
----			end if;
----		end if;
----		if hcnt > 94+hcuerpo(3) and hcnt < 100+hcuerpo(3) then
----			if vcnt > 90+vcuerpo(3) and vcnt < 100+vcuerpo(3) then
----				pintar_snk<=sizeSNK(2);
----			end if;
----		end if;
----		if hcnt > 94+hcuerpo(4) and hcnt < 100+hcuerpo(4) then
----			if vcnt > 90+vcuerpo(4) and vcnt < 100+vcuerpo(4) then
----				pintar_snk<=sizeSNK(3);
----			end if;
----		end if;
----		if hcnt > 94+hcuerpo(5) and hcnt < 100+hcuerpo(5) then
----			if vcnt > 90+vcuerpo(5) and vcnt < 100+vcuerpo(5) then
----				pintar_snk<=sizeSNK(4);
----			end if;
----		end if;
----		if hcnt > 94+hcuerpo(6) and hcnt < 100+hcuerpo(6) then
----			if vcnt > 90+vcuerpo(6) and vcnt < 100+vcuerpo(6) then
----				pintar_snk<=sizeSNK(5);
----			end if;
----		end if;
----		if hcnt > 94+hcuerpo(7) and hcnt < 100+hcuerpo(7) then
----			if vcnt > 90+vcuerpo(7) and vcnt < 100+vcuerpo(7) then
----				pintar_snk<=sizeSNK(6);
----			end if;
----		end if;
----		if hcnt > 94+hcuerpo(8) and hcnt < 100+hcuerpo(8)then
----			if vcnt > 90+vcuerpo(8) and vcnt < 100+vcuerpo(8) then
----				pintar_snk<=sizeSNK(7);
----			end if;
----		end if;
----		if hcnt > 94+hcuerpo(9) and hcnt < 100+hcuerpo(9) then
----			if vcnt > 90+vcuerpo(9) and vcnt < 100+vcuerpo(9) then
----				pintar_snk<=sizeSNK(8);
----			end if;
----		end if;
----		if hcnt > 94+hcuerpo(10) and hcnt < 100+hcuerpo(10)  then
----			if vcnt > 90+vcuerpo(10) and vcnt < 100+vcuerpo(10) then
----				pintar_snk<=sizeSNK(9);
----			end if;
----		end if;
--	   if hcnt > 94 and hcnt < 220 and vcnt >  90 and vcnt < 101 then
--			pintar_wall<='1';
--	elsif hcnt > 94 and hcnt < 220 and vcnt > 290 and vcnt < 301 then
--			pintar_wall<='1';
--	elsif vcnt > 99 and vcnt < 291 and hcnt >  94 and hcnt < 101 then
--			pintar_wall<='1';
--	elsif vcnt > 99 and vcnt < 291 and hcnt > 214 and hcnt < 221 then
--			pintar_wall<='1';
--	end if;
end process que_pintar;

colorear: process(pintar,hcnt,vcnt)
begin
	if pintar='1' then rgb<="000000111";
	else rgb <="000000000";
	end if;
end process colorear;
---------------------------------------------------------------------------
end vgacore_arch;