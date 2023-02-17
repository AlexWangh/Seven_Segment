library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab2_top is port (
   clkin_50			: in	std_logic;
	pb_n				: in	std_logic_vector(3 downto 0);
 	sw   				: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds				: out std_logic_vector(7 downto 0); -- for displaying the switch content
   seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  	: out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  	: out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab2_top;

architecture SimpleCircuit of LogicalStep_Lab2_top is
--
-- Components Used ---
------------------------------------------------------------------- 
  component SevenSegment port (
   hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
   ); 
   end component;
	
	component segment7_mux port (
			clk		: in std_logic := '0';
			DIN2     : in std_logic_vector (6 downto 0);
			DIN1     : in std_logic_vector (6 downto 0);
			DOUT     : out std_logic_vector (6 downto 0);
			DIG2     : out std_logic;
			DIG1     : out std_logic
	);
	end component;
	
	component pb_inverters port (
		pb_n 	: in std_logic_vector (3 downto 0);
		pb		: out std_logic_vector (3 downto 0)

	);
	end component;
	
	component logic_mux port (
		logic_in0					: in std_logic_vector (3 downto 0);
		logic_in1					: in std_logic_vector (3 downto 0);
		logic_select				: in std_logic_vector (1 downto 0);
		logic_out					: out std_logic_vector (3 downto 0)

	);
	end component;
	
	component full_adder_4bit port (
	
		input_a						: in std_logic_vector (3 downto 0);
		input_b						: in std_logic_vector (3 downto 0);
		carry_in4bit				: in std_logic; 
		full_adder_carry_output4: out std_logic;
		full_adder_sum_output4	: out std_logic_vector (3 downto 0)
	
	);
	end component;
	
	component mux port (
	
		mux_inp1 	: in std_logic_vector (3 downto 0);
		mux_inp2 	: in std_logic_vector (3 downto 0);
		mux_select  : in std_logic;
		mux_out     : out std_logic_vector (3 downto 0)
	
	);
	end component;
	
-- Create any signals, or temporary variables to be used
--
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR
--
	signal seg7_A	: std_logic_vector(6 downto 0);
	signal seg7_B  : std_logic_vector(6 downto 0);
	
	signal hex_A	: std_logic_vector(3 downto 0);
	signal hex_B   : std_logic_vector(3 downto 0);
	
	signal pb      : std_logic_vector(3 downto 0);
	
	signal carried : std_logic;
	signal sum     : std_logic_vector(3 downto 0);
	
	signal sig_c   : std_logic_vector(3 downto 0);
	
	signal mux_out1: std_logic_vector(3 downto 0);
	signal mux_out2: std_logic_vector(3 downto 0);
	
-- Here the circuit begins

begin

	hex_A <= sw(3 downto 0);
	hex_B <= sw(7 downto 4);
	
	INST1: pb_inverters port map(pb_n, pb);
	
	INST2: logic_mux port map(hex_A, hex_B, pb (1 downto 0), leds (3 downto 0));
	
	INST3: full_adder_4bit port map(hex_A, hex_B, '0', carried, sum);
	
	sig_c <=  "000" & carried;
	
	INST4: mux port map(hex_A, sum, pb(2), mux_out1);
	INST5: mux port map(hex_B, sig_c, pb(2), mux_out2);
	
	INST6: SevenSegment port map(mux_out1, seg7_A);
	INST7: SevenSegment port map(mux_out2, seg7_B);
	
	INST8: segment7_mux port map(clkin_50, seg7_A, seg7_B, seg7_data (6 downto 0), seg7_char2, seg7_char1);
	
end SimpleCircuit;

