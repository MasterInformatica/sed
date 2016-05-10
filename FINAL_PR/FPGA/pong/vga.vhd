library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.numeric_std.all;
use work.tiposyconstantes.all;


entity vgacore is
	port (
		-- Generales del comopnente
		reset    : in    std_logic;	          -- reset
		clock    : in    std_logic;             -- clock
		
		-- Propios del modulo de pong
		paddle_left_up   : in   integer;-- range vga_vpx_min  to vga_vpx_max;   
	   paddle_left_bt  : in   integer;-- range vga_vpx_min  to vga_vpx_max;
		
		paddle_right_up   : in   integer;-- range vga_vpx_min  to vga_vpx_max;   
	   paddle_right_bt  : in   integer;-- range vga_vpx_min  to vga_vpx_max;
		
		ball_h_pos        : in   integer;-- range vga_hpx_min  to vga_hpx_max;
		ball_v_pos        : in   integer;-- range vga_vpx_min  to vga_vpx_max;
		
		-- Propios el vga
		hsyncb   : inout std_logic;	                     -- horizontal (line) sync
		vsyncb   : out   std_logic;	                     -- vertical (frame) sync
		rgb      : out   std_logic_vector(8 downto 0)      -- B G R colors
	);
end vgacore;





architecture vgacore_arch of vgacore is

-------------------
--- COMPONENTES ---
-------------------
component divisor2 is
	port(
		carga: in std_logic_vector(24 downto 0);--typa=1 => reloj pantalla; typa=0 =>reloj movimiento
		reset,clk: in std_logic;
		reloj: out std_logic
	);
end component;

----------------
--- SENYALES ---
----------------
signal reloj: std_logic;

signal hcnt: std_logic_vector(8 downto 0);	  -- horizontal pixel counter
signal vcnt: std_logic_vector(9 downto 0);	  -- vertical line counter

-- carta de ajuste
signal pintar_ajuste : std_logic;
signal rgb_ajuste    : std_logic_vector(8 downto 0);

-- elementos de la escena
signal pintar_pared   : std_logic;
signal pintar_paddle  : std_logic;


-- Constantes
constant tam_pala_arriba : integer := (((paddle_size - 1) / 2) * pixelV );
constant tam_pala_abajo  : integer := (((paddle_size + 1) / 2) * pixelV );

constant linea_central   : integer := vga_global_hpx_min +
										((vga_global_hpx_max - vga_global_hpx_min) / 2);
begin
----------------
--- PORT MAP ---
----------------
Nreloj_vga: divisor2 port map( conv_std_logic_vector(integer(3),25),reset,clock,reloj);
-----------------------------------------------------------------------------------------------
	
