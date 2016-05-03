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
           posicion : out integer range 0 to vga_vpx_max
			  );
end pala;

architecture Behavioral of pala is
signal pos : integer range 0 to vga_vpx_max;
begin

posicion <= pos;

move_pala: process(clk,Reset_n,baja,sube)
begin
	if (Reset_n = '1') then
		pos <= paddle_vmid;
	elsif clk'event and clk = '0' then
		if sube = '1' then
			pos <= pos - pixelV;
		elsif baja = '1' then
			pos <= pos + pixelV;
		else
			pos <= pos;
		end if;
	end if;
end process move_pala;

end Behavioral;

