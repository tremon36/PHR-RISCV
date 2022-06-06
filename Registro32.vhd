LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY register32 IS PORT(
    d   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ld  : IN STD_LOGIC; -- load/enable
    rd1 : IN std_logic; --read/enable
    rd2 : IN std_logic;
    clr : IN STD_LOGIC; -- sync. clear
    clk : IN STD_LOGIC; -- clock
    q1  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    q2  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    wf  : OUT std_logic -- write flag      
);
END register32;

ARCHITECTURE description OF register32 IS

signal state : std_logic_vector(31 downto 0); --register state
BEGIN
    process(clk)
    begin
        
       if rising_edge(clk) then
            if clr = '1' then
                state <= x"00000000";
                q1 <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
                q2 <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
            elsif  ld = '1' then
                    state <= d;
                    --flag       
             end if; 
        end if;
    end process;
    
        q1 <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when rd1 = '0' else
        state ;
        
         q2 <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when rd2 = '0' else
         state;
                              
END description;