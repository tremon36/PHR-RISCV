

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Test_Shift_module is
end Test_Shift_module;

architecture Behavioral of Test_Shift_module is

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
    SM : Shift_module port map (clk, reg_1, num_bits_shift, s_u, l_r, reset, z, stall_out);
    
    process 
    begin
        clk <= '0'; wait for 5ns;
        clk <= '1'; wait for 5ns;
    end process;
    
    reset <= '1' after 0ns, '0' after 10ns;
--    reg_1 <= x"00000009" after 10ns;-- x"8009" after 40ns;
--    s_u <= '0' after 10ns;
--    l_r <= '0' after 10ns;
--    num_bits_shift <= "00001" after 10ns;
    
    
    

end Behavioral;
