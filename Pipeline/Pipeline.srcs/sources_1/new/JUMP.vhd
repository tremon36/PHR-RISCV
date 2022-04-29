library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;



entity JUMP is
 Port (reset,stall,clk:in std_logic;
        instruction:in std_logic_vector(91 downto 0);
        instruction_z:out std_logic_vector(91 downto 0);
        current_pc:in std_logic_vector(31 downto 0);
        pc_actualizado:out std_logic_vector(31 downto 0);
        reset_prev,enable_parallel_cp:out std_logic 
        );
end JUMP;

architecture Behavioral of JUMP is

component EUNSIGNED 
        port(num1,num2:in std_logic_vector(31 downto 0);
        g,e,l: out std_logic);
end component;
 component ESIGNED 
        port(num1,num2:in std_logic_vector(31 downto 0);
        g,e,l: out std_logic);
end component;
 
 signal resultado:std_logic_vector(91 downto 0);
 signal OPCODE: std_logic_vector(6 downto 0);
 signal SUBOPCODE:std_logic_vector(2 downto 0);
 signal gu,eu,lu, g,e,l:std_logic;
 signal num1,num2,signed_offset:std_logic_vector(31 downto 0);
 
begin
comparador_u:EUNSIGNED port map(num1,num2,gu,eu,lu);
comparador_s:ESIGNED port map(num1,num2,g,e,l);

signed_offset <= std_logic_vector(resize(signed(instruction(26 downto 15) & '0'), 32)); -- extension en signo, añadiendo el bit extra
instruction_z <= resultado;
process(clk)
begin
    if(clk = '1' and clk'event) then
        if reset = '1' then
            resultado <=  x"0000000000000000000000" & "000";
            reset_prev <='0';
            num1<=x"00000000";
            num2<=x"00000000";
            enable_parallel_cp<='0';
            pc_actualizado<=x"00000000";
         else
         
         if stall = '0' then
            
            
         
            resultado <= instruction;
            
            case OPCODE is 
                when "110011" => --es BRANCH1
                num1<=instruction(90 downto 59);
                num2<= instruction(58 downto 27);
                reset_prev <= '1';
                enable_parallel_cp <= '1';
                case SUBOPCODE is
                     when "000" =>--BEQ
                         if e='1' then
                         pc_actualizado <= signed_offset + current_pc;
                         else enable_parallel_cp <= '0';
                         end if;
                     when "001" =>--BNE
                        if e/='1' then
                        pc_actualizado <= signed_offset + current_pc;
                        else enable_parallel_cp <= '0';
                        end if;
                      when "100" =>--BLT
                        if l = '1' then
                        pc_actualizado <= signed_offset + current_pc;
                        else enable_parallel_cp <= '0';
                        end if;
                      when "101" =>--BGE
                        if g='1' or e='1' then
                        pc_actualizado <= signed_offset + current_pc;
                        else enable_parallel_cp <= '0';
                        end if;
                      when "110" =>--BLTU
                        if lu='1' then
                        pc_actualizado <= signed_offset + current_pc;
                        else enable_parallel_cp <= '0';
                        end if;       
                      when "111" => --BGEU 
                        if gu = '1' or eu = '1' then 
                        pc_actualizado <= signed_offset + current_pc;
                        else enable_parallel_cp <= '0';
                        end if;
                      end case;
                when "1101111" => -- JAL 
                       pc_actualizado <= instruction(90 downto 59) + current_pc;
                       reset_prev <= '1';
                       enable_parallel_cp <= '1';
                when "1100111" => --JALR 
                       pc_actualizado <= std_logic_vector(resize(signed(instruction(26 downto 15)), 32)); --porque este tiene todos los bit
                       reset_prev <= '1';
                       enable_parallel_cp <= '1';
                when others => --otras operaciones sin salto
                       reset_prev <= '0';
                       enable_parallel_cp <= '0';
                end case;
            end if; -- stall = '0';
          end if; -- reset = '0';
         end if; --clk = '1' and clk'event;
         
        end process;
          
                       

end Behavioral;
