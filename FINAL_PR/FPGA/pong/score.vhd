----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:54:03 12/12/2012 
-- Design Name: 
-- Module Name:    score - Behavioral 
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

entity score is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  gol_left: in std_logic;
			  gol_right: in std_logic;
           LED : out  STD_LOGIC_VECTOR(20 downto 0);
			  salida: out std_logic_vector(7 downto 0)
			 );
end score;

architecture Behavioral of score is
--signal puntos: integer range 0 to 100;
--signal kpuntos: integer range 0 to 100;
signal a,b,c,m0,m1,m2: integer range 0 to 15:=0;
begin
a<=m0;
b<=m1;
c<=m2;
salida <= conv_std_logic_vector(a,4) & conv_std_logic_vector(b,4);
--========================PUNTOS=====================
--====== CONTADOR de uno en uno
process(clock, reset,gol_left,gol_right,a,b,c,m1,m2,m0)
begin
	if reset='1' then
		m0<=0;
		m1<=0;
		m2<=0;
	elsif clock' event and clock='1' then
		if gol_left='1' then
			m0 <= a + 1;
			m1 <= m1;
		elsif gol_right='1' then
			m0<=m0;
			m1 <= b + 1;
		else
			m0<=m0;
			m1<=m1;
		end if;
		m2<=m2;
	end if;

end process;


--====================FIN PUNTOS======================
--	         S0
--#		   ---
--#	  S5	|	|s1
--#		    S6
--#		   ---
--#    S4	|	|S2
--#
--#		   ---
--#		   S3
--================== 7 SEGMENTOS =========================
process(a,b,c)
begin
	CASE a IS
		WHEN 0=>LED(6 downto 0)<="1111110";
		WHEN 1=>LED(6 downto 0)<="0110000";
		WHEN 2=>LED(6 downto 0)<="1101101";
		WHEN 3=>LED(6 downto 0)<="1111001";
		WHEN 4=>LED(6 downto 0)<="0110011";
		WHEN 5=>LED(6 downto 0)<="1011011";
		WHEN 6=>LED(6 downto 0)<="1011111";
		WHEN 7=>LED(6 downto 0)<="1110000";
		WHEN 8=>LED(6 downto 0)<="1111111";
		WHEN 9=>LED(6 downto 0)<="1111011";
		WHEN 10=>LED(6 downto 0) <="1110111";
		WHEN 11=>LED(6 downto 0) <="0011111";
		WHEN 12=>LED(6 downto 0) <="1001110";
		WHEN 13=>LED(6 downto 0) <="0111101";
		WHEN 14=>LED(6 downto 0) <="1001111";
		WHEN 15=>LED(6 downto 0) <="1000111";
		WHEN OTHERS=>LED(6 downto 0)<="0000000";
	END CASE;
	CASE b IS
		WHEN 0=>LED(13 downto 7)<="1111110";
		WHEN 1=>LED(13 downto 7)<="0110000";
		WHEN 2=>LED(13 downto 7)<="1101101";
		WHEN 3=>LED(13 downto 7)<="1111001";
		WHEN 4=>LED(13 downto 7)<="0110011";
		WHEN 5=>LED(13 downto 7)<="1011011";
		WHEN 6=>LED(13 downto 7)<="1011111";
		WHEN 7=>LED(13 downto 7)<="1110000";
		WHEN 8=>LED(13 downto 7)<="1111111";
		WHEN 9=>LED(13 downto 7)<="1111011";
		WHEN 10=>LED(13 downto 7) <="1110111";
		WHEN 11=>LED(13 downto 7) <="0011111";
		WHEN 12=>LED(13 downto 7) <="1001110";
		WHEN 13=>LED(13 downto 7) <="0111101";
		WHEN 14=>LED(13 downto 7) <="1001111";
		WHEN 15=>LED(13 downto 7) <="1000111";
		WHEN OTHERS=>LED(13 downto 7)<="0000000";
	END CASE;
	CASE c IS
		WHEN 0=>LED(20 downto 14)<="1111110";
		WHEN 1=>LED(20 downto 14)<="0110000";
		WHEN 2=>LED(20 downto 14)<="1101101";
		WHEN 3=>LED(20 downto 14)<="1111001";
		WHEN 4=>LED(20 downto 14)<="0110011";
		WHEN 5=>LED(20 downto 14)<="1011011";
		WHEN 6=>LED(20 downto 14)<="1011111";
		WHEN 7=>LED(20 downto 14)<="1110000";
		WHEN 8=>LED(20 downto 14)<="1111111";
		WHEN 9=>LED(20 downto 14)<="1111011";
		WHEN 10=>LED(20 downto 14) <="1110111";
		WHEN 11=>LED(20 downto 14) <="0011111";
		WHEN 12=>LED(20 downto 14) <="1001110";
		WHEN 13=>LED(20 downto 14) <="0111101";
		WHEN 14=>LED(20 downto 14) <="1001111";
		WHEN 15=>LED(20 downto 14) <="1000111";
		WHEN OTHERS=>LED(20 downto 14)<="0000000";
	END CASE;
end process;
--==================FIN 7 SEGMENTOS =========================
end Behavioral;

