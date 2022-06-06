library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TEST_DECODE is
end TEST_DECODE;

architecture Test of TEST_DECODE is
    component DECODE 
    
     port(
        reset,stall,clock: in std_logic;
        instruction,data_rs2,data_rs1: in std_logic_vector(31 downto 0);
        rs2_dir,rs1_dir,rd_dir: out std_logic_vector(4 downto 0);
        stall_prev,register_r: out std_logic;
        decoded_instruction: out std_logic_vector(90 downto 0);
        will_write_flag: out std_logic
        
        --campos de la instruccion decodificada
        ---operando 1 				          (32 bit) --cuando solo hay un operando, lo metemos aqui
        ---operando 2				          (32 bit) --el inmediato va en el operando dos
        ---inmediato (offset)			      (12 bit) 
        ---dirección de registro de destino   (5 bit)
        ---SUBOPCODE 			              (3 bit)
        ---OPCODE 				              (7 bit)      
          
        );
    end component DECODE;
    
    signal reset,stall,clock,stall_prev,register_r: std_logic;
    signal instruction,data_rs2,data_rs1: std_logic_vector(31 downto 0);
    signal rs2_dir,rs1_dir,rd_dir: std_logic_vector(4 downto 0);
    signal decoded_instruction: std_logic_vector(90 downto 0);
    signal will_write_flag: std_logic;
    
begin

    decoder : DECODE port map(reset,stall,clock,instruction,data_rs2,data_rs1,rs2_dir,rs1_dir,rd_dir,stall_prev,register_r,decoded_instruction,will_write_flag);
    
    reloj: process begin
    clock <= '1';wait for 5ns;
    clock <= '0'; wait for 5ns;
    end process;
    
    reset <= '1' after 0ns, '0' after 11 ns;
    stall <= '0' after 0ns;
    data_rs2 <= x"FFFFFFFF" after 0ns;
    data_rs1 <= x"AAAAAAAA" after 0ns;
--     0:	00f612b3          	sll	t0,a2,a5
--   4:	00661293          	slli	t0,a2,0x6
--   8:	00f652b3          	srl	t0,a2,a5
--   c:	00665293          	srli	t0,a2,0x6
--  10:	40f652b3          	sra	t0,a2,a5
--  14:	40665293          	srai	t0,a2,0x6
--  18:	00f602b3          	add	t0,a2,a5
--  1c:	00660293          	addi	t0,a2,6
--  20:	40f602b3          	sub	t0,a2,a5
--  24:	000062b7          	lui	t0,0x6
--  28:	00006297          	auipc	t0,0x6
--  2c:	00f642b3          	xor	t0,a2,a5
--  30:	00664293          	xori	t0,a2,6
--  34:	00f662b3          	or	t0,a2,a5
--  38:	00666293          	ori	t0,a2,6
--  3c:	00f672b3          	and	t0,a2,a5
--  40:	00667293          	andi	t0,a2,6
--  44:	00f622b3          	slt	t0,a2,a5
--  48:	00662293          	slti	t0,a2,6
--  4c:	00f632b3          	sltu	t0,a2,a5
--  50:	00663293          	sltiu	t0,a2,6



-- 0:	00f61463          	bne	a2,a5,8 <_boot+0x8>
--   8:	00f60463          	beq	a2,a5,10 <_boot+0x10>
--  10:	00f65463          	ble	a5,a2,18 <_boot+0x18>
--  18:	00f64463          	blt	a2,a5,20 <_boot+0x20>
--  20:	00f67463          	bleu	a5,a2,28 <_boot+0x28>
--  28:	00f66463          	bltu	a2,a5,30 <_boot+0x30>
--  30:	004002ef         	jal	t0,30 <_boot+0x30>
--  34:	006602e7          	jalr	t0,6(a2)
    
    instruction <= x"00f612b3" after 20ns, 
                    x"00661293" after 30 ns,
                    x"00f652b3" after 40 ns,
                    x"00665293" after 50 ns,
                    x"40f652b3"after 60ns,
                    x"40665293"after 70 ns,
                    x"00f602b3" after 80ns,
                     x"00660293" after 90 ns,
                     x"40f602b3" after 100ns,
                     x"000062b7" after 110 ns,
                     x"00006297" after 120 ns,
                     x"00f642b3" after 130 ns,
                     x"00664293"after 140 ns,
                     x"00f662b3" after 150 ns,
                     x"00666293" after 160 ns,
                     x"00f672b3" after 170 ns,
                     x"00667293" after 180 ns,
                     x"00f622b3"after 190 ns,
                     x"00662293" after 200ns,
                     x"00f632b3" after 210ns,
                     x"00663293"after 220ns,
                     x"00f61463"after 230ns,
                     x"00f60463" after 240ns,
                     x"00f65463" after 250 ns,
                     x"00f64463" after 260 ns,
                     x"00f67463" after 270ns,
                     x"00f66463" after 280 ns,
                     x"004002ef" after 290 ns, --jal
                     x"006602e7" after 300ns; 
                    
                   

end Test;
