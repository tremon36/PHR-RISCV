library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Pipeline_completo is
    port(
        reset,clk: in std_logic);
end Pipeline_completo;

architecture Behavioral of Pipeline_completo is

--CONTADOR DE PROGRAMA

component CP
        port(
        count,reset,enable_parallel_load,clock:in std_logic;
        current_num:out std_logic_vector(31 downto 0);
        load: in std_logic_vector(31 downto 0)
        );
end component CP;


--REGISTROS INTERMEDIOS PARA GUARDAR DATOS RELATIVOS A signal 

component RegistroF
        port(
        reset,stall,clk: in std_logic;
        load: in std_logic_vector(31 downto 0);
        z: out std_logic_vector(31 downto 0)
        );        
end component RegistroF;


--FETCH 

component FETCH
    
port(
    stall,reset,clock:in std_logic;
    current_pc,instruction:in std_logic_vector(31 downto 0);
    current_inst,memory_dir_request,cp_inst: out std_logic_vector (31 downto 0);
    r_w: out std_logic;
    amount:out std_logic_vector(1 downto 0)
    );
end component FETCH;

--DECODE 

component DECODE
port(
        reset,stall,clock: in std_logic;
        instruction,data_rs2,data_rs1: in std_logic_vector(31 downto 0);
        rs2_dir,rs1_dir,rd_dir: out std_logic_vector(4 downto 0);
        stall_prev,register_r: out std_logic;
        decoded_instruction: out std_logic_vector(90 downto 0)      
        );

end component DECODE;


--JUMP 

component JUMP
port(
        reset,stall,clk:in std_logic;
        instruction:in std_logic_vector(90 downto 0);
        instruction_z:out std_logic_vector(90 downto 0);
        current_pc:in std_logic_vector(31 downto 0);
        pc_actualizado:out std_logic_vector(31 downto 0);
        reset_prev,enable_parallel_cp:out std_logic );
        
end component JUMP;


--EXECUTE 

component EXE
Port (op1,op2 : in std_logic_vector (31 downto 0);-- in case inmediate intruction, the inmediate op gets fech into the op2.
        ofsset : in std_logic_vector (11 downto 0);
        rd : in std_logic_vector (4 downto 0);
        sub_op_code : in std_logic_vector (2 downto 0);
        op_code : in std_logic_vector (6 downto 0);
        clk : in std_logic;
        reset, stall_in : in std_logic;
        stall_out : out std_logic
        );
 end component EXE;
 
 --MEMORY 
 
 component MEMORY   
     port(
        stall,reset,clk: in std_logic;
        memory_dir,memory_to_write: out std_logic_vector(31 downto 0);
        memory_data: in std_logic_vector(31 downto 0);
        rw,stall_prev: out std_logic;
        decoded_instruction: in std_logic_vector(90 downto 0);
        instruction_z: out std_logic_vector(90 downto 0);
        bytes:out std_logic_vector(1 downto 0));
end component MEMORY;

--WRITE

--signals de program counter 
signal stall_pc, enable_parallel_load: std_logic;
signal instruction_pointer_PC,jump_result: std_logic_vector(31 downto 0);

--signals de fetch
signal stall_fetch,r_w_instruction_memory,reset_fetch: std_logic;
signal instruccion_actual_entrada_fetch,instruccion_salida_fetch,instruction_memory_dir_request: std_logic_vector(31 downto 0);
signal instruction_pointer_salida_fetch: std_logic_vector(31 downto 0);
signal instruction_size: std_logic_vector(1 downto 0);

--signals de decode
signal stall_decode,reset_decode,stall_prev,read_from_register: std_logic;
signal data_rs1,data_rs2,instruction_pointer_salida_decode: std_logic_vector(31 downto 0);
signal rs1_dir,rs2_dir,rd_dir: std_logic_vector(4 downto 0);
signal decoded_instruction: std_logic_vector(90 downto 0);

--signals de jump 
signal stall_jump,reset_jump,reset_prev_to_jump: std_logic;
signal decoded_instruction_jump: std_logic_vector(90 downto 0);
signal jump_instruction_pointer,instruction_pointer_salida_jump: std_logic_vector(31 downto 0);

--signals de execute 
signal stall_exe,reset_exe,stall_previous_exe:std_logic;
signal op1,op2,instruction_pointer_salida_exe: std_logic_vector(31 downto 0);
signal offset: std_logic_vector(11 downto 0);
signal rd: std_logic_vector(4 downto 0);
signal sub_opcode:std_logic_vector(2 downto 0);
signal opcode: std_logic_vector(6 downto 0);
signal decoded_instruction_exe: std_logic_vector(90 downto 0);

--signals de memory 
signal stall_memory,reset_memory:std_logic;
signal memory_dir,memory_data_to_write,memory_data_to_read: std_logic_vector(31 downto 0);
signal rw_memory,stall_previous_memory: std_logic;
signal decoded_instruction_memory: std_logic_vector(90 downto 0);
signal bytes_to_write_memory: std_logic_vector(1 downto 0);


