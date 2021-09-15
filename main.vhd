----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:59:47 10/02/2019 
-- Design Name: 
-- Module Name:    main - Behavioral 
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
use IEEE.std_logic_1164.all;
use IEEE.std_logic_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
  port (
    CLK  : in std_logic;
    BOT1 : in std_logic;
    LED1 : out std_logic);
end main;

architecture Behavioral of main is
  signal PCL : std_logic_vector(3 downto 0) := "0000"; --preskeller
begin

  process (CLK, BOT1)
  begin
    if (CLK ' event and CLK = '1') then
      if (PCL = "0100") then
        LED1 <= '0';
      else
        PCL <= PCL + 1;
      end if;
    end if;
    if (BOT1 ' event and BOT1 = '0') then
      LED1 <= '1';
      PCL  <= "0000";
    end if;
  end process;
end Behavioral;