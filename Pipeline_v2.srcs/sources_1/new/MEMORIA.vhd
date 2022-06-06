library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

-- A 128x8 single-port RAM in VHDL
entity Single_port_RAM is
port(
 RAM_ADDR: in std_logic_vector(6 downto 0); -- Address to write/read RAM
 RAM_DATA_IN: in std_logic_vector(31 downto 0); -- Data to write into RAM
 RAM_WR: in std_logic; -- Write enable 
 RAM_CLOCK: in std_logic; -- clock input for RAM
 RAM_DATA_OUT: out std_logic_vector(31 downto 0) ;-- Data output of RAM
 byte_amount: in std_logic_vector(1 downto 0)
);
end Single_port_RAM;

architecture Behavioral of Single_port_RAM is
-- define the new type for the 128x8 RAM 
type RAM_ARRAY is array (0 to 127 ) of std_logic_vector (7 downto 0);
-- initial values in the RAM
signal RAM: RAM_ARRAY;

signal addr_mas_uno,addr_mas_dos,addr_mas_tres: std_logic_vector(6 downto 0);

begin

addr_mas_uno <= RAM_ADDR + "0000001";
addr_mas_dos <= RAM_ADDR + "0000010";
addr_mas_tres <= RAM_ADDR + "0000011";

process(RAM_CLOCK)
begin
 if(rising_edge(RAM_CLOCK)) then
 if(RAM_WR='1') then -- when write enable = 1, 
 
 -- write input data into RAM at the provided address
 if(byte_amount = "00") then 
    RAM(to_integer(unsigned(RAM_ADDR))) <= RAM_DATA_IN(7 downto 0);
 elsif(byte_amount = "01") then 
    RAM(to_integer(unsigned(RAM_ADDR))) <= RAM_DATA_IN(7 downto 0);
    RAM(to_integer(unsigned(addr_mas_uno))) <= RAM_DATA_IN(15 downto 8);
 else 
    RAM(to_integer(unsigned(RAM_ADDR))) <= RAM_DATA_IN(7 downto 0);
    RAM(to_integer(unsigned(addr_mas_uno))) <= RAM_DATA_IN(15 downto 8);
    RAM(to_integer(unsigned(addr_mas_dos))) <= RAM_DATA_IN(23 downto 16);
    RAM(to_integer(unsigned(addr_mas_tres))) <= RAM_DATA_IN(31 downto 24);
 end if;
 end if;
 end if;
end process;
 -- Data to be read out 
 RAM_DATA_OUT <= x"000000" & RAM(to_integer(unsigned(RAM_ADDR))) when byte_amount = "00" else
                 x"0000" & RAM(to_integer(unsigned(addr_mas_uno))) & RAM(to_integer(unsigned(RAM_ADDR))) when byte_amount = "01" else 
                 RAM(to_integer(unsigned(addr_mas_tres))) & RAM(to_integer(unsigned(addr_mas_dos))) & RAM(to_integer(unsigned(addr_mas_uno))) & RAM(to_integer(unsigned(RAM_ADDR)));
end Behavioral;