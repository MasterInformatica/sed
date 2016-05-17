library IEEE;
use IEEE.STD_LOGIC_1164.all;

package tiposyconstantes is

---------
-- VGA --
---------
-- GLOBALES
constant pixelH 		        : integer  :=  6; -- size X de un cuadrado en pixeles
constant pixelV 	   		  : integer  := 20; -- size Y de un cuadrado en pixeles
constant vga_global_hpx_min  : integer  := 0;
constant vga_global_hpx_max  : integer  := 280;
constant vga_global_vpx_min  : integer  := 0;
constant vga_global_vpx_max  : integer  := 450;

constant tam_cartaAjuste : integer  := 3;

----------
-- GAME --
----------
-- Bordes
constant tam_pared    : integer  := 3;

-- VGA
constant vga_hpx_min  : integer  := vga_global_hpx_min;
constant vga_hpx_max  : integer  := vga_global_hpx_max - pixelH;
constant vga_vpx_min  : integer  := vga_global_vpx_min + tam_cartaAjuste + tam_pared+1;
constant vga_vpx_max  : integer  := vga_global_vpx_max - tam_pared;

constant vga_hpx_medio : integer := vga_hpx_min + (vga_hpx_max - vga_hpx_min)/2;
constant vga_vpx_medio : integer := vga_vpx_min + (vga_vpx_max - vga_vpx_min)/2;

-- PADDLE 
constant hpx_gap	    : integer  := pixelH * 2;
constant paddle_size  : integer	:= 5;
constant paddle_hpx   : integer  := pixelH * 1;
constant paddle_vpx   : integer  := pixelV * paddle_size;
constant paddle_vmid  : integer  := vga_vpx_min + ((( vga_vpx_max - vga_vpx_min ) / pixelV ) / 2 ) * pixelV;
constant paddle_vmin  : integer  := vga_vpx_min;-- + (pixelV * ((paddle_size-1) / 2));
constant paddle_vmax  : integer  := vga_vpx_max;-- - (pixelV * ((paddle_size-1) / 2));

--BALL
constant ball_hpx     : integer  := pixelH;
constant ball_vpx     : integer  := pixelV / 2;


------------------
-- MVTO. CHOQUE --
------------------
constant tramo1 : integer := 0;
constant tramo2 : integer := 1;
constant tramo3 : integer := 2;

-------------
-- COLORES --
-------------
--DEF
constant rgb_white     : std_logic_vector(8 downto 0) := "111111111";
constant rgb_black     : std_logic_vector(8 downto 0) := "000000000";
constant rgb_blue      : std_logic_vector(8 downto 0) := "111000000";
constant rgb_green     : std_logic_vector(8 downto 0) := "000111000";
constant rgb_red       : std_logic_vector(8 downto 0) := "000000111";
constant rgb_pink      : std_logic_vector(8 downto 0) := "111000111";
constant rgb_yellow    : std_logic_vector(8 downto 0) := "000111111";
constant rgb_cian      : std_logic_vector(8 downto 0) := "111111000";
--JUEGO
constant color_paddle  : std_logic_vector(8 downto 0) := rgb_white;
constant color_pared   : std_logic_vector(8 downto 0) := rgb_blue;
constant color_bola    : std_logic_vector(8 downto 0) := rgb_red;




------------------------------- OLD --------------------------------------
--constant N: integer :=18;
--constant sizeX: integer :=6;
--constant sizeY: integer :=10;
--constant maxX: integer :=sizeX*35;--coordenadas maximas
--constant maxY: integer :=sizeY*35;--coordenadas maximas
--
--type vectorH is array (0 to N-1) of integer range 0 to maxX+sizeX;
--type vectorV is array (0 to N-1) of integer range 0 to maxY+sizeY;
--type vectorHpasti is array (0 to 20) of integer range 0 to maxX+sizeX;
--type vectorVpasti is array (0 to 20) of integer range 0 to maxY+sizeY;
--------------------------------------------------------------------------

---------------------------- UART control --------------------------------
  constant ukeyboardIZQ : std_logic_vector(3 downto 0) := X"4";   --a
  constant ukeyboardDER : std_logic_vector(3 downto 0) := X"6";   --d
  constant ukeyboardABJ : std_logic_vector(3 downto 0) := X"5";   --s
  constant ukeyboardARR : std_logic_vector(3 downto 0) := X"1";   --w"
  constant ukeyboardRESET : std_logic_vector(3 downto 0) := X"F"; --ESC
  constant ukeyboardPAUSE : std_logic_vector(3 downto 0) := X"E"; --espacio
  constant ukeyboardCRECE : std_logic_vector(3 downto 0) := X"D"; --espacio
--------------------------------------------------------------------------  

-------------------------- KeyBoard control ------------------------------
  constant keyboardIZQ : std_logic_vector(7 downto 0) := X"1C";     --a
  constant keyboardDER : std_logic_vector(7 downto 0) := X"23";     --d
  constant keyboardABJ : std_logic_vector(7 downto 0) := X"1B";     --s
  constant keyboardARR : std_logic_vector(7 downto 0) := X"1D";     --w"
  constant keyboardRESET : std_logic_vector(7 downto 0) := X"76";   --ESC
  constant keyboardPAUSE : std_logic_vector(7 downto 0) := X"29";   --espacio
  constant keyboardCRECE : std_logic_vector(7 downto 0) := X"15";   --(??)
--------------------------------------------------------------------------    
  
end tiposyconstantes;





package body tiposyconstantes is
end tiposyconstantes;
