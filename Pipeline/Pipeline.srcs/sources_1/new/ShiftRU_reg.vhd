----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2022 17:36:24
-- Design Name: 
-- Module Name: ShiftRU_reg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.numeric_std.all;



entity ShiftRU_reg is
  Port ( d : in std_logic_vector  (31 downto 0);
        clk : in std_logic;
        z : out std_logic_vector (31 downto 0));
end ShiftRU_reg;

architecture Behavioral of ShiftRU_reg is

begin

process (clk)
begin 
 if(clk'event) then z <= d(30 downto 0)&'0';
 end if;
end process;

end Behavioral;
