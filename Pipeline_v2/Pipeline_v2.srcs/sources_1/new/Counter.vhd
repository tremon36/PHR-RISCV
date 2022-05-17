


---------------------5 bits synchronous Down counter------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity Counter is
  Port (reset, clk : in std_logic;
        z : out std_logic_vector (4 downto 0)    
        );
end Counter;

architecture Behavioral of Counter is
  component T_ff is
    port (t,clk, reset : in std_logic; 
          q : out std_logic );
  end component;
  signal  e, d, c, b, a : std_logic;
  signal ONE : std_logic;
begin
    ONE <= '1';
    --z <=not e & not d& not c& not b& not a;
    z <= e&d&c&b&a;
    
    F1 : T_ff port map(ONE, clk, reset, a);
    F2 : T_ff port map(a,clk ,reset, b);
    F3 : T_ff port map(a and b,clk ,reset, c);
    F4 : T_ff port map(a and b and c,clk,reset, d);
    F5 : T_ff port map(a and b and c and d,clk,reset, e);
    
end Behavioral;
