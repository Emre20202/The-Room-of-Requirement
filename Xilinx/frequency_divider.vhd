library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity frequency_divider is
port(Clock: in std_logic;
     Clock_divided: out std_logic ;
	  Reset: in std_logic);
end frequency_divider;

architecture Behavioral of frequency_divider is
    signal temp: STD_LOGIC := '0';
    signal counter : integer range 0 to 3 := 0;
begin
    process (Clock ,Reset) 
    begin
        if (Reset ='1') then
            counter <= 0;
				temp <= '0';
        elsif (Clock'event and Clock = '1') then
            if (counter = 3) then
                temp <= NOT(temp);
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    Clock_divided <= temp;

END behavioral;
