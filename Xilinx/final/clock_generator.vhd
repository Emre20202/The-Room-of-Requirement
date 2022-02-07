
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_generator is
Port(
 clock : in std_logic;
 mode_change:   in std_logic;
 continue_stop: in std_logic;
 reset:         in std_logic;
 right,up : in std_logic;
 dig_hour_1, dig_hour_2, dig_min_1, dig_min_2, dig_sec_1,dig_sec_2: out integer
);
end clock_generator;

architecture Behavioral of clock_generator is
signal current_pos : integer range 0 to 3 := 0;
signal current_mode: integer range 0 to 2 := 0;
signal up_old  :     std_logic := '0';
signal right_old  :  std_logic := '0';
signal second      : integer range 0 to 59:= 0;
signal minute      : integer range 0 to 59:= 0;
signal hour        : integer range 0 to 23:= 0;
signal second_dig1 : integer range 0 to 5:=0;
signal second_dig2 : integer range 0 to 9:=0;
signal minute_dig1 : integer range 0 to 5:=0;
signal minute_dig2 : integer range 0 to 9:=0;
signal hour_dig1   : integer range 0 to 2:=0;
signal hour_dig2   : integer range 0 to 3:=0;
signal clock_counter : integer range 0 to 100000000 :=0;
signal continue_stop_old  : std_logic :='0';
signal control     : std_logic :='0';
signal clock_divided : std_logic :='0';
signal x : std_logic;
signal chro_hd1,chro_md1,chro_sd1 : integer range 0 to 5;
signal chro_hd2,chro_md2,chro_sd2 : integer range 0 to 9;
signal time_hd1,time_md1,time_sd1 : integer range 0 to 5;
signal time_hd2,time_md2,time_sd2 : integer range 0 to 9;



signal mode_change_old: std_logic:='0';
--current_mode = 0 > digital clock
--current_mode = 1 > chronometer
--current_mode = 2 > timer

begin
up_down_process:process(clock)
variable mode: std_logic_vector(1 downto 0):="00";
begin
if(rising_edge(clock)) then
   up_old<=up;
	right_old <= right;
	mode_change_old <= mode_change;
	continue_stop_old<=continue_stop;
	if (continue_stop_old = '0' and continue_stop = '1')then
		 control <= not control;
   else
	    x <= '0';
	end if;
	
	if(mode_change_old='0' and mode_change='1') then
		if(mode="11") then
			mode:="00";
		else
			mode:=mode+"01";
		end if;
	if	(mode="00") then  
		if(control <= '1') then
			if(up_old = '0' and up='1')then
				 if(current_pos = 0) then
					 if(hour_dig1=2) then
					  hour_dig1<=0;
					  hour <= hour-20;
					 else
					  hour_dig1<=hour_dig1+1;
					  hour <= hour+10;
					 end if;
				 elsif(current_pos = 1) then
					 if(hour_dig2=3 and hour_dig1=2) then
					  hour_dig2<=0;
					  hour<=hour-3;
					 elsif (hour_dig2=9) then
						hour<=hour-9;
						hour_dig2<=0;
					 else
						hour_dig2<=hour_dig2+1;
						hour<=hour+1;
					 end if;
					elsif(current_pos=2) then
					 if(minute_dig1=5) then
						minute_dig1<=0;
						minute<=minute-50;
					 elsif(minute_dig1 <5) then
						minute_dig1<=minute_dig1+1;
						minute<=minute+10;
					 else 
					  x<= '0';
					 end if;
				 elsif(current_pos=3) then
					 if(minute_dig2=9) then
						minute_dig2<=0;
						minute<=minute-9;
					 elsif(minute_dig2 < 9) then
						minute_dig2<=minute_dig2+1;
						minute<=minute+1;
					 else
					 x<='0';
					 end if;
				 end if;
				 else
				 x <= '0';
			 end if;
			 if(right_old = '0' and right = '1') then 
				 if(current_pos=3) then
				  current_pos<=0;
				 else
					current_pos<=current_pos+1;
				 end if;
			 end if;
		 end if;
		 if(control='0') and (rising_edge(clock_divided))then
				if(second_dig2=9) then
					second_dig2<=0;
					if(second_dig1=5) then
						second_dig1<=0;
						if(minute_dig2=9) then
							minute_dig2<=0;
							if(minute_dig1=5) then
								minute_dig1<=0;
								if(hour_dig2=3 and hour_dig1=2) then
									hour_dig2<=0;
								elsif(hour_dig2=9) then
									hour_dig2<=0;
									hour_dig1<=hour_dig1+1;
								else 
									x<='0';
								end if;
							else
								minute_dig1<=minute_dig1+1;
							end if;
						else
							minute_dig2<=minute_dig2+1;
						end if;
					else 
						second_dig1<=second_dig1+1;
					end if;
				else
					second_dig2<=second_dig2+1;
			end if;
			else
			x<='0';
			end if;
	else
	x <='0';
	end if;
