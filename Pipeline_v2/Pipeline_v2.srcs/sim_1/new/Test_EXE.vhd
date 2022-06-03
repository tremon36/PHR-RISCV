library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity Test_EXE is
end entity;

architecture Behavioral of Test_EXE is

component EXE is 
 Port (op1,op2 : in std_logic_vector (31 downto 0);-- in case inmediate intruction, the inmediate op gets fech into the op2.
        ofsset : in std_logic_vector (11 downto 0);
        rd : in std_logic_vector (4 downto 0);
        sub_op_code : in std_logic_vector (2 downto 0);
        op_code : in std_logic_vector (6 downto 0);
        clk : in std_logic;
        reset, stall_in : in std_logic;
        stall_out : out std_logic;
        z : out std_logic_vector (90 downto 0)
        );
end component EXE;

signal op1, op2 :std_logic_vector (31 downto 0);
signal ofsset : std_logic_vector (11 downto 0);
signal rd : std_logic_vector (4 downto 0);
signal sub_op_code : std_logic_vector (2 downto 0);
signal op_code : std_logic_vector (6 downto 0);
signal clk, reset, stall_in, stall_out : std_logic;
signal z : std_logic_vector (90 downto 0);

signal aux : std_logic;


begin 

Alu1 : EXE port map(op1, op2, ofsset, rd, sub_op_code, op_code, clk, reset, stall_in , stall_out, Z);

process
begin
    clk <= '0'; wait for 5ns;
    clk <= '1'; wait for 5ns;
end process;


    aux <= '0' after 0ns;
    stall_in <= stall_out or aux;
    reset <= '1' after 0ns, '0' after 10ns;
   
    op1 <= x"80000001" after 0ns, x"80000003" after 30ns, x"00000001" after 50ns, X"0000000F" after 60ns, X"00000001" after 70ns,
           X"FFFFFFFF" after 80ns, X"00000001" after 90ns;
    op2 <= x"FFFFFFFF" after 0ns, x"00000000" after 20ns, x"00000001" after 50ns, X"00000001" after 60ns, X"0000000F" after 70ns,
           X"00000001" after 70ns,X"00000003" after 90ns; 
    
    op_code <= "0110111" after 0ns,     --LUI 
        --"0010111" after 30ns;         --!!!!Seguramente se implemente en una Alu aparte.
        "0000011" after 30ns,           --Instruciiones de Load, no hace nada, le pasa las instrucciones a la etapa de memory.
        "0010011" after 50ns,           ----ADDI 50ns, SLTI 60ns & 70ns;
        "0110011" after 90ns;           --SLI
        --"0000011" after 100ns;
    sub_op_code <= "000" after 0ns,
        "010" after 60ns,
        "001" after 90ns;
    ofsset <= x"000" after 0ns;
    rd <= "00000" after 0ns;
  

end architecture;































