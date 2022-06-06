

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;

entity EXE is
  Port (op1,op2 : in std_logic_vector (31 downto 0);-- in case inmediate intruction, the inmediate op gets fech into the op2.
        ofsset : in std_logic_vector (11 downto 0);
        rd : in std_logic_vector (4 downto 0);
        sub_op_code : in std_logic_vector (2 downto 0);
        op_code : in std_logic_vector (6 downto 0);
        clk : in std_logic;
        reset, stall_in : in std_logic;
        Instructio_pointer : in std_logic_vector (31 downto 0);
        stall_out : out std_logic;
        z : out std_logic_vector (90 downto 0)
        );
end EXE;
architecture Behavioral of EXE is

component Shift_module_v2 is
    Port (clk : in std_logic ;
          reg_1 : in std_logic_vector (31 downto 0);                --Numero al que se va a desplazar.
          num_bits_sift : in std_logic_vector (4 downto 0);         --Numero de bits que se van a desplazar
          s_u : in std_logic;                                       --Singed/unsinged, 1 = signed
          l_r : in std_logic;                                       --Desplazamiento a izquierda o derecha, 1 = derecha
          reset : in std_logic ;                                    --Reset signal 
          z : out std_logic_vector (31 downto 0);                   --Salida
          enable : in std_logic;
          end_of_op : out std_logic);                                                           
          
end component;

signal load : std_logic_vector (90 downto 0);
signal s_u : std_logic;
signal l_r : std_logic;
signal z_shift : std_logic_vector (31 downto 0);
signal Shift_enable : std_logic ;
signal end_of_Shift : std_logic;
signal debug_ERROR : std_logic ;                --Internal debugging signal. 

signal Shift_Module_In_Use : std_logic;

