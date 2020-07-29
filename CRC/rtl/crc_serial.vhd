    --Find remainder of Data/polynomial
library ieee;
use ieee.std_logic_1164.all;

entity crc_serial is
    generic
    (
        polynomial : std_logic_vector
    );
    port 
    (
        clk        :  in  std_logic;
        rst        :  in  std_logic;
        en         :  in  std_logic;
        data       :  in  std_logic;
        crc_out    :  out std_logic_vector(polynomial'range);
        crc_valid  :  out std_logic
    );
end entity;

architecture rtl of crc_serial is

    signal reg : std_logic_vector(polynomial'length downto 0);
    signal fb  : std_logic;

begin

    fb <= crc_out(crc_out'left); -- feedback

    sr_proc : process(clk) is
    begin
        if rising_edge(clk) then
            if rst then
                crc_out   <=  (others => '0');
                reg       <=  (others => '0');
                crc_valid <=  '0';
            else 
                crc_valid <= '0';

                if en then

                    --                   _____             _____
                    --                  |     |           |     |
                    --           -------| reg | ---     --| reg | ----/.../fb
                    --          |       |_____|    |   |  |_____|
                    --          |                  |   |
                    --     .----------.         .----------.
                    --     | Assigner |         | Assigner |
                    --     |  logic   |         |  logic   |
                    --     '----------'         '----------'
                    for i in polynomial'range loop
                        L_assigner : if i /= 0 then
                            if polynomial(i)='1' then
                                crc_out(i) <= crc_out(i-1) xor fb;
                            else
                                crc_out(i) <= crc_out(i-1);
                            end if;
                        else
                            crc_out(i) <= data xor fb;
                        end if L_assigner;
                    end loop;
                    crc_valid <=  '1';

                end if;
            end if;
        end if;
    end process;


end architecture;
