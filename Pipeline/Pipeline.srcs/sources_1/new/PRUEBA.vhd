library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_signed.all;
--use IEEE.std_logic_unsigned.all;


entity PRUEBA is
  Port (num1,num2:in std_logic_vector(7 downto 0);
        result: out std_logic_vector(7 downto 0);
        g,e,l: out std_logic );
end PRUEBA;

architecture Behavioral of PRUEBA is

begin 

result <= num1 + num2;
g <= '1' when num1 > num2 else '0';
e <= '1' when num1 = num2 else '0';
l <= '1' when num1 < num2 else '0';


end Behavioral;
