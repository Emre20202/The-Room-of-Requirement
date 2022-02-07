
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity integertobinary is
    Port ( integer_input : in  integer;
           binary_output : out  STD_LOGIC_VECTOR (3 downto 0));
end integertobinary;

architecture Behavioral of integertobinary is

begin
with integer_input select  
 binary_output <="0000" when 0, 
 "0001" when 1, 
 "0010" when 2, 
 "0011" when 3, 
 "0100" when 4, 
 "0101" when 5, 
 "0110" when 6, 
 "0111" when 7, 
 "1000" when 8, 
 "1001" when 9, 
 "XXXX" when others; 
end Behavioral;

