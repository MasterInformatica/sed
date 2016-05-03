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
--           size : in  STD_LOGIC_VECTOR(18 downto 0);
           comido : in  STD_LOGIC;
--           pausa : in  STD_LOGIC;
           LED : out  STD_LOGIC_VECTOR(20 downto 0)
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

--========================PUNTOS=====================
--====== CONTADOR de uno en uno
process(clock, reset,comido)
begin
	if reset='1' then
		m0<=0;
		m1<=0;
		m2<=0;
	elsif clock' event and clock='1' then
		
		if comido='1' then
		if m0 /= 9 then
				m0<= a + 1; 
				m1<=b;
				m2<=c;
			elsif m1 /= 9 then
				m0<=0;
				m1<= b + 1;
				m2<=c;
			elsif m2 /= 9 then
				m1<=0;
				m0<=0;
				m2<= c + 1;
			else
				m1<=0;
				m0<=0;
				m2<=0;
		end if;
		else
			m0<=a;
			m1<=b;
			m2<=c;
		end if;
	end if;

end process;


--process(clock, reset,size,comido,pausa,puntos)
--begin
--	if reset='1' then
--		kpuntos<=0;
--	elsif clock'event and clock='1' then
--		if pausa='1' then
--			kpuntos<=puntos;
--		elsif comido='1' then
--			kpuntos<=puntos +10;
--		elsif size(15)='1' then
--			kpuntos<=puntos+4;
--		elsif size(11)='1' then
--			kpuntos<=puntos+3;
--		elsif size(7)='1' then
--			kpuntos<=puntos+2;
--		elsif size(3)='1' then
--			kpuntos<=puntos+1;
--		else
--			kpuntos<=puntos;
--		end if;
--	end if;
--end process;
--====================FIN PUNTOS======================
--	   S0
--#		   ---
--#	    S5	|	|s1
--#		    S6
--#		   ---
--#	    S4	|	|S2
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
		WHEN OTHERS=>LED(6 downto 0)<="1111111";
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
		WHEN OTHERS=>LED(13 downto 7)<="1111111";
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
		WHEN OTHERS=>LED(20 downto 14)<="1111111";
	END CASE;
end process;
--==================FIN 7 SEGMENTOS =========================
end Behavioral;

