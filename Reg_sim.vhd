library IEEE;
use IEEE.std_logic_1164.all;


entity Registros_sim is
end Registros_sim;

architecture Behavioral of Registros_sim is

    component Registros is
        port (
        r_dataBus1 : out std_logic_vector (31 downto 0);
        r_dataBus2 : out std_logic_vector (31 downto 0);
        w_dataBus : in std_logic_vector (31 downto 0);

        writeAddress : in std_logic_vector (4 downto 0);
        writeEnable : in std_logic;

        readAddress1 : in std_logic_vector (4 downto 0);
        readEnable1 : in std_logic;

        readAddress2 : in std_logic_vector (4 downto 0);
        readEnable2 : in std_logic;
        
        destinationRegister : in std_logic_vector(4 downto 0); 
        destinationEnable : in std_logic;
        
        mainReset : in std_logic;
        mainClock : in std_logic
    );
    end component;
    
    
    signal rDB1, rDB2,wDB : std_logic_vector (31 downto 0) := x"00000000";
    signal WAtst, RA1tst, RA2tst : std_logic_vector (4 downto 0) := "00000";
    signal WEtst, RE1tst,RE2tst : std_logic := '0';
    signal dR : std_logic_vector (4 downto 0) := "00000";
    signal dE : std_logic;
    signal Rst, Clk : std_logic := '0';
    
    
begin

        testing_unit : Registros port map (
            r_dataBus1 => rDB1,
            r_databus2 => rDB2,
            w_databus => wDB,
            writeAddress => WAtst,
            writeEnable  => WEtst,
            readAddress1 => RA1tst,
            readEnable1 => RE1tst,
            readAddress2 => RA2tst,
            readEnable2 => RE2tst,
            destinationRegister => dR,
            destinationEnable => dE,
            mainReset => Rst,
            mainClock => Clk   
    );
    
    
    process
    begin
        wait for 5 ns;
        Clk <= '1' ;
        wait for 5 ns;
        Clk <= '0';
    end process;
    
    Prueba_Registros : process 
    begin 
    wait for 200 ns;
--        Rst <= '1' after 5 ns, '0' after 10 ns;
        
        --escritura en el registro 00001
        wait for 10 ns;
        wDB <= x"11111111";
        WEtst <= '1';
        WAtst <= "00001";
        dR <= "00001";
        dE <= '1';
        wait for 20 ns;
        wDB <= x"00000000";
        WEtst <= '0';
        
        --escritura en el registro 10000
        wait for 10 ns;
        wDB <= x"FFFFFFFF";
        WEtst <= '1';
        WAtst <= "00010";
        dR <= "00010";
        wait for 10 ns;
        wDB <= x"00000000";
        WEtst <= '0';
        
        --escritura en el registro 10001
        wait for 10 ns;
        wDB <= x"00000001";
        WEtst <= '1';
        WAtst <= "10001";
        wait for 10 ns;
        wDB <= x"00000000";
        WEtst <= '0';
        
       --lectura del registro 00001 por bus1
        wait for 10 ns;
        RE1tst <= '1';
        RA1tst <= "00001";
        wait for 10 ns;
        RE1tst <= '0';
        RA1tst <= "00000";
        
        
        --lectura del registro 10000 por bus2
        wait for 10 ns;
        RE2tst <= '1';
        RA2tst <= "10000";
        wait for 10 ns;
        RE2tst <= '0';
        RA2tst <= "00000";        
        
        
        
        
    end process;

end Behavioral;
