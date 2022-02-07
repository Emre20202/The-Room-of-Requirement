
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity segment_creator is
    Port ( binary_coded : in  STD_LOGIC_VECTOR (3 downto 0);
           seven_bit_output : out  STD_LOGIC_VECTOR (6 downto 0));
end segment_creator;

architecture dataflow of segment_creator is

begin
with binary_coded select  
 seven_bit_output <="1110111" when "0000", 
 "1000100" when "0001", 
 "0111110" when "0010", 
 "1101110" when "0011", 
 "1001101" when "0100", 
 "1101011" when "0101", 
 "1111011" when "0110", 
 "1000110" when "0111", 
 "1111111" when "1000", 
 "1101111" when "1001", 
 "1111111" when others; 
end dataflow;

