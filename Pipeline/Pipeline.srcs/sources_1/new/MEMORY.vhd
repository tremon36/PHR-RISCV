library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;

entity MEMORY is
    port(
        stall,reset,clk: in std_logic;
        memory_dir,memory_to_write: out std_logic_vector(31 downto 0);
        memory_data: in std_logic_vector(31 downto 0);
        rw,stall_prev: out std_logic;
        decoded_instruction: in std_logic_vector(90 downto 0);
        instruction_z: out std_logic_vector(90 downto 0);
        bytes:out std_logic_vector(1 downto 0));
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
            else if (stall='0') then 
            case OPCODE is 
            when"0000011" =>
            memory_dir<=decoded_instruction(58 downto 27);
                case SUBOPCODE is 
                    when "000" => instruction_z <= decoded_instruction(90 downto 59)& std_logic_vector(resize(signed(memory_data(31 downto 24)), 32))&decoded_instruction(26 downto 0);
                    when "001" =>instruction_z <= decoded_instruction(90 downto 59)& std_logic_vector(resize(signed(memory_data(31 downto 16)), 32))&decoded_instruction(26 downto 0);
                    when "010" =>instruction_z <= decoded_instruction(90 downto 59)& memory_data(31 downto 0)&decoded_instruction(26 downto 0);  
                    when "100" =>instruction_z <= decoded_instruction(90 downto 59)& x"000000"&memory_data(31 downto 24)&decoded_instruction(26 downto 0);  
                    when "101" =>instruction_z <= decoded_instruction(90 downto 59)& x"0000"&memory_data(31 downto 16)&decoded_instruction(26 downto 0);
                    when others => instruction_z <= decoded_instruction;  
                end case;
             when "0100011" =>
                instruction_z<= decoded_instruction;
                memory_dir<=decoded_instruction(58 downto 27);
                case SUBOPCODE is 
                    when "000" => memory_to_write<= x"000000"&decoded_instruction(67 downto 59);
                    bytes<="00";
                    when "001" =>memory_to_write<=x"0000"&decoded_instruction(74 downto 59);
                    bytes<="01";
                    when "010" =>memory_to_write<= decoded_instruction(90 downto 59);
                    bytes<="10";
                    when others => memory_to_write <=x"00000000";
                    end case;
              when others => instruction_z <= decoded_instruction;  
              end case;     
              else instruction_z<=decoded_instruction;
        end if;
       end if;
 end process;

end Behavioral;
