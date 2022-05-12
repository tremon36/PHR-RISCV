library IEEE;
use IEEE.STD_LOGIC_1164.ALL;




entity TEST_MEMORY is
end TEST_MEMORY;

architecture Behavioral of TEST_MEMORY is
component MEMORY   
     port(
        stall,reset,clk: in std_logic;
        memory_dir,memory_to_write: out std_logic_vector(31 downto 0);
        memory_data: in std_logic_vector(31 downto 0);
        rw,stall_prev: out std_logic;
        decoded_instruction: in std_logic_vector(90 downto 0);
        instruction_z: out std_logic_vector(90 downto 0);
        bytes:out std_logic_vector(1 downto 0));
end component MEMORY;

begin

end Behavioral;
