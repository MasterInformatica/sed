--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:42:08 12/06/2012
-- Design Name:   
-- Module Name:   G:/TOC/snake/simuSNKmodule.vhd
-- Project Name:  snake
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: snake
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tiposyconstantes.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY simuSNKmodule IS
END simuSNKmodule;
 
ARCHITECTURE behavior OF simuSNKmodule IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT snake
    PORT(
         reset: in std_logic;
				clk_game : in  STD_LOGIC;
				pause: in std_logic;
				new_head_hpos:IN integer range 0 to 120;
				new_head_vpos:IN integer range 0 to 200;
				crece : in  STD_LOGIC;
				vcuerpo: out vectorV;
				hcuerpo: out vectorH;
				head_hpos: out integer range 0 to 120;
				head_vpos: out integer range 0 to 200;
				sizeSNK :out integer range 1 to 10
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal clk_game : std_logic := '0';
   signal pause : std_logic := '0';
   signal new_head_hpos : integer range 0 to 120 := 0;
   signal new_head_vpos : integer range 0 to 200 := 0;
   signal crece : std_logic := '0';

 	--Outputs
		signal		vcuerpo:  vectorV;
		signal		hcuerpo:  vectorH;
	signal			head_hpos:  integer range 0 to 120;
	signal			head_vpos:  integer range 0 to 200;
	signal			sizeSNK : integer range 1 to 10;

   -- Clock period definitions
   constant clk_game_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: snake PORT MAP (
          reset => reset,
          clk_game => clk_game,
          pause => pause,
          new_head_hpos => new_head_hpos,
          new_head_vpos => new_head_vpos,
          crece => crece,
          vcuerpo => vcuerpo,
          hcuerpo => hcuerpo,
          head_hpos => head_hpos,
          head_vpos => head_vpos,
          sizeSNK => sizeSNK
        );

   -- Clock process definitions
   clk_game_process :process
   begin
		clk_game <= '0';
		wait for clk_game_period/2;
		clk_game <= '1';
		wait for clk_game_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		reset<='1';
		pause<='0';
		crece<='0';
		new_head_vpos <= 20;
		new_head_hpos <= 20;
      -- hold reset state for 100 ns.
      wait for 100 ns;	
pause<='0';		
		reset<='0';
		crece<='0';
		new_head_vpos <= 30;
		new_head_hpos <= 20;
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		pause<='0';
				reset<='0';
		crece<='0';
		new_head_vpos <= 30;
		new_head_hpos <= 30;
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		pause<='0';
			reset<='0';
		crece<='1';
		new_head_vpos <= 50;
		new_head_hpos <= 20;
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		pause<='0';
				reset<='0';
		crece<='0';
		new_head_vpos <= 60;
		new_head_hpos <= 60;
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		pause<='0';
				reset<='0';
		crece<='0';
		new_head_vpos <= 100;
		new_head_hpos <= 90;
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		pause<='0';
				reset<='0';
		crece<='1';
		new_head_vpos <= 100;
		new_head_hpos <= 120;
      -- hold reset state for 100 ns.
      wait for 100 ns;	
			pause<='0';
				reset<='0';
		crece<='0';
		new_head_vpos <= 100;
		new_head_hpos <= 120;
      wait for clk_game_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
