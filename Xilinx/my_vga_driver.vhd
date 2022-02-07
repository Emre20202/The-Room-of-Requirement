library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity my_vga_driver is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC:='0';
           HSYNC : inout  STD_LOGIC;
           VSYNC : inout  STD_LOGIC;
           green: inout  STD_LOGIC_VECTOR (2 downto 0);
			  red : inout  STD_LOGIC_VECTOR (2 downto 0);
			  blue : inout  STD_LOGIC_VECTOR(1 downto 0));
end my_vga_driver;

architecture Behavioral of my_vga_driver is

component frequency_divider 
    Port ( clock : in  STD_LOGIC;
           clock_divided : inout  STD_LOGIC:='0');
end component;

component color_generator
    Port ( clock_divided : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           h_pos : in  integer;
           v_pos : in  integer;
			  colors : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

component horizontal_sync
    Port ( clock_divided: in std_logic;
           reset:         in std_logic;
		     HSYNC:         out std_logic;
	        newline :      out std_logic;
			  h_position:    inout integer);
end component;

component vertical_sync
   Port (  clock_divided: in std_logic;
           reset:         in std_logic;
		     vertical_pos:  inout integer;
		     newline:       in std_logic;
		     VSYNC:         out std_logic);
end component;

signal clk_divided : STD_LOGIC;
signal colors: STD_LOGIC_VECTOR(7 downto 0);
signal h_position: integer;
signal v_position: integer;
signal newline: std_logic;

begin
f1: frequency_divider  port map(clock,clk_divided);
sync1: horizontal_sync port map(clk_divided,reset,HSYNC,newline,h_position);
sync2: vertical_sync port map(clk_divided,reset,v_position,newline,VSYNC);
color: color_generator port map(clk_divided,reset,h_position,v_position,colors);

red <= colors(7 downto 5);
green <= colors(4 downto 2);
blue <= colors(1 downto 0);

end Behavioral;