A: process(reloj,reset)
begin
	-- reset asynchronously clears pixel counter
	if reset='1' then
		hcnt <= "000000000";
	-- horiz. pixel counter increments on rising edge of dot clock
	elsif (reloj'event and reloj='1') then
		-- horiz. pixel counter rolls-over after 381 pixels
		if hcnt<380 then
			hcnt <= hcnt + 1;
		else
			hcnt <= "000000000";
		end if;
	end if;
end process;

B: process(hsyncb,reset)
begin
	-- reset asynchronously clears line counter
	if reset='1' then
		vcnt <= "0000000000";
	-- vert. line counter increments after every horiz. line
	elsif (hsyncb'event and hsyncb='1') then
		-- vert. line counter rolls-over after 528 lines
		if vcnt<527 then
			vcnt <= vcnt + 1;
		else
			vcnt <= "0000000000";
		end if;
	end if;
end process;

C: process(reloj,reset)
begin
	-- reset asynchronously sets horizontal sync to inactive
	if reset='1' then
		hsyncb <= '1';
	-- horizontal sync is recomputed on the rising edge of every dot clock
	elsif (reloj'event and reloj='1') then
		-- horiz. sync is low in this interval to signal start of a new line
		if (hcnt>=291 and hcnt<337) then
			hsyncb <= '0';
		else
			hsyncb <= '1';
		end if;
	end if;
end process;

D: process(hsyncb,reset)
begin
	-- reset asynchronously sets vertical sync to inactive
	if reset='1' then
		vsyncb <= '1';
		-- vertical sync is recomputed at the end of every line of pixels
		elsif (hsyncb'event and hsyncb='1') then
		-- vert. sync is low in this interval to signal start of a new frame
		if (vcnt>=490 and vcnt<492) then
			vsyncb <= '0';
		else
			vsyncb <= '1';
		end if;
	end if;
end process;



--------------------------------------------------------------------------------------
-- Carta de ajustes en la parte superior de la pantalla para comprobar que todo ok
carta_ajuste: process(hcnt, vcnt)
begin
	pintar_ajuste <= '0';
	rgb_ajuste <= (others=>'0');

	if vcnt > vga_global_hpx_min and vcnt < vga_vpx_min then
		pintar_ajuste <= '1';
		if hcnt > 0 and hcnt < 35 then
			rgb_ajuste <= "111000000";
		elsif hcnt > 0 and hcnt < 70 then
			rgb_ajuste <= "000111000";
		elsif hcnt > 0 and hcnt < 105 then
			rgb_ajuste <= "000000111";
		elsif hcnt > 0 and hcnt < 140 then
			rgb_ajuste <= "111000000";
		elsif hcnt > 0 and hcnt < 175 then
			rgb_ajuste <= "111111000";
		elsif hcnt > 0 and hcnt < 210 then
			rgb_ajuste <= "111000111";			
		elsif hcnt > 0 and hcnt < 245 then
			rgb_ajuste <= "000111111";
		elsif hcnt > 0 and hcnt < 280 then
			rgb_ajuste <= "111111111";		
		end if;
	end if;
		
end process;

--------------------------------------------------------------------------------------
bordes_escena: process (hcnt, vcnt)
begin
	pintar_pared <= '0';	
	
	if hcnt > vga_global_hpx_min and hcnt < vga_global_hpx_max then
		if vcnt >= vga_vpx_min and 
			vcnt <= (vga_vpx_min + tam_pared) then --pared superior
			pintar_pared<='1';
		elsif vcnt >= (vga_global_vpx_max - tam_pared) and --pared inferior
				vcnt <= (vga_global_vpx_max) then 
			pintar_pared<='1';
		end if;
	end if;
	if hcnt = linea_central then --linea central
		if vcnt > 0 and vcnt(4 downto 2)="111" and vcnt <=vga_global_vpx_max then
			pintar_pared<='1';
		end if;
	end if;
end process bordes_escena;
---------------------------------------------------------------------------
paddle_lr: process (hcnt, vcnt)
begin
	pintar_paddle <= '0';	
	
	-- LEFT
	if hcnt > hpx_gap and hcnt < (hpx_gap + paddle_hpx) then
		if vcnt >= paddle_left_up and 
			vcnt <= paddle_left_bt then
			pintar_paddle <= '1';
		end if;
	end if;

	-- RIGHT
	if hcnt > (vga_hpx_max - hpx_gap - paddle_hpx ) and hcnt < (vga_hpx_max - hpx_gap) then
		if vcnt >= paddle_right_up and 
			vcnt <= paddle_right_bt then
			pintar_paddle <= '1';
		end if;
	end if;

end process paddle_lr;
---------------------------------------------------------------------------
colorear: process(hcnt,vcnt,pintar_ajuste, rgb_ajuste, pintar_pared, pintar_paddle)
begin
	if pintar_ajuste = '1' then       --- Carta de ajuste
		rgb <= rgb_ajuste;
	elsif  pintar_paddle = '1' then     --- Paddle
		rgb <= color_paddle;
	elsif pintar_pared = '1' then     --- Paredes y linea central
		rgb <= color_pared;
	
	else                              --- Resto
		rgb <= "000000000";   
	end if;
end process colorear;
---------------------------------------------------------------------------
end vgacore_arch;