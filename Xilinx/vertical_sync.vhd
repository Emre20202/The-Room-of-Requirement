library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vertical_sync is
 Port(clock_divided: in std_logic;
      reset:         in std_logic;
		vertical_pos:  inout integer;
		newline:       in std_logic;
		VSYNC:         out std_logic);
end vertical_sync;

architecture Behavioral of vertical_sync is
constant  HD: integer := 639;  --H. Display
constant  HSP : integer := 96; --H. Sync Pulse
constant  HFP : integer :=16;  --H. Front Porch
constant  HBP: integer:= 48;   --H. Back Porch
constant  VD: integer:=479;    --V. Display
constant  VSP: integer:=2;     --V. Sync Pulse
constant  VFP: integer:=10;    --V. Front Porch
constant  VBP: integer:=29;    --V. Back Porch
signal position : integer:=0;
begin
process1: process(clock_divided,reset,newline)
begin
if(reset='1') then
		position<= 0;
	elsif(clock_divided'event and clock_divided='1') then
		if(newline = '1') then
			if(position= VD+VFP+VSP+VBP) then
				position <= 0;
			else
				position<=position+1;
			end if;
		end if;
	end if;	
end process;

process2: process(clock_divided,reset,position)
begin
if(reset='1') then
		VSYNC<= '0';
	elsif(clock_divided'event and clock_divided='1') then
		if((position <(VD+VFP)) or (position >= VD+VFP+VSP)) then
			VSYNC <='1';
		else
			VSYNC <='0';
		end if;
	end if;	
end process;
vertical_pos<=position;

end Behavioral;

