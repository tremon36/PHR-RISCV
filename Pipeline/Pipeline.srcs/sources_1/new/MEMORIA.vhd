library ieee;
use ieee.std_logic_1164.all;


use ieee.numeric_std.all;
entity SRAM is
    
 
    port ( Address : in std_logic_vector (31 downto 0);--A
              Data : inout std_logic_vector (31 downto 0);--D
               CLK : in std_logic;
                CE : in std_logic;
                bytes:in std_logic_vector(1 downto 0);
                RW : in std_logic );
    end SRAM;
architecture beh of SRAM is
     type tipo_RAM is array(1023 downto 0) of std_logic_vector (31 downto 0);
     signal ram_stat : tipo_RAM;
     attribute ram_init_file : string;
     attribute ram_init_file of ram_stat : signal is "SRAM.mif";
begin
     process (CE, RW)
     begin
     if (CE = '0' and RW = '1') then
     
     Data <= ram_stat (to_integer(unsigned(Address)));
     else
     Data <= (others => 'Z');
     
     end if;
     end process;
     process (CLK)
 begin
     if (CLK'event and CLK = '1') then
     if (CE = '0' and RW = '0') then
     ram_stat (to_integer(unsigned(Address))) <= Data;
     end if;
     end if;
 end process;
end beh;