--

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_unsigned.all;

entity RV32_tb is
end entity;

architecture arch of RV32_tb is

component RV32 is
    port (
        clk_i           : in  std_logic;                        -- Clock input
        rst_i           : in  std_logic;                        -- Active-hight reset input ('1' brings CPU in reset state)
        
        instr_addr_o    : out std_logic_vector(31 downto 0);    -- 32-bit instruction address
        instr_data_i    : in  std_logic_vector(31 downto 0);    -- 32-bit instruction data
        
        mem_we_o        : out std_logic;                        -- Active-high memory write strobe ('1' performs mem_data_o write to memory at address mem_addr_o)
        mem_addr_o      : out std_logic_vector(31 downto 0);    -- 32-bit memory address
        mem_data_i      : in  std_logic_vector(31 downto 0);    -- 32-bit read memory data
        mem_data_o      : out std_logic_vector(31 downto 0)     -- 32-bit write memory data
    );
end component;    
    
signal clk             : std_logic := '0';
signal rst             : std_logic := '1';
signal instr_addr      : std_logic_vector(31 downto 0);    -- 32-bit instruction address
signal instr_data      : std_logic_vector(31 downto 0);    -- 32-bit instruction data
signal mem_we          : std_logic;                        -- Active-high memory write strobe ('1' performs mem_data write to memory at address mem_addr_o)
signal mem_addr        : std_logic_vector(31 downto 0);    -- 32-bit memory address
signal mem_data_in     : std_logic_vector(31 downto 0);    -- 32-bit read memory data
signal mem_data_out    : std_logic_vector(31 downto 0);

constant MEMORY_SIZE    : integer := 32;
constant CLK_PERIOD     : time := 10 ns;

constant SIM_STOP_PC    : std_logic_vector(31 downto 0) := X"00000018";     -- decimal 24
constant MEM_CHECK_ADDR : integer                       := 16#40#;          -- decimal 64
constant EXPECTED_RESULT: std_logic_vector(31 downto 0) := X"00000031";     -- decimal 49

type memory_type is array (0 to MEMORY_SIZE-1) of std_logic_vector(31 downto 0);

function ToInt(v : std_logic_vector) return integer is
begin
    return to_integer(unsigned(v));
end function;

signal memory : memory_type := (
    X"04002083",    -- lw   x1, 64(x0)
    X"07b08113",    -- addi x2, x1, 123
    X"03310193",    -- addi x3, x2, 51
    X"03f1f193",    -- andi x3, x3, 63
    X"04302023",    -- sw   x3, 64(x0)
    X"00000013",    -- addi x0, x0, 0
    X"00000000",    -- <<execution will end here, PC=24 (hex 18)>>
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000003",    -- <<address 64 (hex 40) for data>>
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000"
);

begin

-- Unit under test instance
cpu : RV32
    port map (
        clk_i           => clk,
        rst_i           => rst,
        
        instr_addr_o    => instr_addr,
        instr_data_i    => instr_data,
        
        mem_we_o        => mem_we,         
        mem_addr_o      => mem_addr,
        mem_data_i      => mem_data_in,
        mem_data_o      => mem_data_out
    );

-- Clock and reset generation
clk <= not clk after CLK_PERIOD/2;
rst <= '0' after CLK_PERIOD*10;

-- Read and write data from memory bus
DATA_MEM : process(rst, mem_we, mem_addr, mem_data_out)
begin
    if rst = '0' then
        assert mem_addr < MEMORY_SIZE*4 report "Data address is to large or undefined!" severity failure;
        
        mem_data_in <= memory(ToInt(mem_addr)/4);
        
        if (mem_we = '1') then
            memory(ToInt(mem_addr)/4) <= mem_data_out;
        end if;
    end if;
end process;


process(rst, instr_addr)
begin
    -- Read data for instruction bus
    instr_data <= memory(ToInt(instr_addr)/4);

    if rst = '0' then
        -- Check simulation stop condition
        assert instr_addr < MEMORY_SIZE*4 report "Instruction address is to large or undefined!" severity failure;
        
        if instr_addr = SIM_STOP_PC then
            if memory(MEM_CHECK_ADDR/4) = EXPECTED_RESULT then
                report "Stopping simulation: correct result found!" severity failure;
            else
                report "Stopping simulation: incorrect result, please fix your code and try again!" severity failure;
            end if;
        end if;
    end if;
end process;

end arch;
