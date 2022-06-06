library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FETCH is

port(
    stall,reset,clock:in std_logic;
    current_pc,instruction:in std_logic_vector(31 downto 0);
    current_inst,memory_dir_request,cp_inst: out std_logic_vector (31 downto 0);
    r_w: out std_logic;
    amount:out std_logic_vector(1 downto 0);
    rs1_dir,rs2_dir,rd_dir: out std_logic_vector(4 downto 0);
    will_write_flag_decode: out std_logic
    );

end FETCH;

architecture Behavioral of FETCH is

component RegistroF
        port(
        reset,stall,clk: in std_logic;
        load: in std_logic_vector(31 downto 0);
        z: out std_logic_vector(31 downto 0)
        );        
end component RegistroF;

begin
F:RegistroF port map(
                     reset,stall,clock,instruction,current_inst
                     );
X:RegistroF port map(
                     reset,stall,clock,current_pc,cp_inst
                     );
r_w <= '0';
amount<="10";
                                         
process (clock)
    begin
        if(clock = '1' and clock'event)then 
            if stall = '0' then 
            rd_dir <= instruction(11 downto 7);
            rs1_dir <= instruction(19 downto 15);
            rs2_dir <= instruction(24 downto 20); 
            --escribir el flag en los registros si se va a escribir (Riesgo RAW). Solo operaciones con registro de destino
            if (instruction(6 downto 0) /= "1100011" and instruction(6 downto 0) /= "0100011" and instruction(6 downto 0) /= "0000000") then
                   will_write_flag_decode <= '1';
            else will_write_flag_decode <= '0';
            end if;
            memory_dir_request <= current_pc;
            end if; 
           end if;
end process;


end Behavioral;
