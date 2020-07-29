-- test vectors and taken from here
-- https://www.youtube.com/watch?v=iwj8ZgyzqZk
--library ieee;
--use ieee.std_logic_1164.all;
--library edc_lib;

--entity tb_crc_serial is
    --end entity tb_crc_serial;


--architecture tb of tb_crc_serial is

        ----constant polynomial : std_logic_vector(7 downto 0) := x"d5";
        --constant polynomial : std_logic_vector(4 downto 0) := (4 => '1', 2 => '1', others => '0');
        --signal clk      :  std_logic := '0';
        --signal rst      :  std_logic;
        --signal en       :  std_logic;
        --signal data     :  std_logic;
        --signal crc_out  :  std_logic_vector(polynomial'range);
        --signal crc_out_n  :  std_logic_vector(polynomial'range);
        --signal rev_crc_out  :  std_logic_vector(polynomial'range);
        --signal rev_crc_out_n  :  std_logic_vector(polynomial'range);
        --signal crc_valid  :  std_logic;
        --constant word : std_logic_vector(15 downto 0) := x"4834";
        ----constant word5 : std_logic_vector(11 downto 0) := B"1010011_00000";
        --constant word5 : std_logic_vector(11 downto 0) := B"1010011_11101";
        --function reverse_any_vector (a: in std_logic_vector)
        --return std_logic_vector is
            --variable result: std_logic_vector(a'RANGE);
            --alias aa: std_logic_vector(a'REVERSE_RANGE) is a;
        --begin
            --for i in aa'RANGE loop
                --result(i) := aa(i);
            --end loop;
            --return result;
        --end; -- function reverse_any_vector

--begin

    --rst <= '1', '0' after 120 ns;
    --clk <= not clk after 10 ns;

    --uut : entity edc_lib.crc_serial
    --generic map
    --(
        --polynomial => polynomial
    --)
    --port map
    --(
        --clk      => clk,
        --rst      => rst, 
        --en       => en,
        --data     => data,
        --crc_out  => crc_out,
        --crc_valid => crc_valid
    --);
    --crc_out_n <= not crc_out;
    --rev_crc_out <= reverse_any_vector(crc_out);
    --rev_crc_out_n <= not rev_crc_out;

    --stim : process
    --begin
        --en <= '0';
        --data <= '0';
        --wait until rst = '0';
        --wait until rising_edge(clk);
        --wait until rising_edge(clk);
        --wait until rising_edge(clk);
        --for i in word5'range loop
            --data <= word5(i);
            --en   <= '1';
            --wait until rising_edge(clk);
        --end loop;
        --en <= '0';
        --report "What is my crc?";
        --wait until rising_edge(clk);
        --wait until rising_edge(clk);
        --wait until rising_edge(clk);
        --report "" severity failure;
    --end process;

--end architecture;
library ieee;
use ieee.std_logic_1164.all;
library edc_lib;

entity tb_crc_serial is
    end entity tb_crc_serial;


architecture tb of tb_crc_serial is

        -- USB CRC x^5 + x^2+ 1
        constant polynomial : std_logic_vector(4 downto 0) := (2 => '1', others => '0');
        signal clk      :  std_logic := '0';
        signal rst      :  std_logic;
        signal en       :  std_logic;
        signal data     :  std_logic;
        signal crc_out  :  std_logic_vector(polynomial'range);
        signal crc_out_n  :  std_logic_vector(polynomial'range);
        signal rev_crc_out  :  std_logic_vector(polynomial'range);
        signal rev_crc_out_n  :  std_logic_vector(polynomial'range);
        signal crc_valid  :  std_logic;
        constant word : std_logic_vector(15 downto 0) := x"4834";
        --constant word5 : std_logic_vector(11 downto 0) := B"1010011_00000";
        constant word5 : std_logic_vector(11 downto 0) := B"1010011_11101";
        constant word4 : std_logic_vector(8 downto 0) := B"1000_00000";
        function reverse_any_vector (a: in std_logic_vector)
        return std_logic_vector is
            variable result: std_logic_vector(a'RANGE);
            alias aa: std_logic_vector(a'REVERSE_RANGE) is a;
        begin
            for i in aa'RANGE loop
                result(i) := aa(i);
            end loop;
            return result;
        end; -- function reverse_any_vector

begin

    rst <= '1', '0' after 120 ns;
    clk <= not clk after 10 ns;

    uut : entity edc_lib.crc_serial
    generic map
    (
        polynomial => polynomial
    )
    port map
    (
        clk      => clk,
        rst      => rst, 
        en       => en,
        data     => data,
        crc_out  => crc_out,
        crc_valid => crc_valid
    );
    crc_out_n <= not crc_out;
    rev_crc_out <= reverse_any_vector(crc_out);
    rev_crc_out_n <= not rev_crc_out;

    stim : process
    begin
        en <= '0';
        data <= '0';
        wait until rst = '0';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        for i in word4'range loop
            data <= word4(i);
            en   <= '1';
            wait until rising_edge(clk);
        end loop;
        en <= '0';
        report "What is my crc?";
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        report "" severity failure;
    end process;

end architecture;
