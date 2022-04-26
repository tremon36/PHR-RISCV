library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TEST_DECODE is
end TEST_DECODE;

architecture Test of TEST_DECODE is
    component DECODE 
    
     port(
        reset,stall,clock: in std_logic;
        instruction,data_rs2,data_rs1: in std_logic_vector(31 downto 0);
        rs2_dir,rs1_dir: out std_logic_vector(4 downto 0);
        stall_prev: out std_logic;
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
    
    signal reset,stall,clock,stall_prev: std_logic;
    signal instruction,data_rs2,data_rs1: std_logic_vector(31 downto 0);
    signal rs2_dir,rs1_dir: std_logic_vector(4 downto 0);
    signal decoded_instruction: std_logic_vector(90 downto 0);
    
begin

    decoder : DECODE port map(reset,stall,clock,instruction,data_rs2,data_rs1,rs2_dir,rs1_dir,stall_prev,decoded_instruction);
    
    reloj: process begin
    clock <= '1';wait for 5ns;
    clock <= '0'; wait for 5ns;
    end process;
    
    reset <= '1' after 0ns, '0' after 11 ns;
    stall <= '0' after 0ns;
    data_rs2 <= x"FFFFFFFF" after 0ns;
    data_rs1 <= x"AAAAAAAA" after 0ns;
    
    instruction <= "0000000" & "00111" & "10111" & "000" & "00001" & "0110011" after 0ns; --A DD CON R1 = 7 ; R2 = 23 ; RD = 1
                   

end Test;
