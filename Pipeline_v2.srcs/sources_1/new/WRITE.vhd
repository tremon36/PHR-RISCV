

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity WRITE is
 Port ( decode_instruction : in std_logic_vector (90 downto 0);
        reset : in std_logic;
        clk : in std_logic;
        stall_in : in std_logic;
        data_out : out std_logic_vector (31 downto 0);
        dir_out : out std_logic_vector (4 downto 0);
        write_enable : out std_logic
  );
end WRITE;

architecture Behavioral of WRITE is

signal register_dir : std_logic_vector (4 downto 0);
signal data_in : std_logic_vector (31 downto 0);
 

begin
    
    process (clk)
    begin  
        if (clk'event and clk = '1')then
            if (reset = '1')then write_enable <= '0';
            end if;
            if (stall_in = '0')then
            
--              If its an instruction that needs to write in the register, then acces to the if bellow.               
                if (decode_instruction(6 downto 0) /= "0010111" or decode_instruction(6 downto 0) /= "0100011")then
                    data_out <= decode_instruction (90 downto 59);
                    dir_out <= decode_instruction (26 downto 22);
                    write_enable <= '1';
                    
                else write_enable <= '0';
                end if;
            end if;     
        end if;
    end process;

end Behavioral;
