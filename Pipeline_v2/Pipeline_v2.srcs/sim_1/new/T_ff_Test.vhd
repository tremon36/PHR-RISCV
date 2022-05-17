----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2022 18:34:41
-- Design Name: 
-- Module Name: T_ff_Test - Behavioral
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


entity T_ff_Test is
end T_ff_Test;

architecture Behavioral of T_ff_Test is

component T_ff is
    port(t,clk, reset : in std_logic;
         q : out std_logic );
end component;

signal t, clk, q, reset : std_logic;

begin




B1 : T_ff port map (t, clk, reset ,q);

    process
    begin 
    clk <= '0'; wait for  5ns;
    clk <= '1'; wait for  5ns;
    end process;
    
    t <= '0' after 0 ns, '1' after 20 ns, '0' after 30 ns, '1' after 40 ns;
    reset <= '1' after 0 ns, '0' after 10 ns;

end Behavioral;