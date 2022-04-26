--Este modulo se encarga de las operaciones SLL, SLA, SRL, SRA.
--Lo que hace es multiplicar o dividir por 2ˆnum_bits_shift desplazando los valores de reg_1 dentro de Operant, para posteriormente quedarnos 
--la salida con los 32 bits centrales de Operant.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Shift_module is
    Port (clk : in std_logic ;
          reg_1 : in std_logic_vector (31 downto 0);                --Numero al que se va a desplazar.
          num_bits_sift : in std_logic_vector (4 downto 0);         --Numero de bits que se van a desplazar
          s_u : in std_logic;                                       --Singed/unsinged, 1 = signed
          l_r : in std_logic;                                      --Desplazamiento a izquierda o derecha, 1 = derecha
          z : out std_logic_vector (31 downto 0);                   --Salida
          stall :out std_logic );                                   --Bit de parada del pipeline                                     
end Shift_module;

architecture Behavioral of Shift_module is

signal Operant : std_logic_vector (95 downto 0);                    --32 bits de desplazamiento a izquierda + reg_1 + 32 bits de desplazamiento a la derecha.
signal TWOexp_nbs : std_logic_vector (31 downto 0);                 --Potencia de dos por la que se va a multi/divi Operant para desplazar reg_1.              

begin

process (reg_1)
    begin 

    if (s_u = '1') then
        if(l_r  = '1' and reg_1 (31) = '1') then
        
        end if;
    end if; 
    
    
end process;


end Behavioral;
