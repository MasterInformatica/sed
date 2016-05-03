----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:28:33 05/03/2016 
-- Design Name: 
-- Module Name:    pala - Behavioral 
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

entity pala is
    Port ( clk : in  STD_LOGIC;
           Reset_n : in  STD_LOGIC;
           baja : in  STD_LOGIC;
           sube : in  STD_LOGIC;
           posicion : out integer range 0 to maxY+sizeY
			  );
end pala;

architecture Behavioral of pala is
signal pos : integer range 0 to maxY+sizeY;
begin

posicion <= pos;

move_pala: process(clk,Reset_n,baja,sube)
begin
	if (Reset_n = '1') then
		pos <= 45;
	elsif clk'event and clk = '0' then
		if sube = '1' then
			pos <= pos - pixelY;
		elsif baja = '1' then
			pos <= pos + pixelY;
		else
			pos <= pos;
		end if;
	end if;
end process move_pala;

end Behavioral;

