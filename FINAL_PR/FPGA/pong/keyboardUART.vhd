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
       UART_Rx : IN STD_LOGIC;
		 teclaLeida: in std_logic;
        tecla : out std_logic_vector(5 downto 0);
		 UART_Tx : OUT STD_LOGIC;
		RxErr : OUT STD_LOGIC
	  );
end keyboardUART;





architecture Behavioral of keyboardUART is

  
COMPONENT RS232 IS
  GENERIC (
		F 			: natural := 100000;
		min_baud	: natural := 115200;
		NDBits 	: natural := 8
  );
  PORT
  (
		clk	: in  STD_LOGIC;
		reset	: in  STD_LOGIC;
		Rx		: in  STD_LOGIC;
		Tx		: out STD_LOGIC;

		datoAEnviar	: in std_logic_vector(NDBits-1 downto 0);
		enviarDato	: in std_logic;
		TxBusy		: out std_logic;

		datoRecibido	: out std_logic_vector(NDBits-1 downto 0);
		RxErr				: out std_logic;		
		RxRdy				: out std_logic
  );
END COMPONENT RS232;
  


--------------
-- SENYALES --
--------------

   --- MicroBlaze
SIGNAL IO_Addr_Strobe  : STD_LOGIC;   
SIGNAL IO_Read_Strobe  : STD_LOGIC;
SIGNAL IO_Write_Strobe : STD_LOGIC;
SIGNAL IO_Address      : STD_LOGIC_VECTOR (31 downto 0);
SIGNAL IO_Write_Data   : STD_LOGIC_VECTOR (31 downto 0);
SIGNAL IO_Read_Data    : STD_LOGIC_VECTOR (31 downto 0);


   --- UART
SIGNAL UART_din   : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL UART_wr_en : STD_LOGIC;
SIGNAL TxBusy     : STD_LOGIC;
--SIGNAL UART_dout  : STD_LOGIC_VECTOR(7 DOWNTO 0);
--SIGNAL RxRdy      : STD_LOGIC;
--SIGNAL RxErr      : STD_LOGIC;

 signal empieza : std_logic := '0';
  signal leer : std_logic_vector(7 downto 0) := (others => '0');
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
				if leer(3 downto 0) = ukeyboardARR then
					Ktecla(1) <= '1';
					Ktecla(0)<='0';
					Ktecla(5 downto 2) <=(others=>'0');
				elsif leer(3 downto 0) = ukeyboardDER then
					Ktecla(2) <= '1';
					Ktecla(1 downto 0)<=(others=>'0');
					Ktecla(5 downto 3) <=(others=>'0');
				elsif leer(3 downto 0) = ukeyboardABJ then
					Ktecla(3) <= '1';
					Ktecla(2 downto 0)<=(others=>'0');
					Ktecla(5 downto 4) <=(others=>'0');
				elsif leer(3 downto 0) = ukeyboardIZQ then
					Ktecla(4) <= '1';
					Ktecla(5)<='0';
					Ktecla(3 downto 0) <=(others=>'0');
				elsif leer(3 downto 0) = ukeyboardRESET then
					Ktecla(5) <= '1';
					--Ktecla(0)<='0';
					Ktecla(4 downto 0) <=(others=>'0');
				elsif leer(3 downto 0) = ukeyboardPAUSE then
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


UART: RS232
  GENERIC MAP( F => 100000,
               min_baud => 19200,
					NDBits => 8
              )
  PORT MAP
  (
		clk   => clko,
		reset	=> Reset_n,
		Rx		=> UART_Rx,
		Tx		=> UART_Tx,

		datoAEnviar	=> UART_din,
		enviarDato	=> UART_wr_en,
		TxBusy		=> TxBusy,

		datoRecibido	=> leer,
		RxErr				=> RxErr,
		RxRdy				=> empieza
  );



end Behavioral;