begin

    SM : Shift_module_v2 port map(clk, op1, op2(4 downto 0), s_u, l_r, reset, z_shift , Shift_enable, end_of_Shift );
    process (clk)
    
        begin 
        
        if (clk = '1' and clk'event) then
            --Alu reset;
            if (reset = '1')then
                stall_out <= '0';
                Shift_enable <= '0';
                z <= x"0000000000000000000000" & "000";
            else
            
--          Shift module controller, the Shift module is govern by the Shift enable that turns to one when the alu reads a shift instruction and switches to 0 when it finishes it.
--          Beeing also the only instruction that needs more than a cicle to complete; it also controls the stall_out flaj.           
            if(op_code = "0110011" and (sub_op_code = "001" or sub_op_code = "101"))then 
                
--              When the shift module finishes its gets to sleep otherwise its active.                
                if(end_of_Shift = '1')then Shift_enable <= '0';
                    stall_out <= '0';
                    
--                  Whe need to include this instructions out of the  "if ( stall_in = '0')then" becasue we need to update the exit of the alu before the the pipeline returns to  work so that                     
--                  the write stage can read it just as the pipe restarats  
 
                    z <= z_shift  & op2 & ofsset & rd & sub_op_code & op_code;
                else Shift_enable <= '1';
                    stall_out <= '1';
                end if;
            end if;
            
            -- checks for a general pipe stall before executing any instruction, if there is one the last op value gets save in the z_alu signal which acts as a register.
            if ( stall_in = '0')then
                case op_code is
                when "0110111" => z  <= op2 & op2 & ofsset & rd & sub_op_code & op_code;                            --LUI
                when "0010111" => z  <= (op1 + Instructio_pointer) & op2 & ofsset & rd & sub_op_code & op_code;        --AUIPC                            --AUIPC Add Upper Imm to PC
                when "1101111" => z <= (Instructio_pointer + x"0000004") & op2 & ofsset & rd & sub_op_code & op_code; --JAL      
                When "1100111" => z <= (Instructio_pointer + x"0000004") & op2 & ofsset & rd & sub_op_code & op_code; --JALR
                when "0000011" => z <= (op1  + std_logic_vector(resize(signed(ofsset), 32))) & op2 & ofsset & rd & sub_op_code & op_code;   --LB, LH, LW, LBU, LHU  Ricardo se tiene que acordar de hacer un resize de los inmediatos.   
                when "0010011" =>
                    case sub_op_code is 
                        when "000" => z <= (op1 + op2) & op2 & ofsset & rd & sub_op_code & op_code;                       --ADDI
                        when "010"  =>                                         --SLTI
                            if (op1(31) = '1')then
                                if(op2(31) = '1')then                     --los dos son neativos.
                                    if (op1 > op2)then z <= x"00000001" & op2 & ofsset & rd & sub_op_code & op_code;
                                    else z <= x"00000000" & op2 & ofsset & rd & sub_op_code & op_code;
                                    end if;
                                else z <= x"00000000" & op2 & ofsset & rd & sub_op_code & op_code ;               --op1<0, op2>0;
                                end if;
                            else                                          
                                if(op2(31) = '1')then                     --op1>0, op2<0;
                                    z <= x"00000001" & op2 & ofsset & rd & sub_op_code & op_code ;
                                else                                      --op1>0, op2>0;
                                    if (op1 > op2) then z <= x"00000001" & op2 & ofsset & rd & sub_op_code & op_code;
                                    else z <= x"00000000" & op2 & ofsset & rd & sub_op_code & op_code ;
                                    end if;
                                end if;   
                            end if; 
                            if (op1 > op2)then z <= x"00000001" & op2 & ofsset & rd & sub_op_code & op_code;
                            else z <= x"00000000" & op2 & ofsset & rd & sub_op_code & op_code ;
                            end if;
                        When "011" =>                                           --SLTIU 
                            if (op1 > op2)then z <= x"00000001" & op2 & ofsset & rd & sub_op_code & op_code;
                            else z <= x"00000000" & op2 & ofsset & rd & sub_op_code & op_code ;
                            end if;  
                        when "100" => z <= (op1 xor op2) & op2 & ofsset & rd & sub_op_code & op_code;                     --XORI 
                        when "110" => z  <= (op1 or op2) & op2 & ofsset & rd & sub_op_code & op_code;                     --ORI
                        when "111" => z  <= (op1 and op2) & op2 & ofsset & rd & sub_op_code & op_code;                    --ANDI
                        when others => debug_ERROR <= '1';
                     end case;
                when "0110011" =>
                    case sub_op_code is
                        when "001" =>                                          --SLLI
                            l_r <= '0';
                            s_u <= '0';
                                       
                        when "101" =>                                        --SRLI & SRAI 
                            l_r <= '1';
                            if(ofsset (5) = '0')then  s_u <= '0';
                            else s_u <= '1';
                            end if;          
                        when "000" =>                                        --ADD & SUB 
                            if(ofsset (5) = '0')then  z <= (op1 + op2) & op2 & ofsset & rd & sub_op_code & op_code;
                            else z <= (op1 - op2) & op2 & ofsset & rd & sub_op_code & op_code;
                            end if;
                        when "010"  =>                                         --SLT
                            if (op1(31) = '1')then
                                if(op2(31) = '1')then                     --los dos son neativos.
                                    if (op1 > op2)then z <= x"00000001" & op2 & ofsset & rd & sub_op_code & op_code;
                                    else z<= x"00000000" & op2 & ofsset & rd & sub_op_code & op_code ;
                                    end if;
                                else z<= x"00000000" & op2 & ofsset & rd & sub_op_code & op_code ;               --op1<0, op2>0;          
                                end if;
                            else                                          
                                if(op2(31) = '1')then                     --op1>0, op2<0;
                                    z<= x"00000001" & op2 & ofsset & rd & sub_op_code & op_code;
                                else                                      --op1>0, op2>0;
                                    if (op1 > op2)then z <= x"00000001" & op2 & ofsset & rd & sub_op_code & op_code;
                                    else z<= x"00000000" & op2 & ofsset & rd & sub_op_code & op_code ;
                                    end if;
                                end if;   
                            end if; 
                            if (op1 > op2)then z<= x"00000001" & op2 & ofsset & rd & sub_op_code & op_code;
                            else z<= x"00000000" & op2 & ofsset & rd & sub_op_code & op_code ;
                            end if;
                        When "011" =>                                           --SLTU 
                            if (op1 > op2)then z <= x"00000001" & op2 & ofsset & rd & sub_op_code & op_code;
                            else z <= x"00000000" & op2 & ofsset & rd & sub_op_code & op_code ;
                            end if; 
                        when "100" => z <= (op1 xor op2) & op2 & ofsset & rd & sub_op_code & op_code;                     --XOR
                        when "110" => z <= (op1 or op2) & op2 & ofsset & rd & sub_op_code & op_code;                      --OR
                        when "111" => z <= (op1 and op2) & op2 & ofsset & rd & sub_op_code & op_code;                     --AND
                        when others => debug_ERROR <= '1';
                    end case;
                    when others => 
                    debug_ERROR <= '1';
                    z <= op1  & op2 & ofsset & rd & sub_op_code & op_code;
                end case;
                
           end if;
                
        end if; 
        
      end if;
   
    end process ;

end Behavioral;