

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Test_counter is
end Test_counter;

architecture Behavioral of Test_counter is
 component Counter is
    port (reset, clk : in std_logic;
        z : out std_logic_vector (4 downto 0)    
        );
 end component;
 
 signal reset, clk : std_logic;
 signal z : std_logic_vector (4 downto 0);
 
begin

C0 : Counter port map (reset, clk, z);

process 
begin 
    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
end process;

reset <= '1' after 0ns, '0' after 10ns, '1' after 40 ns, '0' after 50ns;

end Behavioral;
