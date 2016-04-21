library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.numeric_std.all;



entity clockmodule is
  port(clock  : in std_logic;
       rgb    : out std_logic_vector(8 downto 0);
       hsyncb    : out std_logic;
       vsyncb    : out std_logic);
end clockmodule;
 
architecture Behavioral of clockmodule is
 
signal clk25              : std_logic;
signal horizontal_counter : std_logic_vector (9 downto 0);
signal vertical_counter   : std_logic_vector (9 downto 0);
 
component divisor is
    port (
			carga: in std_logic_vector(24 downto 0);
        reset: in STD_LOGIC;
        clk: in STD_LOGIC; -- reloj de entrada de la entity superior
        reloj: out STD_LOGIC -- reloj que se utiliza en los process del programa principal
    );
end component;
begin
 
 
Nreloj_vga: divisor port map( conv_std_logic_vector(integer(3),25),'0',clock,clk25);


process (clk25)
begin
  if clk25'event and clk25 = '1' then
    if (horizontal_counter >= "0010010000" ) -- 144
    and (horizontal_counter < "1100010000" ) -- 784
    and (vertical_counter >= "0000100111" ) -- 39
    and (vertical_counter < "1000000111" ) -- 519
    then
 
     --here you paint!!
      rgb<="111000000";
 
    else
      rgb<="000000111";
    end if;
    if (horizontal_counter > "0000000000" )
      and (horizontal_counter < "0001100001" ) -- 96+1
    then
      hsyncb <= '0';
    else
      hsyncb <= '1';
    end if;
    if (vertical_counter > "0000000000" )
      and (vertical_counter < "0000000011" ) -- 2+1
    then
      vsyncb <= '0';
    else
      vsyncb <= '1';
    end if;
    horizontal_counter <= horizontal_counter+"0000000001";
    if (horizontal_counter="1100100000") then
      vertical_counter <= vertical_counter+"0000000001";
      horizontal_counter <= "0000000000";
    end if;
    if (vertical_counter="1000001001") then
      vertical_counter <= "0000000000";
    end if;
  end if;
end process;
 
end Behavioral;
