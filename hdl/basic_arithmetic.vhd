library IEEE;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity basic_arithmetic is
    generic (
    N : integer :=4
    );
port (
    in1  : in std_logic_vector(N-1 downto 0);
    in2  : in std_logic_vector(N-1 downto 0);
    clk  : in std_logic;
    reset: in std_logic;
    sel  : in std_logic_vector(2 downto 0);
    start: in STD_LOGIC;
    outs: out std_logic_vector(N downto 0);
    ready:  out std_logic
);
end basic_arithmetic;

architecture ALU of basic_arithmetic is
signal start_holder: std_logic;
signal start_rising_edge: std_logic;
begin
start_rising_edge <= (not start_holder) and start;
   process(clk,reset)
   begin
   if(reset ='0') then
      outs<= (others => '0');
      start_holder <= '0';
      ready <= '0';
   elsif(rising_edge(clk)) then
        ready <= '0';
        start_holder <= start;
        if start_rising_edge= '1' then
        ready <= '1';
        case sel is when  "000" => outs <= outs+1;
                     when  "001" => outs <= outs-1;
                     when  "010" => outs <= ('0' & in1)+('0' & in2);            
                     when  "011" => outs <= ('0' & in1)-('0' & in2); 
                     when  "100" => outs <= '0'& outs(N downto 1); 
                     when  "101" => outs <= "00" & outs(N downto 2); 
                     when  "110" => outs <= outs(N-1 downto 0)&'0';
                     when  "111" => outs <= outs(N-2 downto 0)&"00";
                     when others => outs <= outs;
          end case;
       end if;
      end if;
   end process;
end ALU;