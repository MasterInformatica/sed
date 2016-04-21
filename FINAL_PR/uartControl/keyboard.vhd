----------------------------------------------------------------------------------
-- Company: JJDA
-- Engineer: Jesús Javier Doménech Arellano - 47470902Y
-- 
-- Design Name: keyboard 
-- Module Name:  Keyboard 
-- Project Name: SNAKE
-- Target Devices: 
-- Description: Lectura y emision de tecla
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.tiposyconstantes.all;

entity Keyboard is
  port (
			clk_teclado : in std_logic;
        bit_teclado : in std_logic;
		  teclaLeida: in std_logic;
        tecla : out std_logic_vector(5 downto 0)
        );
end Keyboard;

architecture Behavioral of Keyboard is
  signal count : integer range 0 to 10 := 0;
  signal empieza : std_logic := '0';
  signal leer : std_logic_vector(7 downto 0) := (others => '0');
  signal termina : std_logic := '0';
  signal Ktecla : std_logic_vector(5 downto 0) := (others => '0');
 signal auxtecla : std_logic_vector(5 downto 0) := (others => '0');

begin

	tecla <= Ktecla;
	auxtecla<=Ktecla;
	leerTecla : process(clk_teclado)
	begin
		if falling_edge(clk_teclado) then
			if count = 0 and bit_teclado = '0' then --teclado empieza a mandar informacion
				empieza <= '0';
				count <= count + 1;
			elsif count > 0 and count < 9 then -- guardamos la informacion del teclado
				leer <= bit_teclado & leer(7 downto 1);
				count <= count + 1;
			elsif count = 9 then -- bit de paridad
				count <= count + 1;
			elsif count = 10 then -- el teclado termina de enviar
				empieza <= '1';
				count <= 0;
			end if;
		end if;
	end process leerTecla;
	procesarTecla : process(empieza, leer,auxtecla,termina,teclaLeida)
	begin
		if teclaLeida='1' then
			Ktecla<=(others=>'0');
		elsif empieza'event and empieza = '1' then
			if termina = '1' then
				--Ktecla <= auxtecla;
				termina <= '0';
			elsif termina = '0' then
			  if leer = "11110000" then 
					Ktecla <= auxtecla;
				 termina <= '1';
			  end if;
				if leer = keyboardARR then
					Ktecla(1) <= '1';
					Ktecla(0)<='0';
					Ktecla(5 downto 2) <=(others=>'0');
				elsif leer = keyboardDER then
					Ktecla(2) <= '1';
					Ktecla(1 downto 0)<=(others=>'0');
					Ktecla(5 downto 3) <=(others=>'0');
				elsif leer = keyboardABJ then
					Ktecla(3) <= '1';
					Ktecla(2 downto 0)<=(others=>'0');
					Ktecla(5 downto 4) <=(others=>'0');
				elsif leer = keyboardIZQ then
					Ktecla(4) <= '1';
					Ktecla(5)<='0';
					Ktecla(3 downto 0) <=(others=>'0');
				elsif leer = keyboardRESET then
					Ktecla(5) <= '1';
					--Ktecla(0)<='0';
					Ktecla(4 downto 0) <=(others=>'0');
				elsif leer = keyboardPAUSE then
					Ktecla(0) <= '1';
					--Ktecla(0)<='0';
					Ktecla(5 downto 1) <=(others=>'0');
--				elsif leer = keyboardCRECE then
--					Ktecla <= "001";
				else
					Ktecla <= auxtecla;
				end if;
		--	else 
				--Ktecla<=auxtecla;
			end if;
		end if;
	end process procesarTecla;
end Behavioral;