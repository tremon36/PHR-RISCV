

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity EXE is
  Port (op1,op2 : in std_logic_vector (31 downto 0);-- in case inmediate intruction, the inmediate op gets fech into the op2.
        ofsset : in std_logic_vector (11 downto 0);
        rd : in std_logic_vector (4 downto 0);
        sub_op_code : in std_logic_vector (2 downto 0);
        op_code : in std_logic_vector (6 downto 0);
        clk : in std_logic;
        reset, stall_in : in std_logic;
        stall_out : out std_logic;
        );
end EXE;

architecture Behavioral of EXE is

component Registro_Intermedio_Decodificado
    port (reset,stall,clk: in std_logic;
          load: in std_logic_vector(90 downto 0);
          z: out std_logic_vector(90 downto 0)  
        );
end component ;

component Shift_module_v2 is
    Port (clk : in std_logic ;
          reg_1 : in std_logic_vector (31 downto 0);                --Numero al que se va a desplazar.
          num_bits_sift : in std_logic_vector (4 downto 0);         --Numero de bits que se van a desplazar
          s_u : in std_logic;                                       --Singed/unsinged, 1 = signed
          l_r : in std_logic;                                       --Desplazamiento a izquierda o derecha, 1 = derecha
          reset : in std_logic ;                                    --Reset signal 
          z : out std_logic_vector (31 downto 0);                   --Salida
          stall_out : out std_logic;                                --Bit de parada del pipeline                               
          stall_in : in std_logic);
end component;

signal load : std_logic_vector (90 downto 0);
signal z : std_logic_vector (90 downto 0);
signal s_u : std_logic;
signal l_r : std_logic;
signal z_alu : std_logic_vector (31 downto 0);  --Alu exit befor operations.
signal z_shift : std_logic_vector (31 downto 0);
signal stall_aux : std_logic ;

begin

    reg_op : Registro_Intermedio_Decodificado port map (reset, stall_aux , clk, load, z);
    SM : Shift_module_v2 port map(clk, op1, op2(4 downto 0), s_u, l_r, reset, z_shift , stall_aux, stall_in);
    process (clk)
        begin 
        
        if (clk = '1' and clk'event) then
        stall_out <= stall_aux;
            if (stall_aux = '0' and stall_in = '0')then
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
                        when "010" to "011" =>                                  --SLTI & SLTIU 
                            if (op1 > op2)then z_alu <= x"00000001";
                            else z_alu <= x"00000000" ;
                            end if;   
                        when "100" => z_alu <= op1 xor op2;                     --XORI 
                        when "110" => z_alu  <= op1 or op2;                     --ORI
                        when "111" => z_alu  <= op1 and op2;                    --ANDI
                     end case;
                when "0010011" =>
                    case sub_op_code is
                        when "001" =>                                           --SLLI
                            l_r <= '0';
                            s_u <= '0';
                            z_alu <= z_shift;           
                        when "101" => z_alu <= z_shift;                         --SRLI & SRAI !!!!!! NO se pueden diferenciar con el op_code y el sub_opcode
                            l_r <= '1';
                            if(ofsset (0) = '0')then  s_u <= '0';
                            else s_u <= '1';
                            end if;
                            z_alu <= z_shift;          
                        when "000" => z_alu <= op1 + op2;                       --ADD & SUB !!!!!! NO se pueden diferenciar con el op_code y el sub_opcode
                        when "010" to "011" =>                                  --SLT & SLTU  
                            if (op1 > op2)then z_alu <= x"00000001"; 
                            else z_alu <= x"00000000";
                            end if; 
                        when "100" => z_alu <= op1 xor op2;                     --XOR
                        when "110" => z_alu <= op1 or op2;                      --OR
                        when "111" => z_alu <= op1 and op2;                     --AND
                    end case;
                end case;
                
                load <= z_alu & op2 & ofsset & sub_op_code & op_code;  -- Problema de que es un proceso y necestamos mandarle un tick de reloj para que actualice los datos del registro.
                
           end if;
                
        end if; 
   
    end process ;

end Behavioral;