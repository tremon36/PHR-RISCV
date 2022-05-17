

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TEST_ShiftModule is
end TEST_ShiftModule;

architecture Behavioral of TEST_ShiftModule is


component Shift_module is
    port (clk : in std_logic ;
          reg_1 : in std_logic_vector (31 downto 0);                --Numero al que se va a desplazar.
          num_bits_sift : in std_logic_vector (4 downto 0);         --Numero de bits que se van a desplazar
          s_u : in std_logic;                                       --Singed/unsinged, 1 = signed
          l_r : in std_logic;                                       --Desplazamiento a izquierda o derecha, 1 = derecha
          reset : in std_logic ;                                    --Reset signal 
          z : inout std_logic_vector (31 downto 0);                   --Salida
          stall_out : out std_logic );
end component;

signal clk, s_u, l_r, reset, stall_out : std_logic;
signal reg_1, z: std_logic_vector (31 downto 0);
signal num_bits_shift : std_logic_vector (4 downto 0);


begin

SM : Shift_module port map(clk ,reg_1 ,num_bits_shift , s_u , l_r , reset , z, stall_out );

end Behavioral;
