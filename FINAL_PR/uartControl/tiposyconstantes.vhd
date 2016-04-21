----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package tiposyconstantes is
constant N: integer :=18;
constant sizeX: integer :=6;
constant sizeY: integer :=10;
constant maxX: integer :=sizeX*20;--coordenadas maximas
constant maxY: integer :=sizeY*20;--coordenadas maximas

type vectorH is array (0 to N-1) of integer range 0 to maxX+sizeX;
type vectorV is array (0 to N-1) of integer range 0 to maxY+sizeY;
type vectorHpasti is array (0 to 20) of integer range 0 to maxX+sizeX;
type vectorVpasti is array (0 to 20) of integer range 0 to maxY+sizeY;

  constant keyboardIZQ : std_logic_vector(7 downto 0) := X"04";--X"1C";--a
  constant keyboardDER : std_logic_vector(7 downto 0) := X"06";--X"23";--d
  constant keyboardABJ : std_logic_vector(7 downto 0) := X"05";--X"1B";--s
  constant keyboardARR : std_logic_vector(7 downto 0) := X"01"; --X"1D";--w"
  constant keyboardRESET : std_logic_vector(7 downto 0) := X"0F";--X"76";--ESC
  constant keyboardPAUSE : std_logic_vector(7 downto 0) := X"0E";--X"29";--espacio
  constant keyboardCRECE : std_logic_vector(7 downto 0) := X"0D";--X"15";--espacio
  
  
end tiposyconstantes;

package body tiposyconstantes is


 
end tiposyconstantes;
