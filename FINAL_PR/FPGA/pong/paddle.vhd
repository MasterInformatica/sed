library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tiposyconstantes.all;

entity paddle is
    Port ( clk : in  STD_LOGIC;
           Reset_n : in  STD_LOGIC;
           baja : in  STD_LOGIC;
           sube : in  STD_LOGIC;
           posicion_arr : out integer;
			  posicion_abj : out integer
			  );
end paddle;

architecture Behavioral of paddle is
signal pos_arr : integer := paddle_vmin;
signal pos_abj : integer := paddle_vmin + (paddle_size * pixelV);
begin

posicion_arr <= pos_arr;
posicion_abj <= pos_abj;

move_paddle: process(clk,Reset_n,baja,sube)
begin
	if (Reset_n = '1') then
		pos_arr <= paddle_vmin;
		pos_abj <= paddle_vmin + (paddle_size * pixelV);
	elsif clk'event and clk = '1' then
		if sube = '1' and pos_arr > paddle_vmin then
			pos_arr <= pos_arr - pixelV;
			pos_abj <= pos_abj - pixelV;
		elsif baja = '1' and pos_abj < paddle_vmax then
			pos_arr <= pos_arr + pixelV;
			pos_abj <= pos_abj + pixelV;
		else
			pos_arr <= pos_arr;
			pos_abj <= pos_abj;
		end if;
	end if;
end process move_paddle;

end Behavioral;

