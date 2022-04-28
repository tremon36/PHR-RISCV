----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2022 18:11:36
-- Design Name: 
-- Module Name: TEST_PRUEBA - TEST
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



entity TEST_PRUEBA is
end TEST_PRUEBA;

architecture TEST of TEST_PRUEBA is
component PRUEBA port( num1,num2:in std_logic_vector(7 downto 0);
        result: out std_logic_vector(7 downto 0);
        g,e,l: out std_logic );
end component;
signal num1,num2,result:std_logic_vector(7 downto 0);
signal g,e,l:std_logic;            
begin
prueba1:PRUEBA port map(num1,num2,result,g,e,l);
num1<="00000001"after 0 ns;
num2<="11000011"after 0ns;

end TEST;
