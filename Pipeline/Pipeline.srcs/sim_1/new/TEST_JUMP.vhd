library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TEST_JUMP is
end TEST_JUMP;

architecture Test of TEST_JUMP is
    component DECODE 
    
     port(
        reset,stall,clock: in std_logic;
        instruction,data_rs2,data_rs1: in std_logic_vector(31 downto 0);
        rs2_dir,rs1_dir,rd_dir: out std_logic_vector(4 downto 0);
        stall_prev,register_r: out std_logic;
        decoded_instruction: out std_logic_vector(90 downto 0) 
        
        --campos de la instruccion decodificada
        ---operando 1 				          (32 bit) --cuando solo hay un operando, lo metemos aqui
        ---operando 2				          (32 bit) --el inmediato va en el operando dos
        ---inmediato (offset)			      (12 bit) 
        ---dirección de registro de destino   (5 bit)
        ---SUBOPCODE 			              (3 bit)
        ---OPCODE 				              (7 bit)      
          
        );
    end component DECODE;
    component JUMP
        port(
            reset,stall,clk:in std_logic;
        instruction:in std_logic_vector(90 downto 0);
        instruction_z:out std_logic_vector(90 downto 0);
        current_pc:in std_logic_vector(31 downto 0);
        pc_actualizado:out std_logic_vector(31 downto 0);
        reset_prev,enable_parallel_cp:out std_logic );
        end component JUMP;
    
    signal reset,stall,clock,stall_prev,register_r,reset_prev,enable_parallel_cp: std_logic;
    signal instruction_z :std_logic_vector(90 downto 0);
    signal current_pc,pc_actualizado:std_logic_vector(31 downto 0);
    signal instruction,data_rs2,data_rs1: std_logic_vector(31 downto 0);
    signal rs2_dir,rs1_dir,rd_dir: std_logic_vector(4 downto 0);
    signal decoded_instruction: std_logic_vector(90 downto 0);
    
begin
    jumper:JUMP PORT map(reset,stall,clock,decoded_instruction,instruction_z,current_pc,pc_actualizado,reset_prev,enable_parallel_cp);
    decoder : DECODE port map(reset,stall,clock,instruction,data_rs2,data_rs1,rs2_dir,rs1_dir,rd_dir,stall_prev,register_r,decoded_instruction);
    
    reloj: process begin
    clock <= '1';wait for 5ns;
    clock <= '0'; wait for 5ns;
    end process;
    
    reset <= '1' after 0ns, '0' after 11 ns;
    stall <= '0' after 0ns;
    current_pc<=x"01111111" after 0ns;  
    data_rs2 <= x"00000000" after 0ns;
    data_rs1 <= x"00000000" after 0ns;

    
   instruction <= x"00000013" after 20ns,
                  x"fe010ee3" after 30ns,
                  x"fe011ee3" after 40ns,
                  x"fe015ee3" after 50ns,
                 x"fe014ee3" after 60ns,
                x"fe017ee3" after 70ns,
                  x"fe016ee3" after 80ns,
                  x"ffdff16f" after 90ns,
                  x"008102e7" after 100ns;
  end Test;