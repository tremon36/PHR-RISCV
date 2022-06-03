
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;

--This modules is in charge of making thr four different shift operations. It reads the number to shift (reg_1) and makes a "num_bits_shift" number of one bit shift.
--This is our form of overcoming the dinamic shift operations using statics operators.  


entity Shift_module_v2 is
     Port (clk : in std_logic ;
          reg_1 : in std_logic_vector (31 downto 0);                --Numero al que se va a desplazar.
          num_bits_sift : in std_logic_vector (4 downto 0);         --Numero de bits que se van a desplazar
          s_u : in std_logic;                                       --Singed/unsinged, 1 = signed
          l_r : in std_logic;                                       --Desplazamiento a izquierda o derecha, 1 = derecha
          reset : in std_logic ;                                    --Reset signal 
          z : out std_logic_vector (31 downto 0);                   --Salida
          enable : in std_logic;                                    --Module enable
          end_of_op : out std_logic);                               --End of operation flaj
          
end Shift_module_v2;

architecture Behavioral of Shift_module_v2 is

component Counter is 
    port (reset, clk : in std_logic;
          z : out std_logic_vector (4 downto 0)    
           );
end component;


signal cont : std_logic_vector (4 downto 0);
signal resetCont : std_logic ;
signal z_SLU : std_logic_vector (31 downto 0);
signal z_SRU : std_logic_vector (31 downto 0);
signal z_SRS : std_logic_vector (31 downto 0); 

begin

C1 : Counter port map (resetCont , clk, cont);

process (clk)


begin

if (clk'event and clk = '1') then 
    if (reset = '1') then 
        z_SLU <= x"00000000";
        z_SRS <= x"00000000";
        z_SRU <= x"00000000";
        resetCont <= reset;    
    else
        --It only works when enable = '1';
        if (enable  = '1') then 
            resetCont <= '0';
            end_of_op <= '0';
            
 --         In the first clock it writes to the internal registers the content of the reg_1 then procedes to make the shifts.
 --         When the it reaches the designated number of shifts it assigneds the content of the wanted register to the exit of the module and 
 --         updates the end_of_op flaj so that the alu can continue.
            if (cont  = num_bits_sift + 1)then
              end_of_op <= '1';
               if (l_r = '1') then
                if (s_u = '1') then
                    z <= z_SRS;
                else
                    z <= z_SRU;
                end if;
               else 
                z <= z_SLU;
               end if;
               resetCont <= '1';
            else
                if (cont = "00000")then 
                    z_SLU <= reg_1;
                    z_SRS <= reg_1;
                    z_SRU <= reg_1;
                else
                    if (l_r = '1') then
                        if (s_u = '1') then
                            if(z_SRS (31) = '1') then z_SRS  <= '1' & z_SRS (31 downto 1);
                            else z_SRS  <= '0' & z_SRS (31 downto 1);
                            end if;
                        else
                            z_SRU  <=  '0'&z_SRU (31 downto 1);
                        end if;
                   else 
                    z_SLU  <= z_SLU (30 downto 0) & '0' ;
                   end if;
                end if;
            end if;      
          end if;
    end if;
end if;
end process;


end Behavioral;