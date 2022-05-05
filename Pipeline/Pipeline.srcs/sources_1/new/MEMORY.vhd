library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MEMORY is
    port(
        stall,reset,clk: in std_logic;
        memory_dir,memory_to_write: out std_logic_vector(31 downto 0);
        memory_data: in std_logic_vector(31 downto 0);
        rw,stall_prev: out std_logic;
        decoded_instruction: in std_logic_vector(90 downto 0);
        instruction_z: out std_logic_vector(90 downto 0));
        
end MEMORY;

architecture Behavioral of MEMORY is

 signal OPCODE: std_logic_vector(6 downto 0);
 signal SUBOPCODE:std_logic_vector(2 downto 0);
 
begin

OPCODE <= decoded_instruction(6 downto 0);
SUBOPCODE <= decoded_instruction(9 downto 7);

process(clk,reset) 
    begin 
        if(clk = '1' and clk'event) then 
            if(reset = '1') then 
                instruction_z <= x"0000000000000000000000" & "000";
            else 
            --case OPCODE is 
           -- when 
        end if;
       end if;
 end process;

end Behavioral;
