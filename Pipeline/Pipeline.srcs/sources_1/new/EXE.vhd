

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity EXE is
  Port (op1,op2 : in std_logic_vector (31 downto 0);-- in case inmediate intruction, the inmediate op gets fech into the op2.
        ofsset : in std_logic_vector (11 downto 0);
        rd : in std_logic_vector (4 downto 0);
        sub_op_code : in std_logic_vector (2 downto 0);
        op_code : in std_logic_vector (6 downto 0);
        clk : in std_logic;
        reset, stall : in std_logic
        );
end EXE;

architecture Behavioral of EXE is

component Registro_Intermedio_Decodificado
    port (reset,stall,clk: in std_logic;
          load: in std_logic_vector(90 downto 0);
          z: out std_logic_vector(90 downto 0)  
        );
end component ;

signal load : std_logic_vector (90 downto 0);
signal z : std_logic_vector (90 downto 0);

signal z_alu : std_logic_vector (31 downto 0);  --Alu exit befor operations.

begin

    reg_op : Registro_Intermedio_Decodificado port map (reset, stall, clk, load, z);
    process (clk)
        begin 
        if (clk = '1' and clk'event) then
            case op_code is
            when "0110111" => z_alu  <= op2;                            --LUI
            when "0010111" => z_alu <= op1;  
            when "0000011" => z_alu <= op2 ;                            --LB, LH, LW, LBU, LHU  Ricardo se tiene que acordar de hacer un resize de los inmediatos.
--                case sub_op_code is 
--                when "000" => z_alu <= op2; 
--                end case;
            when "0010011" =>
                case sub_op_code is 
                    when "000" => z_alu <= op1 + op2;                       --ADDI
                    when "010" to "011" => z_alu <= x"00000001" when op1 > op2 else x"00000000" ;   --SLTI & SLTIU
                    when "100" => z_alu <= op1 xor op2;                     --XORI 
                    when "110" => z_alu  <= op1 or op2;                     --ORI
                    when "111" => z_alu  <= op1 and op2;                    --ANDI
                 end case;
            when "0010011" =>
                case sub_op_code is
                    when "001" => z_alu <= shift_left (op1, op2);           --SLLI
                    when "101" => z_alu <= shift_right (op1, op2);          --SRLI & SRAI !!!!!! NO se pueden diferenciar con el op_code y el sub_opcode
                    when "000" => z_alu <= op1 + op2;
                    when "001" => z_alu <= shift_left (op1, op2);           --ADD & SUB !!!!!! NO se pueden diferenciar con el op_code y el sub_opcode
                    when "010" to "011" => z_alu <= z_alu <= x"00000001" when op1 > op2 else x"00000000" ;  --SLT & SLTU
                    when "100" => z_alu <= op1 xor op2;                     --XOR
                    when "101" => z_alu <= shift_right (op1, op2);          --SRL & SRA !!!!!! NO se pueden diferenciar con el op_code y el sub_opcode
                    when "110" => z_alu <= op1 or op2;                      --OR
                    when "111" => z_alu <= op1 and op2;                     --AND
                end case;
            end case;
            
            load <= z_alu & op2 & ofsset & sub_op_code & op_code  -- Problema de que es un proceso y necestamos mandarle un tick de reloj para que actualice los datos del registro.
            
            
            
        end if; 
   
    end process ;

end Behavioral;