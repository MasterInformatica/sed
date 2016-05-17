library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tiposyconstantes.all;



entity bola is
	Port ( reset    : in    std_logic;
			 clock    : in    std_logic; 
		  	 paddle_left_up   : in   integer;
			 paddle_left_bt   : in   integer;
			 paddle_right_up  : in   integer;
			 paddle_right_bt  : in   integer;
			 ball_h_pos       : out   integer;
			 ball_v_pos       : out   integer;
			 gol_left 		   : out std_logic;
			 gol_right			: out std_logic
			 );
end bola;

architecture Behavioral of bola is


signal mvto_h : integer range -5 to 5 := 1;
signal mvto_v : integer range -5 to 5 := 3;
signal pos_h : integer := vga_hpx_medio;
signal pos_v : integer := vga_vpx_medio;

signal gl_aux : std_logic;
signal gr_aux : std_logic;
signal internal_reset: std_logic;

begin
gol_left <= gl_aux;
gol_right <= gr_aux;

ball_h_pos <= pos_h;
ball_v_pos <= pos_v;

internal_reset <= '1' when (gl_aux='1' or gr_aux='1')
							 else '0';
-- MOVIMIENTO
movimiento: process(clock, reset, mvto_h, mvto_v, pos_h, pos_v)
begin
	if(reset = '1' ) then
		 pos_h <= vga_hpx_medio;
		 pos_v <= vga_vpx_medio;
	else 
		if(clock'event and clock='1') then
			if(internal_reset = '0') then
				pos_h <= pos_h + mvto_h;
				pos_v <= pos_v + mvto_v;
			else
				pos_h <= vga_hpx_medio;
				pos_v <= vga_vpx_medio;
			end if;
		else
			pos_h <= pos_h;
			pos_v <= pos_v;
		end if;
	end if;
end process movimiento;

-- CHOQUES
choque: process(clock, reset, pos_v, pos_h, gr_aux, gl_aux, mvto_h, mvto_v)
begin
	if(reset = '1') then
		mvto_v <= -1;
		mvto_h <= 1;
		gl_aux <= '0';
		gr_aux <= '0';
	elsif (clock'event and clock='0') then
		--Paredes
		if(pos_v - 1 <= vga_vpx_min) then --superior
			mvto_v <= 0 - mvto_v;
		elsif(pos_v + 1 + ball_vpx >= vga_vpx_max) then
			mvto_v <= 0 - mvto_v;
		else
			mvto_v <= mvto_v;
		end if;
		

		-- Lateral con rebote
		if( (pos_h + ball_hpx) = (vga_hpx_max - hpx_gap - paddle_hpx) and -- dcha
			 (pos_v >= paddle_right_up - EPS) and (pos_v <= paddle_right_bt + EPS)) then  
			mvto_h <= 0 - mvto_h;
			
			if(pos_v <= paddle_right_up + pixelV) then --caso 1
				if(mvto_v >= 0) then
					mvto_v <= 4;
				else
					mvto_v <= -4;
				end if;
			elsif(pos_v <= (paddle_right_up + pixelV + pixelV)) then --caso 2
				if(mvto_v >= 0) then
					mvto_v <= 2;
				else
					mvto_v <= -2;
				end if;
			elsif(pos_v <= (paddle_right_up + pixelV + pixelV + pixelV)) then --caso 3
				mvto_v <= mvto_v;
			elsif(pos_v <= (paddle_right_up + pixelV + pixelV + pixelV + pixelV)) then --caso 4
				if(mvto_v >= 0) then
					mvto_v <= 2;
				else
					mvto_v <= -2;
				end if;
			else --if(pos_v <= (paddle_right_up + pixelV + pixelV + pixelV + pixelV + pixelV + EPS)) then --caso 5
				if(mvto_v >= 0) then
					mvto_v <= 4;
				else
					mvto_v <= -4;
				end if;
--			else --caso 6 (NUNCA)
--				mvto_v <= mvto_v;
			end if;
			
			gr_aux<='0';
			gl_aux<='0';
		elsif( (pos_h = (vga_hpx_min + paddle_hpx + hpx_gap)) and   --izq
			 (pos_v >= paddle_left_up - EPS) and (pos_v <= paddle_left_bt + EPS)) then
			 mvto_h <= 0 - mvto_h;



			if(pos_v <= paddle_right_up + pixelV - EPS) then --caso 1
				if(mvto_v >= 0) then
					mvto_v <= 4;
				else
					mvto_v <= -4;
				end if;
			elsif(pos_v <= (paddle_right_up + pixelV + pixelV)) then --caso 2
				if(mvto_v >= 0) then
					mvto_v <= 2;
				else
					mvto_v <= -2;
				end if;
			elsif(pos_v <= (paddle_right_up + pixelV + pixelV + pixelV)) then --caso 3
				mvto_v <= mvto_v;
			elsif(pos_v <= (paddle_right_up + pixelV + pixelV + pixelV + pixelV)) then --caso 4
				if(mvto_v >= 0) then
					mvto_v <= 2;
				else
					mvto_v <= -2;
				end if;
			else --if(pos_v <= (paddle_right_up + pixelV + pixelV + pixelV + pixelV + pixelV + EPS)) then --caso 5
				if(mvto_v >= 0) then
					mvto_v <= 4;
				else
					mvto_v <= -4;
				end if;
--			else --caso 6 (NUNCA)
--				mvto_v <= mvto_v;
			end if;
			
			
			gr_aux<='0';
			gl_aux<='0';
		elsif( pos_h > vga_hpx_max - hpx_gap) then   --- gol dcha
			mvto_h <= mvto_h;
			gr_aux<='1';
			gl_aux<='0';
		elsif(pos_h <= vga_hpx_min + hpx_gap) then   --- gol izq
			mvto_h <= mvto_h;
			gr_aux<='0';
			gl_aux<='1';
		else
			mvto_h <= mvto_h;
			gr_aux<='0';
			gl_aux<='0';
		end if;
	else
		mvto_v <= mvto_v;
		mvto_h <= mvto_h;
		gr_aux<=gr_aux;
		gl_aux<=gl_aux;
	end if;
end process choque;
end Behavioral;

