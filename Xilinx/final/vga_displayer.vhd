
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity vga_displayer is
Port(
     h_pos  : in integer range 0 to 639;
	  v_pos  : in integer range 0 to 479;
     clock_divided : in std_logic;
	  h_1    : in std_logic_vector(6 downto 0);
	  h_2    : in std_logic_vector(6 downto 0);
	  m_1    : in std_logic_vector(6 downto 0);
	  m_2    : in std_logic_vector(6 downto 0);
	  s_1    : in std_logic_vector(6 downto 0);
	  s_2    : in std_logic_vector(6 downto 0);
	  red    : in std_logic_vector(2 downto 0);
	  blue   : in std_logic_vector(2 downto 0);
	  green  : in std_logic_vector(1 downto 0);
	  colors : out std_logic_vector(7 downto 0)
);
end vga_displayer;

architecture Behavioral of vga_displayer is

type region is array (1 to 6) of std_logic_vector(6 downto 0);
signal digit_regions: region;

type shift is array (1 to 6) of integer range 0 to 640;
constant shift_hor: shift:=(0,96,208,304,416,512);

signal digit : integer range 1 to 6;
begin
digit_regions <= (h_1,h_2,m_1,m_2,s_1,s_2);

process(clock_divided) is
   begin
	if(rising_edge(clock_divided)) then
	   if(h_pos < 97 and v_pos < 240) then
		   digit <= 1;
	   elsif(h_pos<193 and v_pos < 240) then
		   digit <= 2;
	   elsif(h_pos<305 and v_pos < 240) then
		   digit <= 3;
	   elsif(h_pos<401 and v_pos < 240) then
		   digit <= 4;
		elsif(h_pos<513 and v_pos < 240) then
		   digit <= 5;
		elsif(h_pos<609 and v_pos < 240) then
		   digit <= 6;
		else
		   digit <= 1;
	   end if;
	end if;
end process;

process(clock_divided) is
   begin
	if(rising_edge(clock_divided)) then
	   if(h_pos < 640 and v_pos < 480) then
		   if(h_pos>16+shift_hor(digit) and h_pos < 32+shift_hor(digit)) and (v_pos > 48 and v_pos < 112) then
			   if(digit_regions(digit)(0) = '1') then
				   colors <= red&blue&green;
				elsif(digit_regions(digit)(0) = '0') then
				   colors <= "00000000";
	         end if;
			elsif(h_pos>32+shift_hor(digit) and h_pos < 80+shift_hor(digit)) and (v_pos > 32 and v_pos < 48) then	
			   if(digit_regions(digit)(1) = '1') then
				   colors <= red&blue&green;
			   elsif(digit_regions(digit)(1) = '0') then
				   colors <= "00000000";
				end if;
			elsif(h_pos>80+shift_hor(digit) and h_pos < 96+shift_hor(digit)) and (v_pos > 48 and v_pos < 112) then	
			   if(digit_regions(digit)(2) = '1') then
				   colors <= red&blue&green;
			   elsif(digit_regions(digit)(2) = '0') then
				   colors <= "00000000";
			   end if;
			elsif(h_pos>32+shift_hor(digit) and h_pos < 80+shift_hor(digit)) and (v_pos > 112 and v_pos < 128) then	
			   if(digit_regions(digit)(3) = '1') then
				   colors <= red&blue&green;
			   elsif(digit_regions(digit)(3) = '0') then
				   colors <= "00000000";
				end if;	
			elsif(h_pos>16+shift_hor(digit) and h_pos < 32+shift_hor(digit)) and (v_pos > 128 and v_pos < 192) then	
			   if(digit_regions(digit)(4) = '1') then
				   colors <= red&blue&green;
			   elsif(digit_regions(digit)(4) = '0') then
				   colors <= "00000000";
				end if;
			elsif(h_pos>32+shift_hor(digit) and h_pos < 80+shift_hor(digit)) and (v_pos > 192 and v_pos < 208) then	
			   if(digit_regions(digit)(5) = '1') then
				   colors <= red&blue&green;
			   elsif(digit_regions(digit)(5) = '0') then
				   colors <= "00000000";
				end if;
			elsif(h_pos>80+shift_hor(digit) and h_pos < 96+shift_hor(digit)) and (v_pos > 128 and v_pos < 192) then	
			   if(digit_regions(digit)(6) = '1') then
				   colors <= red&blue&green;
			   elsif(digit_regions(digit)(6) = '0') then
				   colors <= "00000000";
				end if;
			else
			   colors <="00000000";
			end if;
		end if;
	end if;
end process;
end Behavioral;

