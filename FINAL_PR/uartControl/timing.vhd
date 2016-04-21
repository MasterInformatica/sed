-- --------------------------
-- TIMING
-- --------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- ----------------------------------------------------
Entity timing is
-- ----------------------------------------------------
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
end timing;

-- ----------------------------------------------------
Architecture timing of timing is
-- ----------------------------------------------------
	constant max_div : natural := ((F*1000)/(min_baud));
	subtype div_type is natural range 0 to max_div-1;
	signal Div	: div_type;
	signal ClkDiv	: integer;
	signal RxDiv	: integer;
	signal divisor : std_logic_vector(7 downto 0);
begin

    divisor <= conv_std_logic_vector(max_div-1, 8);
	 
-- --------------------------
-- Clk Clock Generation
-- --------------------------
      process (RST, CLK)
         begin
            if RST='1' then
               Div <= 0;
            elsif rising_edge(CLK) then
               if Div = conv_integer(divisor) then
               	 Div <= 0;
               else
                  Div <= Div + 1;
               end if;
            end if;
      end process;
      
-- --------------------------
-- Tx Clock Generation
-- --------------------------
      process (RST, CLK)
         begin
            if RST='1' then
               TopTx <= '0';
               ClkDiv <= 0; --(others=>'0');
            elsif rising_edge(CLK) then
               TopTx <= '0';
               ClkDiv <= ClkDiv + 1;
               if ClkDiv = max_div-1 then
						TopTx <= '1';
                  ClkDiv <= 0;
               end if;
            end if;
      end process;
      
-- ------------------------------
-- Rx Sampling Clock Generation
-- ------------------------------
      process (RST, CLK)
        begin
            if RST='1' then
               TopRx <= '0';
               RxDiv <= 0;
            elsif rising_edge(CLK) then
               TopRx <= '0';
               if ClrDiv='1' then
                  RxDiv <= 0;
               else
						if RxDiv = ((max_div-1)/2) then
                     RxDiv <= 0;
                     TopRx <= '1';
                  else
                    RxDiv <= RxDiv + 1;
                  end if;
               end if;
            end if;
      end process;
end architecture;
