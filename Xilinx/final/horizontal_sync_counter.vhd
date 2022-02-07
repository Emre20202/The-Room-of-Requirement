----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:17:28 06/07/2021 
-- Design Name: 
-- Module Name:    horizontal_sync_counter - Behavioral 
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

entity horizontal_sync_counter is
    Port ( clk_divided : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           h_pos : inout  integer;
			  h_sync: out STD_LOGIC);
end horizontal_sync_counter;

architecture Behavioral of horizontal_sync_counter is
constant  HD: integer := 639; -- 639  Horizontal Display
constant  HFP : integer :=16; -- Front Porch
constant  HSP : integer := 96; -- Sync Pulse
constant  HBP: integer:= 48; -- Back Porch
signal h_position: integer:=0;
begin

horizontal_position_counter : process(clk_divided,reset,h_position)
begin 
	if(reset='1') then
		h_position<= 0;
	elsif(clk_divided'event and clk_divided='1') then
		if(h_position= HD+HFP+HSP+HBP) then
			h_position <= 0;
		else
			h_position<=h_position+1;
		end if;
	end if;	
end process;


horizontal_sycn:process(clk_divided,reset,h_position)
begin
	if(reset='1') then
		h_sync<= '0';
	elsif(clk_divided'event and clk_divided='1') then
		if((h_position<=(HD+HFP)) or (h_position> HD+HFP+HSP)) then
			h_sync <='1';
		else
			h_sync <='0';
		end if;
	end if;	
end process;
h_pos<=h_position;
end Behavioral;

