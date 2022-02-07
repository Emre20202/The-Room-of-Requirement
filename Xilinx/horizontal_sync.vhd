library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity horizontal_sync is
 Port(clock_divided: in std_logic;
      reset:         in std_logic;
		HSYNC:         out std_logic;
		newline:       out std_logic;
		h_position:     inout integer);
end horizontal_sync;

architecture Behavioral of horizontal_sync is
constant  HD: integer := 639; --H. Display
constant  HFP : integer :=16; --H. Front Porch
constant  HSP : integer := 96; --H. Sync Pulse
constant  HBP: integer:= 48; --H. Back Porch

signal position: integer :=0;
begin

process1: process (clock_divided, reset)
begin
   if(reset='1') then
		position<= 0;
		
	elsif(clock_divided'event and clock_divided='1') then
		if(position= HD+HFP+HSP+HBP) then
			position <= 0;
			newline <= '1';
		else
			position<=position+1;
			newline <= '0';
		end if;
	end if;	
end process;

h_position <= position;

process2: process (clock_divided, reset, position)
begin
   if(reset='1') then
		HSYNC<= '0';
	elsif(clock_divided'event and clock_divided='1') then
		if((position<(HD+HFP)) or (position>=HD+HFP+HSP)) then
			HSYNC <='1';
		else
			HSYNC <='0';
		end if;
	end if;	
end process;

end Behavioral;

