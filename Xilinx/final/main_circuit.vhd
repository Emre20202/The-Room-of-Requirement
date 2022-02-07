
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_circuit is
Port( EppAstb: in std_logic;    --I-o EXPANSÝON                                           -- Address strobe
      EppDstb: in std_logic;      --I-o EXPANSÝON                                          -- Data strobe
      EppWr : in std_logic;          --I-o EXPANSÝON                                       -- Port write signal
      EppDB : inout std_logic_vector(7 downto 0); -- port data bus --I-o EXPANSÝON  
      EppWait: out std_logic; --I-o EXPANSÝON  
----------------------------------------------------------------------------------------
		clock : in std_logic;
      reset_all : inout std_logic;
		color_change : inout std_logic;
		mode_change  : inout std_logic;
		continue_stop: inout std_logic;
		reset:         inout std_logic;
		right:         inout std_logic;
		up:            inout std_logic;
		HSYNC:         out std_logic;
		VSYNC:         out std_logic;
		colors:        out std_logic_vector(7 downto 0));
end main_circuit;

architecture Behavioral of main_circuit is
---------------------------------------------------------------------------------
component IOExpansion
            Port(
     -- Epp-like bus signals
                   EppAstb: in std_logic;                                               -- Address strobe
                   EppDstb: in std_logic;                                               -- Data strobe
                   EppWr : in std_logic;                                               -- Port write signal
                   EppDB : inout std_logic_vector(7 downto 0); -- port data bus 
                   EppWait: out std_logic;                                             -- Port wait signal
     -- user extended signals
                   Led : in std_logic_vector(7 downto 0);                                                                 --    x01               8 virtual LEDs on the PC I/O Ex GUI
                   LBar : in std_logic_vector(23 downto 0);                                                              --            ..4 24 lights on the PC I/O Ex GUI light bar
                   Sw          : out std_logic_vector(15 downto 0);                                                        --              .6 16 switches, bottom row on the PC I/O Ex GUI
                   Btn : out std_logic_vector(15 downto 0);                                                                  -- ix07..8 16 Buttons, bottom row on the PC I/O Ex GUI 
                   dwOut: out std_logic_vector(31 downto 0); -- x09..b 32 Bits user output
                   dwIn : in std_logic_vector(31 downto 0)                                                                    --x0d..10 32 Bits user input
);   
 end component;

---------------------------------------------------------------------------------

component clock_generator 
   port(clock : in std_logic;
        mode_change:   in std_logic;
        continue_stop: in std_logic;
        reset:         in std_logic;
        right,up : in std_logic;
        dig_hour_1, dig_hour_2, dig_min_1, dig_min_2, dig_sec_1,dig_sec_2: out integer
);
end component;

component frequency_divider
   port( clock : in  STD_LOGIC;
         clock_divided : inout  STD_LOGIC);
end component;

component horizontal_sync_counter
   port( clk_divided : in  STD_LOGIC;
		   reset : in  STD_LOGIC;
		   h_pos : inout  integer;
		   h_sync: out STD_LOGIC);
end component;

component  vertical_sync_counter
    port(  clk_divided : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           h_pos : inout  integer;
           v_pos : inout  integer;
           v_sync : out  STD_LOGIC);
end component;

component integertobinary
    port(integer_input : in  integer;
         binary_output : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

component colorgenerator
   port(  clr_change : in  STD_LOGIC;
          red_out : inout  STD_LOGIC_VECTOR (2 downto 0):="000";
          blue_out : inout  STD_LOGIC_VECTOR (2 downto 0):="000";
          green_out : inout  STD_LOGIC_VECTOR (1 downto 0):="00");
end component;

component segment_creator
Port ( binary_coded : in  STD_LOGIC_VECTOR (3 downto 0);
       seven_bit_output : out  STD_LOGIC_VECTOR (6 downto 0));
end component;

component vga_displayer
Port (
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
end component;
signal clk_divided : std_logic;
signal d_h1,d_h2,d_m1,d_m2,d_s1,d_s2 : integer;
signal d1_h1,d1_h2,d1_m1,d1_m2,d1_s1,d1_s2 : std_logic_vector(3 downto 0);
signal d2_h1,d2_h2,d2_m1,d2_m2,d2_s1,d2_s2 : std_logic_vector(6 downto 0);
signal red1,blue1 : std_logic_vector(2 downto 0);
signal green1 :std_logic_vector(1 downto 0);
signal h_pos1,v_pos1 :integer;

-----------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
signal        Led1:std_logic_vector(7  downto 0);         -- Ox01                     8      virtual LEDs on the PC I/O Ex GUI
signal        LBar1:std_logic_vector(23  downto 0);         -- 0x02..4                  24     lights on the PC I/O Ex GUI light bar
signal        Sw1:std_logic_vector(15 downto 0);         -- Ox05..6                  16     switches, bottom row on the PC I/O Ex GUI
signal        Btn1:std_logic_vector(15 downto 0);         -- 0x07..8                  16     Buttons, bottom row on the PC I/O Ex GUI
signal        dwBtwn:std_logic_vector(31 downto 0); 
---------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

begin

my_freq: frequency_divider port map(clock,clk_divided);
clock_gen: clock_generator port map(clock,mode_change,continue_stop,reset,right,up,d_h1,d_h2,d_m1,d_m2,d_s1,d_s2);
horsync:  horizontal_sync_counter port map(clk_divided,reset_all,h_pos1,HSYNC);
versync:  vertical_sync_counter port map(clk_divided,reset_all,h_pos1,v_pos1,VSYNC);
color_gen: colorgenerator port map(color_change,red1,blue1,green1);
conv1  :  integertobinary  port map(d_h1,d1_h1);
conv2  :  integertobinary  port map(d_h2,d1_h2);
conv3  :  integertobinary  port map(d_m1,d1_m1);
conv4  :  integertobinary  port map(d_m2,d1_m2);
conv5  :  integertobinary  port map(d_s1,d1_s1);
conv6  :  integertobinary  port map(d_s2,d1_s2);
segm1  :  segment_creator  port map(d1_h1,d2_h1);
segm2  :  segment_creator  port map(d1_h2,d2_h2);
segm3  :  segment_creator  port map(d1_m1,d2_m1);
segm4  :  segment_creator  port map(d1_m2,d2_m2);
segm5  :  segment_creator  port map(d1_s1,d2_s1);
segm6  :  segment_creator  port map(d1_s2,d2_s2);
disp   : vga_displayer port map(h_pos1,v_pos1,clk_divided,d2_h1,d2_h2,d2_m1,d2_m2,d2_s1,d2_s2,red1,blue1,green1,colors);
-----------------------------------------------------------------------
-----------------------------------------------------------------------
I0ex: IOExpansion port map(EppAstb=>EppAstb,         
           EppDstb=>EppDstb, 
            EppWr=>EppWr, 
            EppDB=>EppDB, 
            EppWait=>EppWait, 
            Led=>Led1, 
            LBar=>Lbar1,
            Sw=>Sw1,
            Btn=>Btn1, 
            dwOut=>dwBtwn, 
            dwIn=>dwBtwn);
				 reset<=Btn1(15);
				 reset_all<=Btn1(14);
				 up<=Btn1(13);
				 right<=Btn1(12);
				 continue_stop<=Btn1(11);
				 mode_change <=Btn1(10);
				 color_change <=Btn1(9);
--------------------------------------------------------------------------
--------------------------------------------------------------------------		


















end Behavioral;

