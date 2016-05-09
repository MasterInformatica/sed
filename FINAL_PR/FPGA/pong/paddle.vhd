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
           posicion : out integer
			  );
end paddle;

architecture Behavioral of paddle is
signal pos : integer := paddle_vmid;
begin

posicion <= pos;

move_paddle: process(clk,Reset_n,baja,sube)
begin
	if (Reset_n = '1') then
		pos <= paddle_vmid;
	elsif clk'event and clk = '1' then
		if sube = '1' and pos > paddle_vmin then
			pos <= pos - pixelV;
		elsif baja = '1' and pos < paddle_vmax then
			pos <= pos + pixelV;
		else
			pos <= pos;
		end if;
	end if;
end process move_paddle;

end Behavioral;

