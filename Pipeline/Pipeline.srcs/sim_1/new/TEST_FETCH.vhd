
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;




entity TEST_FETCH is
end TEST_FETCH;

architecture Test of TEST_FETCH is

component FETCH
    
port(
    stall,reset,clock:in std_logic;
    current_pc,instruction:in std_logic_vector(31 downto 0);
    current_inst,memory_dir_request,cp_inst: out std_logic_vector (31 downto 0);
    r_w: out std_logic;
    amount:out std_logic_vector(1 downto 0)
    );
end component FETCH;

signal  stall,reset,clock,r_w:std_logic;
signal instruction, current_inst,memory_dir_request,cp_inst: std_logic_vector(31 downto 0);
signal amount: std_logic_vector (1 downto 0);

component CP is
 port(
        count,reset,enable_parallel_load,clock:in std_logic;
        current_num:out std_logic_vector(31 downto 0);
        load: in std_logic_vector(31 downto 0)
        );
        end component CP;
signal enable_parallel_load:std_logic;
signal current_num,load:std_logic_vector(31 downto 0);

begin

F:FETCH port map(
                 stall,reset,clock,current_num,instruction,current_inst,memory_dir_request,cp_inst,r_w,amount
                 );
PC:CP port map (
                not stall,reset,enable_parallel_load,clock,current_num,load
                );
reloj:process
    begin
        clock<='1';wait for 5 ns;
        clock <= '0'; wait for 5 ns;
        end process;

instruction <= x"afed4578" after 0 ns, x"afed4458" after 50 ns, x"afed4573" after 100 ns, x"afed4572" after 150 ns, x"afed4518" after 200 ns; 
reset <=  '1' after 0 ns, '0' after 15 ns;
stall <='0' after 0 ns , '1' after 120 ns,'0' after 180 ns;
enable_parallel_load<= '0' after 0 ns;
load<= x"00000000" after 0 ns;
        

end Test;
