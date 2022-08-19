library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity main_logic is
generic(
    N                 : integer := 4;
    num_of_bits       : integer := 8;
    stop_num_of_ticks : integer := 16
);
port ( 
   clk, reset  : in std_logic;
   rx_done     : in std_logic;
   rx_out      : in std_logic_vector(num_of_bits-1 downto 0);
   in1, in2    : out std_logic_vector(N-1 downto 0);
   start_logic : out std_logic;
   sel         : out std_logic_vector(2 downto 0)
);
end main_logic;
architecture architecture_main_logic of main_logic is
type states is (idle_state, waiting_state, inp1_state, inp2_state, sel_state, start_state);
signal pres_state, next_state : states;
signal start_holder           : std_logic;
signal in1_holder,in2_holder  : std_logic_vector(N-1 downto 0);
signal sel_holder             : std_logic_vector(2 downto 0);

begin
    process(clk, reset)
    begin
       if (reset = '0') then
            pres_state <= idle_state;
            in1 <= (others => '0');
            in2 <= (others => '0');
            sel <= (others => '0');
            start_logic <= '0';
            

       elsif(rising_edge(clk)) then
           pres_state  <= next_state;
           start_logic <= start_holder;
           sel <= sel_holder;
           in1 <= in1_holder;
           in2 <= in2_holder;
       end if;
    end process;
    process(in1, in2, sel, rx_done,rx_out, pres_state, start_logic)
    begin
    --initializations:
    next_state <= pres_state;
    start_holder <= '0';
    sel_holder <= sel;
    in1_holder <= in1;
    in2_holder <= in2;

    if(rx_done = '1' or pres_state = start_state) then
       case pres_state is 
              when idle_state =>
                  if(rx_out = x"50") then
                      next_state <= waiting_state;
                  end if;
              when waiting_state =>
                  if(rx_out = x"01") then
                      next_state <= inp1_state;
                  elsif(rx_out = x"02") then
                      next_state <= inp2_state;
                  elsif(rx_out = x"03") then
                      next_state <= sel_state;
                  elsif(rx_out = x"04") then
                      next_state <= start_state;
                  else
                      next_state <= idle_state;
                  end if;
              when inp1_state =>
                  in1_holder <= rx_out(N-1 downto 0);
                  next_state <= idle_state;
              when inp2_state =>
                  in2_holder <= rx_out(N-1 downto 0);
                  next_state <= idle_state;
              when sel_state =>
                   sel_holder <= rx_out(2 downto 0);
                   next_state <= idle_state;
              when start_state =>
                   start_holder <= '1';
                   next_state <= idle_state; 
              when others =>
                   next_state <= idle_state;    
       end case;
    end if;
    end process;
     

end architecture_main_logic;