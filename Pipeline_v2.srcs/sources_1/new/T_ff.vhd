----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2022 18:25:46
-- Design Name: 
-- Module Name: T_ff - Behavioral
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


entity T_ff is
 Port (t, clk, reset : in std_logic;
       q : out std_logic
         );
end T_ff;

architecture Behavioral of T_ff is
signal q_aux : std_logic;

begin
 
 q <= q_aux;
 
 B1 : process  (clk)
    begin
        if (clk'event and clk = '1')then
             if reset = '1' then 
                q_aux <= '0' ;
             else
                q_aux <= t xor q_aux ;

             end if;
         end if;
    end process ;
    
end Behavioral;
