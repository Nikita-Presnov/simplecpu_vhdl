library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity RV32 is
  port (
    clk_i : in std_logic; -- Clock input
    rst_i : in std_logic; -- Active-high reset input
    instr_addr_o : out std_logic_vector(31 downto 0); -- 32-bit instruction address
    instr_data_i : in std_logic_vector(31 downto 0); -- 32-bit instruction data

    mem_we_o : out std_logic; -- Active-high memory write strobe
    mem_addr_o : out std_logic_vector(31 downto 0); -- 32-bit memory address 
    mem_data_i : in std_logic_vector(31 downto 0); -- 32-bit read memory data 
    mem_data_o : out std_logic_vector(31 downto 0) -- 32-bit write memory data
  );
  end;

architecture core of RV32 is
  function ToInt(v : std_logic_vector) return integer is
  begin
      return to_integer(unsigned(v));
  end function;

  signal instr_addr_buf : std_logic_vector(31 downto 0) := X"00000000";
  signal reg_deb : std_logic_vector(31 downto 0) := X"00000000";
  -- signal reg_x1 : std_logic_vector(31 downto 0);
  -- signal reg_x2 : std_logic_vector(31 downto 0);
  -- signal reg_x3 : std_logic_vector(31 downto 0);
  type registr_type is array (0 to 3) of std_logic_vector(31 downto 0);
  signal rex_x : registr_type :=(
    0 => X"00000000",
    1 => X"00000000",
    2 => X"00000000",
    3 => X"00000000"
  );
  signal debug : integer := 0;

begin
  -- process(rst_i)
  -- begin
  --   instr_addr_o <= X"00000000";
  -- end process;

  process(clk_i)
  begin
    if instr_data_i(1 downto 0) = "11" then -- if it is a command
      case instr_data_i(6 downto 2) is
        when "00100" => -- I-type
          case instr_data_i(14 downto 12) is
            when "000" => -- addi
              reg_deb <=
                rex_x(ToInt(instr_data_i(19 downto 15)))
                + instr_data_i(31 downto 20);
              rex_x(ToInt(instr_data_i(11 downto 7))) <=
                rex_x(ToInt(instr_data_i(19 downto 15)))
                + instr_data_i(31 downto 20);
            when "111" => -- andi
              rex_x(ToInt(instr_data_i(11 downto 7))) <=
                rex_x(ToInt(instr_data_i(19 downto 15)))
                and (instr_data_i(31 downto 20) + X"00000000");
              reg_deb <=
                rex_x(ToInt(instr_data_i(19 downto 15)))
                and (instr_data_i(31 downto 20) + X"00000000");
              -- rex_x(ToInt(instr_data_i(11 downto 7))) <= X"11111111";
              --  1000 0000 0000 0000 0000 0000 0000 0000
            when others =>
              null;
          end case;

        when "01000" => -- S-type, memory
          case instr_data_i(14 downto 12) is
            when "010" => -- sw
              mem_we_o <= '1';
              mem_addr_o <= 
                rex_x(ToInt(instr_data_i(19 downto 15)))
                + instr_data_i(31 downto 20);
              mem_data_o <= 
              rex_x(ToInt(instr_data_i(11 downto 7)));
              mem_we_o <= '0';
            when others =>
              null;
          end case;

        when "00000" => -- I-type, memory
          case instr_data_i(14 downto 12) is
            when "010" => -- lw
            mem_addr_o <=
              rex_x(ToInt(instr_data_i(19 downto 15)))
              + instr_data_i(31 downto 20);
            reg_deb <=
              mem_data_i;
            rex_x(ToInt(instr_data_i(11 downto 7))) <=
              mem_data_i;
            when others =>
              null;
            end case;
        when others =>
          null;
      end case; 
    end if;
    instr_addr_o <= instr_addr_buf;
    instr_addr_buf <= instr_addr_buf + 4;
    -- instr_addr_o <= instr_addr_o + 4;

  end process;
end core;