end if;
if (mode="01") and (rising_edge(clock_divided)) then
   if(reset='1')then 
	chro_sd1 <= 0;
	chro_sd2 <= 0;
	chro_md1 <= 0;
	chro_md2 <= 0;
	chro_hd1 <= 0;
	chro_hd2 <= 0;
	elsif(reset ='0' and control = '0') then
	      if(chro_sd2 = 9) then
					chro_sd2<=0;
					if(chro_sd1=5) then
						chro_sd1<=0;
						if(chro_md2=9) then
							chro_md2<=0;
							if(chro_md1=5) then
								chro_md1<=0;
								if(chro_hd2=3 and chro_hd1=2) then
									chro_hd2<=0;
								elsif(hour_dig2=9) then
									chro_hd2<=0;
									chro_hd1<=chro_hd1+1;
								else 
									x<='0';
								end if;
							else
								chro_md1<=chro_md1+1;
							end if;
						else
							chro_md2<=chro_md2+1;
						end if;
					else 
						chro_sd1<=chro_sd1+1;
					end if;
			 else
	       chro_sd2<=chro_sd2+1;
	       end if;
		end if;
		
	if (mode = "10")then
      if(control = '1') then
			if(up_old = '0' and up='1')then
				 if(current_pos = 0) then
					 if(time_hd1=2) then
					  time_hd1<=0;
					 else
					  time_hd1<=time_hd1+1;
					 end if;
				 elsif(current_pos = 1) then
					 if(time_hd2=3 and time_hd1=2) then
					  time_hd2<=0;
					 elsif (time_hd2=9) then
						time_hd2<=0;
					 else
						time_hd2<=time_hd2+1;
					 end if;
					elsif(current_pos=2) then
					 if(time_md1=5) then
						time_md1<=0;
					 else
						time_md1 <= time_md1+1;
					 end if;
				 elsif(current_pos=3) then
					 if(time_md2=9) then
						time_md2<=0;
					 else
						time_md2<=time_md2+1;
					 end if;
				 end if;
			 end if;
			 if(right_old = '0' and right = '1') then 
				 if(current_pos=3) then
				  current_pos<=0;
				 else
					current_pos<=current_pos+1;
				 end if;
			 end if;
		elsif ((control = '0')and (rising_edge(clock_divided))) then
		    if(time_sd2 = 0) then
			    if(time_sd1 = 0) then
				    if(time_md2 = 0) then
					    if(time_md1 = 0) then
							   if (time_hd2 = 0) then
								    if(time_hd1 = 0) then
									    control <= '1';
									 else
									    time_hd1 <= time_hd1 -1;
										 time_hd2 <= 9;
										 time_md1 <= 5;
										 time_md2 <= 9;
										 time_sd1 <= 5;
										 time_sd2 <= 9;
									 end if;
								else
								   time_hd2 <= time_hd2-1;
									time_md1 <= 5;
									time_md2 <= 9;
									time_sd1 <= 5;
									time_sd2 <= 9;
							   end if;
						  end if;
						else
						    time_md1 <= time_md1-1;
							 time_md2 <= 9;
							 time_sd1 <= 5;
							 time_sd2 <= 9;
						end if;
					else
					   time_md2 <= time_md2-1;
						time_sd1<=5;
						time_sd2<=9;
				   end if;
				else
				   time_sd1 <= time_sd1-1;
					time_sd2 <= 9;
				end if;
			 else
			   time_sd2<=time_sd2-1;
			 end if;			  
		end if;
  end if;
  end if;
end process;

count:process(clock)
begin
    if(rising_edge(clock)) then
    clock_counter<=clock_counter+1;
	 if(clock_counter = 50000000) then
	    clock_counter <= 0;
	    clock_divided <= not clock_divided;
	 end if;
	 else
	 x<= '0';
    end if;
end process;
dig_hour_1<=hour_dig1;
dig_hour_2<=hour_dig2;
dig_min_1<=minute_dig1;
dig_min_2<=minute_dig2;
dig_sec_1<=second_dig1;
dig_sec_2<=second_dig2;
end Behavioral;

