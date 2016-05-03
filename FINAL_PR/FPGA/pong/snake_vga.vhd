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
use work.tiposyconstantes.all;

entity vgacore is
	port
	(
		reset: in std_logic;	-- reset
		reloj: in std_logic;
		pala_1_vpos : in integer range 0 to vga_vpx_max;
		pala_2_vpos : in integer range 0 to vga_vpx_max;
		muerto: inout std_logic;
		hsyncb: inout std_logic;	-- horizontal (line) sync
		vsyncb: out std_logic;	-- vertical (frame) sync
		rgb: out std_logic_vector(8 downto 0) -- B G R colors
	);
end vgacore;



architecture vgacore_arch of vgacore is

signal hcnt: std_logic_vector(8 downto 0);	-- horizontal pixel counter
signal vcnt: std_logic_vector(9 downto 0);	-- vertical line counter
signal pintar_wall: std_logic;
signal pintar_pala: std_logic;
signal pintar_pala_2: std_logic;

begin

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
	pintar_wall<='0';
	pintar_pala <='0';
	if hcnt > 94 and hcnt < 100 then
		if vcnt > 90+pala_1_vpos and vcnt < 100 +pala_1_vpos then
			pintar_pala <= '1';
		end if;
	end if;
	
	if hcnt > 194 and hcnt < 200 then
		if vcnt > 90+pala_2_vpos and vcnt < 100 +pala_2_vpos then
			pintar_pala <= '1';
		end if;
	end if;
	
	
		
	   if hcnt > 94 and hcnt < 220 and vcnt >  90 and vcnt < 101 then
			pintar_wall<='1';
	elsif hcnt > 94 and hcnt < 220 and vcnt > 290 and vcnt < 301 then
			pintar_wall<='1';
	elsif vcnt > 99 and vcnt < 291 and hcnt >  94 and hcnt < 101 then
			pintar_wall<='1';
	elsif vcnt > 99 and vcnt < 291 and hcnt > 214 and hcnt < 221 then
			pintar_wall<='1';
	end if;
end process que_pintar;

colorear: process(pintar_wall,hcnt,vcnt)
begin
	if pintar_pala = '1' then rgb <= "001011111";
   elsif pintar_wall='1' then rgb<="111000000";
	else rgb <="000000000";
	end if;
end process colorear;
---------------------------------------------------------------------------
end vgacore_arch;