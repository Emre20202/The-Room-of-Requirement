library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity main_circuit is
generic(
    N                 : integer := 4;
    num_of_bits       : integer := 8;
    stop_num_of_ticks : integer := 16;
    N_for_divisor     : integer := 11;
    dvsr              : std_logic_vector := "00000010101"
);
port (
   clk, reset   : in std_logic;
            inp : in std_logic;
        tx_done : out std_logic;
           outp : out std_logic
);
end main_circuit;
architecture arch_main_circuit of main_circuit is
signal rx_done, start, ready       : std_logic;
signal rx_signal                   : std_logic_vector(num_of_bits-1 downto 0);
signal sel                         : std_logic_vector(2 downto 0);
signal in1, in2                    : std_logic_vector (N-1 downto 0);
signal out_alu                     : std_logic_vector (N downto 0);
signal reset_n                     : std_logic;
begin

    reset_n <= not(reset);


     my_uart_entity : entity work.UART(str_arch)
     generic map(DBIT => num_of_bits, SB_TICK=>stop_num_of_ticks, N_for_divisor=>N_for_divisor)
     port map(
     clk                 => clk,
     reset               => reset_n,
     dvsr                => dvsr, 
     rx                  => inp,
     tx_start            => ready,
     data_in             => "000"&out_alu,
     rx_data_out         => rx_signal,
     rx_done_tick        => rx_done,
     tx_done_tick        => tx_done,
     tx                  => outp
     );
     
     my_ALU : entity work.basic_arithmetic(ALU)
     generic map(N => N)
     port map(
          in1 => in1,
          in2 => in2,
          clk => clk,
        reset => reset_n,
          sel => sel,
        start => start,
         outs => out_alu,
        ready => ready
     );
    
     my_main_logic_unit : entity work.main_logic(architecture_main_logic)
     generic map(N => N,num_of_bits => num_of_bits, stop_num_of_ticks=>stop_num_of_ticks)
     port map(
        clk => clk,
        reset => reset_n,
      rx_done => rx_done,
       rx_out => rx_signal,
          in1 => in1,
          in2 => in2,
          sel => sel,
        start_logic => start
     );

end arch_main_circuit;