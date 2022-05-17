----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2022 17:39:36
-- Design Name: 
-- Module Name: ShiftRS_reg - Behavioral
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


entity ShiftRS_reg is
  Port (d : in std_logic_vector  (31 downto 0);
        clk : in std_logic;
        z : out std_logic_vector (31 downto 0) 
        );
        
end ShiftRS_reg;

architecture Behavioral of ShiftRS_reg is

begin
process (clk)
begin
    if (clk'event)then
        if(d(31) = '1') then z <= '1' & d(30 downto 0);
        else z <= d(30 downto 0)&'0';
        end if;
    end if;
end process;

end Behavioral;
