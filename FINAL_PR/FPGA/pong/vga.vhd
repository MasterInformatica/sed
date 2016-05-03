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

entity vgacore2 is
	port
	(
		reset: in std_logic;	-- reset
		clock: in std_logic;
	
		hsyncb: inout std_logic;	-- horizontal (line) sync
		vsyncb: out std_logic;	-- vertical (frame) sync
		rgb: out std_logic_vector(8 downto 0) -- B G R colors
	);
end vgacore2;



architecture vgacore_arch of vgacore2 is
signal reloj: std_logic;
signal cuenta: std_logic_vector(1 downto 0);

signal hcnt: std_logic_vector(8 downto 0);	-- horizontal pixel counter
signal vcnt: std_logic_vector(9 downto 0);	-- vertical line counter

-- carta de ajuste
signal pintar_especial: std_logic;
signal pintar_especial_rgb: std_logic_vector(8 downto 0);
-- elementos de la escena
signal pintar_pared: std_logic;



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


--------------------------------------------------------------------------------------
-- Carta de ajustes en la parte superior de la pantalla para comprobar que todo ok
carta_ajuste: process(hcnt, vcnt)
begin
	pintar_especial <= '0';
	pintar_especial_rgb <= (others=>'0');

	if vcnt > 0 and vcnt < 8 then
		pintar_especial<='1';
		if hcnt > 0 and hcnt < 35 then
			pintar_especial_rgb <= "111000000";
		elsif hcnt > 0 and hcnt < 70 then
			pintar_especial_rgb <= "000111000";
		elsif hcnt > 0 and hcnt < 105 then
			pintar_especial_rgb <= "000000111";
		elsif hcnt > 0 and hcnt < 140 then
			pintar_especial_rgb <= "111000000";
		elsif hcnt > 0 and hcnt < 175 then
			pintar_especial_rgb <= "111111000";
		elsif hcnt > 0 and hcnt < 210 then
			pintar_especial_rgb <= "111000111";			
		elsif hcnt > 0 and hcnt < 245 then
			pintar_especial_rgb <= "000111111";
		elsif hcnt > 0 and hcnt < 280 then
			pintar_especial_rgb <= "111111111";		
		end if;
	end if;
		
end process;

--------------------------------------------------------------------------------------
-- 6px horizontal equivalen a 10 en vertical (más o menos)
que_pintar: process(hcnt,vcnt)
begin
	pintar_pared<='0';	
	
	if hcnt > 0 and hcnt < 280 then
		if vcnt >=10 and vcnt <= 13 then --pared superior
			pintar_pared<='1';
		elsif vcnt >=436 and vcnt <=439 then --pared inferior
			pintar_pared<='1';
		end if;
	end if;
	if hcnt = 140 then --linea central
		if vcnt > 0 and vcnt(4 downto 2)="111" and vcnt <=439 then
			pintar_pared<='1';
		end if;
	end if;
end process que_pintar;

colorear: process(hcnt,vcnt)
begin
	if pintar_especial='1' then
		rgb <= pintar_especial_rgb;
	elsif pintar_pared='1' then
		rgb<="111111111";
	else 
		rgb <="000000000";
	end if;
end process colorear;
---------------------------------------------------------------------------
end vgacore_arch;