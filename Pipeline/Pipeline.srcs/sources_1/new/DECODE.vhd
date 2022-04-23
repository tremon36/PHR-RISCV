library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity DECODE is
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
end DECODE;

architecture Behavioral of DECODE is

component Registro_Intermedio_Decodificado 
        port(
        reset,stall,clk: in std_logic;
        load: in std_logic_vector(90 downto 0);
        z: out std_logic_vector(90 downto 0)
        );
 end component Registro_Intermedio_Decodificado;
 
signal resultado: std_logic_vector (90 downto 0);
signal OPCODE: std_logic_vector(6 downto 0);

begin

registro_salida: Registro_Intermedio_Decodificado port map(reset,stall,clock,resultado,decoded_instruction);

OPCODE <= instruction (6 downto 0);

process(clock) begin
    if(clock = '1' and clock'event) then
        if reset = '1' then
            resultado <=  x"0000000000000000000000" & "000";
         else
         
         if stall = '0' then
            case OPCODE is 
                when "0110111" or "0010111" or "1101111"=>  --auipc,lui,jal 
                    resultado <= X"0000" & instruction(31 downto 12) & X"00000000" & X"000" & instruction(11 downto 7) &"000" & instruction(6 downto 0);
                              --   Uns        OPERANDO 1                OPERANDO 2     OFF             RD                SUB      OPCODE
                when "1100111" => --jalr 
                    rs1_dir <= instruction(19 downto 15);
                    resultado <= data_rs1 & X"00000000" & instruction(31 downto 20) & instruction(11 downto 7) & "000" & instruction(6 downto 0);
                              --   OP1          OP2           OFFSET                        RD                    SUB           OPCODE
                when "1100011" => -- Todos los del tipo B (BRANCH)
                    rs1_dir <= instruction(19 downto 15);
                    rs2_dir <= instruction(24 downto 20);
                    resultado <= data_rs1 & data_rs2 & instruction(31 downto 25) & instruction (11 downto 6) & "0" & "00000" & instruction(14 downto 12) & instruction(6 downto 0);
                               --   OP1       OP2      -- Las dos partes del offset, y truncar para multiplo 2 --     RD = 0         SUBOPCODE                       OPCODE
               when "0000011" => --Instrucciones del tipo load 
                    rs1_dir <= instruction(19 downto 15);
                    resultado <= data_rs1 & X"000" & instruction(31 downto 20) & X"000" & instruction (11 downto 7) & instruction(14 downto 12) & instruction(6 downto 0);
                               --  OP1       UNS             INNMEDIATO            OFF            RD                         SUBOPCODE                  OPCODE
               when " -- TODO SIGUIENTE STORES
                    
            
            


end Behavioral;
