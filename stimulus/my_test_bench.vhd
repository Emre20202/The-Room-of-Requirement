library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;

entity my_test_bench is
generic(
    N_for_divisor      : integer := 11; 
    DBIT               : integer := 8; --#data bits
    SB_TICK            : integer := 16; --#ticks for stop bits
    dvsr_binary        : std_logic_vector(10 downto 0) := "00000010101"
 );
end my_test_bench;

architecture behavioral of my_test_bench is

    constant SYSCLK_PERIOD : time := 25 ns; 
    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '1';
    signal data_in_start : std_logic := '0';
    signal data_inp : std_logic_vector(DBIT-1 DOWNTO 0);
    signal test_out : std_logic_vector(DBIT-1 DOWNTO 0);
    signal tx_of_uart, rx_of_uart : std_logic;
    signal tx_done : std_logic;

    component main_circuit
        -- ports
        port( 
            -- Inputs
            clk : in std_logic;
            reset : in std_logic;
            dvsr : in std_logic_vector(10 downto 0);
            inp : in std_logic;

            -- Outputs
            tx_done : out std_logic;
            outp : out std_logic


        );
    end component;

 begin   
    my_uart : entity work.UART(str_arch)
    generic map(DBIT => DBIT, SB_TICK=>SB_TICK, N_for_divisor=>N_for_divisor)
    port map(
     clk                 => SYSCLK,
     reset               => NSYSRESET,
     dvsr                => dvsr_binary, 
     rx                  => rx_of_uart,
     tx_start            => data_in_start,
     data_in             => data_inp,
     rx_data_out         => test_out,
     rx_done_tick        => open,
     tx_done_tick        => tx_done,
     tx                  => tx_of_uart
     );


    process
        variable vhdl_initial : BOOLEAN := TRUE;
        
    begin
        if ( vhdl_initial ) then
            -- Assert Reset
            NSYSRESET <= '0';
            wait for ( SYSCLK_PERIOD * 10 );
            
            NSYSRESET <= '1';
            wait;
        end if;
    end process;

    -- Clock Driver
    SYSCLK <= not SYSCLK after (SYSCLK_PERIOD / 2.0 );

    -- Instantiate Unit Under Test:  main_circuit
    main_circuit_0 : main_circuit
        -- port map
        port map( 
            -- Inputs
            clk => SYSCLK,
            reset => not NSYSRESET,
            dvsr => dvsr_binary,
            inp => tx_of_uart,

            -- Outputs
            tx_done =>  open,
            outp =>  rx_of_uart


        );
       -- process
      --  variable vhdl_initial : BOOLEAN := TRUE;

       -- begin
       -- my_loop_start: for i in 0 to 100 loop
       -- if ( vhdl_initial ) then
            -- Assert Reset
         -- data_in_start <= '0';
         --   wait for ( SYSCLK_PERIOD * 1 );
            
          
         --   wait for 10*SYSCLK_PERIOD;  
        --end if;
       -- wait for SYSCLK_PERIOD;
       -- end loop my_loop_start;
       -- end process;

        process
        --variable seed1, seed2: positive;              
        --variable rand: real;   
        --variable range_of_rand : real := 7.0; 
        --variable rand_num : integer;
        --variable rand_bin : std_logic_vector(7 downto 0);
        variable num_of_tx_done : integer := 0;

        begin
        wait until NSYSRESET = '1';
 
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(80,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
 
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(1,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
  
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(6,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
    
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(80,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
    
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(2,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;

        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(4,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
   
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(80,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
 
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(3,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
       
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(2,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;

        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(80,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
 
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(4,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
     

        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(80,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
        
     
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(2,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
       
   
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(3,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
       

        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(80,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
        

        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(4,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;

        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(80,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
      
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(3,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
       
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(1,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
         
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(80,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;

        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(4,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;

        
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(80,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
      
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(3,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
       
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(0,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
         
        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(80,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;

        wait until (falling_edge(sysclk));
        data_in_start <= '1';
        data_inp <= std_logic_vector(to_unsigned(4,8));
        wait for sysclk_period;
        data_in_start <= '0';
        wait for 100 us;
        --if (tx_done = '1') then
        --  num_of_tx_done := num_of_tx_done +1;
        --end if;
        --wait until num_of_tx_done = 1;
           --data_in_start <= '0';
--        my_loop_uart: for k in 1 to 4 loop
           --data_inp <= x"50";
           --WAIT FOR ;
           --data_inp <= std_logic_vector(to_unsigned(k,8));
           --Wait for ;
           --uniform(seed1, seed2, rand);  
           --rand_num := integer(rand*range_of_rand); 
           --rand_bin := std_logic_vector(to_unsigned(rand_num, 8));
           --data_inp <= rand_bin;
           --wait for ;
           --
        --end loop my_loop_uart;
        
        assert false;
        report " Simulation Completed "
        severity failure ;
        
        end process;
end behavioral;

