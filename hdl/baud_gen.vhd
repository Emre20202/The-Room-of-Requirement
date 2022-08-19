library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity baud_gen is
   generic(
    N_for_divisor : integer := 11
);
   port(
    clk: in std_logic;
    reset: in std_logic;
    dvsr: in std_logic_vector ( N_for_divisor-1 downto 0);
    tick: out std_logic
);
end baud_gen;
architecture arch of baud_gen is
    signal r_reg: unsigned(N_for_divisor-1 downto 0);
    signal r_next: unsigned(N_for_divisor-1 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '0' then 
            r_reg <= (others => '0');
        elsif rising_edge(clk) then
            r_reg <= r_next;
        end if;
    end process;
-- next state logic
   
r_next <= (others => '0') when r_reg = unsigned ( dvsr ) else r_reg + 1;
-- output logic
tick <= '1' when r_reg = 1 else '0'; -- not use 0 because of reset
end arch;
 