

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Test_Shift_Moduke_V2 is
end Test_Shift_Moduke_V2;

architecture Behavioral of Test_Shift_Moduke_V2 is

component Shift_module_v2 is
    Port (clk : in std_logic ;
          reg_1 : in std_logic_vector (31 downto 0);                --Numero al que se va a desplazar.
          num_bits_sift : in std_logic_vector (4 downto 0);         --Numero de bits que se van a desplazar
          s_u : in std_logic;                                       --Singed/unsinged, 1 = signed
          l_r : in std_logic;                                       --Desplazamiento a izquierda o derecha, 1 = derecha
          reset : in std_logic ;                                    --Reset signal 
          z : out std_logic_vector (31 downto 0);                   --Salida
          stall_out : out std_logic;
          stall_in : in std_logic);
end component;

signal clk, s_u, l_r, reset, stall_out, stall_in : std_logic;
signal reg_1, z: std_logic_vector (31 downto 0);
signal num_bits_shift : std_logic_vector (4 downto 0);

signal aux : std_logic;

begin

SM : Shift_module_v2 port map (clk,reg_1,num_bits_shift, s_u , l_r,reset , z, stall_out, stall_in );

process 
begin
    clk <= '0'; wait for 5ns;
    clk <= '1'; wait for 5ns;
end process;

process (clk)
begin 
    if (clk'event and clk = '0')then
        if (aux = '1')then  
            stall_in <= '1';
        else
            stall_in <= stall_out;

        end if;
    end if;
end process;
aux   <= '1' after 0ns;-- '0' after 20ns, '1' after 80ns, '0' after 90ns;
s_u <= '1' after 0ns;
l_r <= '1' after 0ns;
reg_1 <= x"f0000040" after 0ns, x"00000002" after 80ns;
num_bits_shift <= "00100" after 0ns, "00010" after  80ns;
reset <= '1' after 0ns, '0' after 10ns, '1' after 80ns, '0' after 60ns;
 
end Behavioral;
