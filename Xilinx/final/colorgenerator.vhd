----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:56:54 06/28/2021 
-- Design Name: 
-- Module Name:    colorgenerator - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity colorgenerator is
    Port ( clr_change : in  STD_LOGIC;
           red_out : inout  STD_LOGIC_VECTOR (2 downto 0):="000";
           blue_out : inout  STD_LOGIC_VECTOR (2 downto 0):="000";
           green_out : inout  STD_LOGIC_VECTOR (1 downto 0):="00");
end colorgenerator;

architecture Behavioral of colorgenerator is
begin

color_modes: process(clr_change)
begin
if(rising_edge(clr_change)) then
	if(red_out<"111") then
		red_out<=red_out+"001";
	else
		if(blue_out<"111") then
			blue_out<=blue_out+"001";
		else
			if(green_out<"11") then
				green_out<=green_out+"01";
			else
				red_out<="001";
				blue_out<="001";
				green_out<="01";
		   end if;
		end if;
	end if;
end if;
end process;
end Behavioral;