begin
    
    programCounter: CP port map ( --TODO añadir stall_out de todos los siguientes 
            stall_pc,             
            reset,
            enable_parallel_load,   --tiene que ser 1 cuando se vaya a actualizar el PC por la etapa JUMP
            clk,
            instruction_pointer_PC, --la direccion guardada el contador de programa
            jump_result);           --la direccion a la que actualizar el contador de programa en un salto
            
    fetch_stage: FETCH port map (
            stall_fetch,
            reset_fetch,
            clk,
            instruction_pointer_PC,             -- la direccion que el PC le pasa a fetch
            instruccion_actual_entrada_fetch,   -- resultado de buscar en la memoria de instrucciones
            instruccion_salida_fetch,           -- salida de fetch (instruccion a pasar por el pipeline)
            instruction_memory_dir_request,     -- Direccion de peticion de busqueda a la memoria
            instruction_pointer_salida_fetch,   -- Puntero de instruccion asociado a la instruccion de salida
            r_w_instruction_memory,             -- Indicacion a la memoria de que se va a leer o a escribir (deberia ser siempre 0, read)
            instruction_size);                  -- Indicacion a la memoria del numero de bytes que se van a leer(deberia ser siempre 10, 4 byte);
            
    decode_stage: DECODE port map(
            reset_decode,                       
            stall_decode,
            clk,
            instruccion_salida_fetch,           -- Instruccion sin decodificar, salida de fetch
            data_rs2,                           -- Datos leidos del registro rs2 (ADD rd,rs1,rs2 ejemplo de innstruccion)
            data_rs1,                           -- Datos leidos del registro rs1 
            rs2_dir,                            -- Direccion del registro rs2 (desde 0 a 31)
            rs1_dir,                            -- Direccion del registro rs1 (desde 0 a 31)
            rd_dir,                             -- Direccion del registro de destino (rd) (desde 0 a 31)
            stall_prev,                         -- Parar las etapas anteriores si hay riesgo RAW
            read_from_register,                 -- Indicar al banco de registros si se va a leer o no
            decoded_instruction);               -- Instruccion procesada y decodificada, para continuar por el pipeline
            
    jump_stage: JUMP port map(
            reset_jump,
            stall_jump,
            clk,
            decoded_instruction,                -- Instruccion decodificada que viene de la etapa decode
            decoded_instruction_jump,           -- Reenviar la instruccion decodificada por el pipeline, un ciclo despues de que llegue
            jump_instruction_pointer,           -- PC asociado a la instruccion que esta pasando por la etapa
            jump_result,                        -- Direccion de instruccion a la que saltar de ser necesario (es el valor de parallel load del PC)
            reset_prev_to_jump,                 -- Resetear las etapas anteriores si se salta, pues contienen instrucciones que no hay que ejecutar
            enable_parallel_load );             -- Indicar al PC si debe ejecutar el salto (hacer carga paralela)
            
            
    execute_stage: EXE port map(                    -- Campos de la instruccion decodificada
           decoded_instruction_jump(90 downto 59),  -- Operando 1 
           decoded_instruction_jump(58 downto 27),  -- Operando 2 
           decoded_instruction_jump(26 downto 15),  -- Offset 
           decoded_instruction_jump(14 downto 10),  -- Registro de destino 
           decoded_instruction_jump(9 downto 7),    -- Subopcode 
           decoded_instruction_jump(6 downto 0),    -- codigo de operacion (opcode)
           clk,
           reset_exe,
           stall_exe,
           stall_previous_exe
           decoded_instruction_exe);                -- @TODO salida de instruccion de exe para pasar por el pipeline
           
   memory_stage: MEMORY port map( 
           stall_memory,
           reset_memory,
           clk,
           memory_dir,                             -- Direccion de memoria de la que se va a leer/escribir 
           memory_data_to_write,                   -- Datos que se van a escribir en memoria (se envia al modulo de memoria)
           memory_data_to_read,                    -- Datos resultado de leer en memoria (los envia el modulo de memoria)
           rw_memory,                              -- Indicacion a la memoria de si se va a leer (0) o a escribir (1)
           stall_previous_memory,                  -- Parada del pipeline hasta obtener un resultado de memoria 
           decoded_instruction_exe,                -- Instruccion que pasa la etapa execute a las siguientes
           decoded_instruction_memory,             -- Instruccion a propagar a las siguientes etapas del pipeline
           bytes_to_write_memory);                 -- Cantidad de bytes que van a ser escritos/leidos en memoria
           
           
--@TODO etapa de write
            
            
   --registros que contienen el contador de programa asociado a la instrucccion que se esta ejecutando en esa etapa del pipeline 
   
   registro_decode_cp: RegistroF port map (
        reset_decode,stall_decode,clk,instruction_pointer_salida_fetch,instruction_pointer_salida_decode);
        
   registro_jump_cp: RegistroF port map (
        reset_jump,stall_jump,clk,instruction_pointer_salida_decode,instruction_pointer_salida_jump);
        
   registro_exe_cp: RegistroF port map (
        reset_exe,stall_exe,clk,instruction_pointer_salida_jump,instruction_pointer_salida_exe);
   
            

end Behavioral;
