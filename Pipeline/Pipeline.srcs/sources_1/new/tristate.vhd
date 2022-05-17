
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity tristate is
  Port (d : in std_logic;
        en : in std_logic;
        q : inout std_logic);
end tristate;

architecture Behavioral of tristate is

begin

process (d, en)
begin 
    if (en = '1')then   
        q <= d;
    else 
        q <= 'Z';
    end if;
end process;

end Behavioral;
