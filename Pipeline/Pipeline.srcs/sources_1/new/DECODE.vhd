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
        ---operando 1 				          (32 bit)
        ---operando 2				          (32 bit)
        ---inmediato (offset)			      (12 bit)
        ---dirección de registro de destino   (5 bit)
        ---SUBOPCODE 			              (3 bit)
        ---OPCODE 				              (7 bit)      
          
        );
end DECODE;

architecture Behavioral of DECODE is

begin

process(clock) begin
    if(clock = '1' and clock'event) then
        if reset = '1' then
            


end Behavioral;
