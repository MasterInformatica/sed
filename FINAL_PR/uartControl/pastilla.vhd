----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:36:27 12/10/2012 
-- Design Name: 
-- Module Name:    pastilla - Behavioral 
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


entity pastilla is
	Port ( 
				reset: in std_logic;
				clk_game : in  std_logic;
				comido : in  std_logic;
				pasti_vpos: out integer range 0 to maxY+sizeY;
				pasti_hpos: out integer range 0 to maxX+sizeX
			 );
end pastilla;

architecture Behavioral of pastilla is

signal vpos,kvpos: vectorVpasti;
signal hpos,khpos: vectorHpasti;

begin
pasti_vpos<=kvpos(0);
pasti_hpos<=khpos(0);
vpos<=kvpos;
hpos<=khpos;
process(reset,clk_game,comido)
begin
	if reset='1' then

		khpos(20)<=12;
		khpos(19)<=24;
		khpos(18)<=36;
		khpos(17)<=48;
		khpos(16)<=66;
		khpos(15)<=72;
		khpos(14)<=90;
		khpos(13)<=108;
		khpos(12)<=114;
		khpos(11)<=54;
		khpos(10)<=108;
		khpos(9)<=36;
		khpos(8)<=6;
		khpos(7)<=114;
		khpos(6)<=102;
		khpos(5)<=54;
		khpos(4)<=48;
		khpos(3)<=84;
		khpos(2)<=90;
		khpos(1)<=96;
		khpos(0)<=78;
		kvpos(20)<=10;
		kvpos(19)<=30;
		kvpos(18)<=40;
		kvpos(17)<=30;
		kvpos(16)<=70;
		kvpos(15)<=100;
		kvpos(14)<=180;
		kvpos(13)<=190;
		kvpos(12)<=20;
		kvpos(11)<=40;
		kvpos(10)<=60;
		kvpos(9)<=110;
		kvpos(8)<=120;
		kvpos(7)<=170;
		kvpos(6)<=180;
		kvpos(5)<=140;
		kvpos(4)<=110;
		kvpos(3)<=90;
		kvpos(2)<=40;
		kvpos(1)<=20;
		kvpos(0)<=160;
	elsif clk_game'event and clk_game='1' then
		if comido='1' then
			kvpos(0 to 19)<=vpos(1 to 20);
			khpos(0 to 19)<=hpos(1 to 20);
			khpos(20)<=hpos(0);
			kvpos(20)<=vpos(0);
		else
			kvpos(1 to 19)<=vpos(2 to 20);
			khpos(1 to 19)<=hpos(2 to 20);	
			khpos(20)<=hpos(1);
			kvpos(20)<=vpos(1);	
			kvpos(0)<=vpos(0);
			khpos(0)<=hpos(0);
		end if;
	else
		khpos<=hpos;
		kvpos<=vpos;
	end if;
end process;

end Behavioral;

