library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RS232 is
  generic
  (
		F 			: natural := 100000;
		min_baud	: natural := 115200;
		NDBits 	: natural := 8
  );
  port
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
end entity RS232;

architecture rtl of RS232 is

	component timing
	generic (
		F : natural := 60000;
		min_baud: natural := 115200
	);
	port (
			CLK : in std_logic;
			RST : in std_logic;
			ClrDiv : in std_logic;
			TopTx : out std_logic;
			TopRx : out std_logic
	);
	end component;
	
	component transmit
		generic (
			NDBits : natural := 8
		);
		port (
			CLK : in std_logic;
			RST : in std_logic;
			Tx : out std_logic;
			Din  : in std_logic_vector (NDBits-1 downto 0);
			TxBusy : out std_logic;
			TopTx : in std_logic;
			StartTx : in std_logic
		);
	end component;
	
	component receive
		generic (
			NDBits : natural := 8
		);
		port (
			CLK : in std_logic;
			RST : in std_logic;
			Rx : in std_logic;
			Dout : out std_logic_vector (NDBits-1 downto 0);
			RxErr : out std_logic;
			RxRdy : out std_logic;
			ClrDiv : out std_logic;
			TopRx : in std_logic
		);
	end component;
	
	signal toprx		: std_logic;
	signal toptx		: std_logic;
	signal Sig_ClrDiv	: std_logic;
	

begin

		timings_i: timing	generic map (F => F, min_baud => min_baud)
					port map (CLK	=> clk,
								 RST	=> reset,
								 ClrDiv	=> Sig_ClrDiv,
								 TopTx	=> toptx,
								 TopRx	=> toprx);
											 
		transmission_i: transmit generic map (NDBits	=> NDBits )
				   port map (CLK	=> clk,
							    RST	=> reset,	
							    Tx	=> Tx,
							    Din	=> datoAEnviar,
							    TxBusy	=> TxBusy,
							    TopTx	=> toptx,
							    StartTx	=> enviarDato);

		reception_i: receive	generic map (NDBits	=> NDBits)
					port map (CLK 	=> clk,
								 RST 	=> reset,
								 Rx	=> Rx,
								 Dout	=> datoRecibido,
								 RxErr	=> RxErr,
								 RxRdy	=> RxRdy,
								 ClrDiv	=> Sig_ClrDiv,
								 TopRx	=> toprx);	

end rtl;
