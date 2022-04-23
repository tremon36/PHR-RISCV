library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TEST_CP is
end TEST_CP;

architecture Test of TEST_CP is

component CP 
 port(
        count,reset,enable_parallel_load,clock:in std_logic;
        current_num:out std_logic_vector(31 downto 0);
        load: in std_logic_vector(31 downto 0)
        );
end component CP;
signal count,reset,enable_parallel_load,clock:std_logic;
signal current_num,load:std_logic_vector(31 downto 0);
begin
    contador:CP port map(
                count,reset,enable_parallel_load,clock,
                current_num,
                load
                );
    reloj:process
            begin
                clock<='1'; wait for 5 ns;
                clock<='0';wait for 5 ns;
              end process;
              
    reset <= '1' after 0 ns,'0' after 11 ns;
    count <= '1' after 0 ns,'0' after 500 ns;
    enable_parallel_load <= '0' after 0 ns, '1' after 300 ns, '0' after 309 ns ;
    load <= x"00000001" after 20 ns, x"06aef411" after 295 ns, x"000000000" after 309 ns;
end Test;
