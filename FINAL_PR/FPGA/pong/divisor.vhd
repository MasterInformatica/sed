----------------------------------------------------------------------------------
-- Company: Universidad Complutense de Madrid
-- Engineer: Hortensia Mecha
-- 
-- Design Name: divisor 
-- Module Name:    divisor - divisor_arch 
-- Project Name: 
-- Target Devices: 
-- Description: Creación de un reloj de 1Hz a partir de
--		un clk de 100 MHz
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;

entity divisor is
    port (
			carga: in std_logic_vector(24 downto 0);
        reset: in STD_LOGIC;
        clk: in STD_LOGIC; -- reloj de entrada de la entity superior
        reloj: out STD_LOGIC -- reloj que se utiliza en los process del programa principal
    );
end divisor;

architecture divisor_arch of divisor is
 SIGNAL cuenta: std_logic_vector(24 downto 0);
 SIGNAL clk_aux: std_logic;
  begin
	reloj<=clk_aux;
 contador:  PROCESS(reset, clk)
  BEGIN
    IF (reset='1') THEN
      cuenta<= (OTHERS=>'0');
    ELSIF(clk'EVENT AND clk='1') THEN
      IF (cuenta=carga) THEN 
      	clk_aux <= not clk_aux;
        cuenta<= (OTHERS=>'0');
      ELSE
        cuenta <= cuenta+'1';
      END IF;
    END IF;
  END PROCESS contador;

end divisor_arch;

