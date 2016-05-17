----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:12:44 04/19/2016 
-- Design Name: 
-- Module Name:    keyboardUART - Behavioral 
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
use work.tiposyconstantes.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keyboardUART is
	  PORT (
		 clko     : IN STD_LOGIC;
		 Reset_n   : IN STD_LOGIC;
		 teclaLeida: in std_logic;
       tecla : out std_logic_vector(5 downto 0);
		 leer : in std_logic_vector(7 downto 0);
		 empieza : in std_logic
	  );
end keyboardUART;





architecture Behavioral of keyboardUART is



-- signal empieza : std_logic := '0';
--  signal leer : std_logic_vector(7 downto 0) := (others => '0');
signal termina : std_logic := '0';
  signal Ktecla : std_logic_vector(5 downto 0) := (others => '0');
 signal auxtecla : std_logic_vector(5 downto 0) := (others => '0');

begin

	tecla <= Ktecla;
	auxtecla<=Ktecla;


procesarTecla : process(empieza, leer,auxtecla,termina,teclaLeida)
	begin
		if teclaLeida='1' then
			Ktecla<=(others=>'0');
		elsif clko'event and clko = '1' and empieza = '1' then
				if leer(2 downto 0) = ukeyboardAR1(2 downto 0) then
					Ktecla(1) <= '1';
					Ktecla(0)<='0';
					Ktecla(5 downto 2) <=(others=>'0');
				elsif leer(2 downto 0) = ukeyboardAB2(2 downto 0) then
					Ktecla(2) <= '1';
					Ktecla(1 downto 0)<=(others=>'0');
					Ktecla(5 downto 3) <=(others=>'0');
				elsif leer(2 downto 0) = ukeyboardAB1(2 downto 0) then
					Ktecla(3) <= '1';
					Ktecla(2 downto 0)<=(others=>'0');
					Ktecla(5 downto 4) <=(others=>'0');
				elsif leer(2 downto 0) = ukeyboardAR2(2 downto 0) then
					Ktecla(4) <= '1';
					Ktecla(5)<='0';
					Ktecla(3 downto 0) <=(others=>'0');
				elsif leer= ukeyboardRESET then
					Ktecla(5) <= '1';
					--Ktecla(0)<='0';
					Ktecla(4 downto 0) <=(others=>'0');
				elsif leer = ukeyboardPAUSE then
					Ktecla(0) <= '1';
					--Ktecla(0)<='0';
					Ktecla(5 downto 1) <=(others=>'0');
--				elsif leer = keyboardCRECE then
--					Ktecla <= "001";
				else
					Ktecla <= auxtecla;
				end if;
		else 
				Ktecla<=auxtecla;
		end if;
	end process procesarTecla;
end Behavioral;

