library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity color_generator is

    Port ( 
           clock_divided : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           h_pos : in  integer;
           v_pos : in  integer;
			  colors : out  STD_LOGIC_VECTOR (7 downto 0));  
end color_generator;

architecture generate_colors of color_generator is

SIGNAL count : std_logic_vector (7 downto 0):="00000000";

constant  HD: integer := 639;  --H. Display
constant  VD: integer:=479;    --V. Display

BEGIN
my_colors: PROCESS(clock_divided, reset,h_pos,v_pos)
BEGIN
IF ((h_pos>HD) or (v_pos>VD) or (reset='1') ) THEN
	count <= (others => '0');
elsif(clock_divided'event and clock_divided='1') then
		count <= count + "00000001";
end if;
END PROCESS my_colors; 
colors <= count; 
END generate_colors ;


