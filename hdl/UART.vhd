library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity UART is 
generic(
    N_for_divisor      : integer := 11; 
    DBIT               : integer := 8; --#data bits
    SB_TICK            : integer := 16 --#ticks for stop bits
 );
port(
    clk,reset    : in std_logic;
    dvsr         : in std_logic_vector(N_for_divisor-1 downto 0);
    rx           : in std_logic;
    tx           : out std_logic;
    rx_done_tick : out std_logic;
    tx_done_tick : out std_logic;
    rx_data_out  : out std_logic_vector (DBIT -1 downto 0);
    data_in      : in std_logic_vector(DBIT-1 downto 0);
    tx_start     : in std_logic
);
end UART;
architecture str_arch of UART is
    signaL tick        : std_logic;

begin
    baud_gen_unit : entity work.baud_gen(arch)
    generic map( N_for_divisor => N_for_divisor)
    port map(
        clk   => clk, 
        reset => reset,
        dvsr  => dvsr,
        tick  => tick
    );
receiver_unit: entity work.uart_receiver(arch)
    generic map( DBIT => DBIT , SB_TICK => SB_TICK )
    port map(
        clk          => clk,
        reset        => reset,
        rx           => rx,
        s_tick       => tick,
        rx_done_tick => rx_done_tick ,
        dout         => rx_data_out
    );
transmitter_unit: entity work.transmitter(arch)
    generic map( DBIT => DBIT , SB_TICK => SB_TICK )
    port map(
        clk => clk ,
        reset => reset ,
        tx_start =>tx_start ,
        s_tick => tick ,
        din => data_in,
        tx_done_tick => tx_done_tick ,
        tx => tx
);
end str_arch;