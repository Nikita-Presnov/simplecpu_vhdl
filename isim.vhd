--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:45:52 10/03/2019
-- Design Name:   
-- Module Name:   /media/nikita/D240342140340F2B/plis/Four_third/isim.vhd
-- Project Name:  Four_third
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: main
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
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY isim IS
END isim;
 
ARCHITECTURE behavior OF isim IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main
    PORT(
         CLK : in  std_logic;
         BOT1 : in  std_logic;
         LED1 : out  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal BOT1 : std_logic := '0';

 	--Outputs
   signal LED1 : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main PORT MAP (
          CLK => CLK,
          BOT1 => BOT1,
          LED1 => LED1
        );

   -- Clock process definitions
   CLK_process : process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
	BOT1_process :process
   begin
		BOT1 <= '1';
		wait for CLK_period*3;
		BOT1 <= '0';
		wait for CLK_period*2;
		BOT1 <= '1';
		wait for CLK_period*20;
		BOT1 <= '0';
		wait for CLK_period*10;
   end process;
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
