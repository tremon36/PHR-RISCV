

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Test_SLU_R is
end Test_SLU_R;

architecture Behavioral of Test_SLU_R is

component ShiftLU_reg is
    port (d : in std_logic_vector  (31 downto 0);
          clk : in std_logic;
          z : out std_logic_vector (31 downto 0)
          );
end component ;

signal d, z : std_logic_vector (31 downto 0);
signal clk :std_logic;
signal d_aux : std_logic_vector (31 downto 0):= x"00000001";

begin
SLU : ShiftLU_reg port map (d, clk, z);

process
begin 
    clk <= '0'; wait for 5ns;
    clk <= '1'; wait for 5ns;
end process;
 
 d <= x"00000001" after 0 ns, x"00000010" after 30 ns;
 
--process (clk)
--begin 

--if (clk'event and clk  = '1') then 
--    d_aux <= z;
--end if;
    

--end process ;
    
    


end Behavioral;
