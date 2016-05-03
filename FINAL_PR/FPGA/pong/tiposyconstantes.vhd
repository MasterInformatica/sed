library IEEE;
use IEEE.STD_LOGIC_1164.all;

package tiposyconstantes is

---------
-- VGA --
---------
constant pixelH 	    : integer  :=  6; -- size X de un cuadrado en pixeles
constant pixelV 	    : integer  := 10; -- size Y de un cuadrado en pixeles
constant vga_hpx_min  : integer  := 10;
constant vga_hpx_max  : integer  := 280 - pixelH;
constant vga_vpx_min  : integer  := 9;
constant vga_vpx_max  : integer  := 439 - pixelV;


----------
-- GAME --
----------
constant hpx_gap	      : integer  := pixelH * 2;
-- PADDLE 
constant paddle_size  : integer	:= 5;
constant paddle_hpx   : integer  := pixelH * 1;
constant paddle_vpx   : integer  := pixelV * paddle_size;
constant paddle_vmid : integer  := ( ( ( vga_vpx_max - vga_vpx_min ) / pixelV ) / 2 ) * pixelV;

--BALL
constant ball_hpx     : integer  := pixelH;
constant ball_vpx     : integer  := pixelV;


-------------
-- COLORES --
-------------
constant color_paddle  : std_logic_vector(8 downto 0) := "111111111";
constant color_pared   : std_logic_vector(8 downto 0) := "111111111";
constant color_bola    : std_logic_vector(8 downto 0) := "111000000";




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
