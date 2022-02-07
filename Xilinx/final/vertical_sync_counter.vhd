----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:34:15 06/07/2021 
-- Design Name: 
-- Module Name:    vertical_sync_counter - Behavioral 
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

entity vertical_sync_counter is
    Port ( clk_divided : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           h_pos : inout  integer;
           v_pos : inout  integer;
           v_sync : out  STD_LOGIC);
end vertical_sync_counter;

architecture Behavioral of vertical_sync_counter is
constant  HD: integer := 639; -- 639  Horizontal Display
constant  HFP : integer :=16; -- Front Porch
constant  HSP : integer := 96; -- Sync Pulse
constant  HBP: integer:= 48; -- Back Porch

constant VD: integer:=479; -- Vertical Display
constant VFP: integer:=10; -- Front Porch
constant VSP: integer:=2; -- Sync Pulse
constant VBP: integer:=29; -- Back Porch
signal v_position : integer:=0;
begin
vertical_position_counter : process(clk_divided,reset,h_pos)
begin 
	if(reset='1') then
		v_position<= 0;
	elsif(clk_divided'event and clk_divided='1') then
		if(h_pos = HD+HFP+HSP+HBP) then
			if(v_position= VD+VFP+VSP+VBP) then
				v_position <= 0;
			else
				v_position<=v_position+1;
			end if;
		end if;
	end if;	
end process;


vertical_sycn:process(clk_divided,reset,v_position)
begin
	if(reset='1') then
		v_sync<= '0';
	elsif(clk_divided'event and clk_divided='1') then
		if((v_position<=(VD+VFP)) or (v_position> VD+VFP+VSP)) then
			v_sync <='1';
		else
			v_sync <='0';
		end if;
	end if;	
end process;
v_pos<=v_position;
end Behavioral;

