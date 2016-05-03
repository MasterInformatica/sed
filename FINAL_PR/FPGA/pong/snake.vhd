----------------------------------------------------------------------------------
-- Company: JJDA
-- Engineer: Jesús Javier Doménech Arellano - 47470902Y
-- 
-- Create Date:    12:38:19 11/26/2012 
-- Design Name: 
-- Module Name:    snake - Behavioral 
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
entity snake is
    Port ( 
				reset: in std_logic;
				clk_game : in  std_logic;
				pause: in std_logic;
				new_head_hpos:IN integer range 0 to maxX+sizeX;
				new_head_vpos:IN integer range 0 to maxY+sizeY;
				crece : in  std_logic;
				vcuerpo: out vectorV;
				hcuerpo: out vectorH;
				sizeSNK :out std_logic_vector(N-2 downto 0)
			 );
end snake;

architecture Behavioral of snake is
signal kvcuerpo: vectorV;
signal khcuerpo: vectorH;
signal tmp_sizeSNK: std_logic_vector(N-2 downto 0):=(others=>'0');
signal tmp2_sizeSNK: std_logic_vector(N-2 downto 0):=(others=>'0');
begin
--================DESPLAZAMIENTO======================
sizeSNK<=tmp2_sizeSNK;
tmp_sizeSNK<=tmp2_sizeSNK;
vcuerpo<=kvcuerpo;
hcuerpo<=khcuerpo;
	process(clk_game,reset,new_head_vpos,new_head_hpos)
	begin
		if reset='1' then
			kvcuerpo(1 to N-1)<=(others =>0);
			kvcuerpo(0)<=new_head_vpos;
			khcuerpo(1 to N-1)<=(others =>0);
			khcuerpo(0)<=new_head_hpos;
			tmp2_sizeSNK<=(others=>'0');
		elsif clk_game' event and clk_game='1' then 
			if pause='0' then
				kvcuerpo(1 to N-1)<=kvcuerpo(0 to N-2);
				kvcuerpo(0)<=new_head_vpos;
				khcuerpo(1 to N-1)<=khcuerpo(0 to N-2);
				khcuerpo(0)<=new_head_hpos;
				if crece='1' then
					tmp2_sizeSNK(0)<='1';
					tmp2_sizeSNK(N-2 downto 1)<=tmp_sizeSNK(N-3 downto 0);
				else
					tmp2_sizeSNK<=tmp_sizeSNK;
				end if;
			else
				tmp2_sizeSNK<=tmp_sizeSNK;
				kvcuerpo<=kvcuerpo;
				khcuerpo<=khcuerpo;
			end if;
		end if;
	end process;
--=============== FIN DESPLAZAMIENTO =================

end Behavioral;

