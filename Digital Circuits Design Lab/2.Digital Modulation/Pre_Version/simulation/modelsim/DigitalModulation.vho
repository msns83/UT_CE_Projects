-- Copyright (C) 1991-2012 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 64-Bit"
-- VERSION "Version 12.1 Build 177 11/07/2012 SJ Web Edition"

-- DATE "11/29/2024 11:27:43"

-- 
-- Device: Altera EP2C20F484C7 Package FBGA484
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY CYCLONEII;
LIBRARY IEEE;
USE CYCLONEII.CYCLONEII_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	DigitalModulation IS
    PORT (
	\out\ : OUT std_logic;
	clk : IN std_logic;
	rst : IN std_logic;
	Mode : IN std_logic;
	send : IN std_logic;
	init : IN std_logic;
	SW : IN std_logic_vector(2 DOWNTO 0);
	write : IN std_logic;
	Msg : IN std_logic_vector(4 DOWNTO 0);
	full_LED : OUT std_logic;
	empty_LED : OUT std_logic;
	valid : OUT std_logic
	);
END DigitalModulation;

-- Design Ports Information
-- out	=>  Location: PIN_A13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- full_LED	=>  Location: PIN_U22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- empty_LED	=>  Location: PIN_R20,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- valid	=>  Location: PIN_A14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- Mode	=>  Location: PIN_M1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- clk	=>  Location: PIN_L1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- rst	=>  Location: PIN_L2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- send	=>  Location: PIN_R21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- write	=>  Location: PIN_T22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- init	=>  Location: PIN_R22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- SW[0]	=>  Location: PIN_U12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- SW[1]	=>  Location: PIN_U11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- SW[2]	=>  Location: PIN_M2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- Msg[4]	=>  Location: PIN_W12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- Msg[3]	=>  Location: PIN_V12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- Msg[2]	=>  Location: PIN_M22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- Msg[1]	=>  Location: PIN_L21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- Msg[0]	=>  Location: PIN_L22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default


ARCHITECTURE structure OF DigitalModulation IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL \ww_out\ : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_rst : std_logic;
SIGNAL ww_Mode : std_logic;
SIGNAL ww_send : std_logic;
SIGNAL ww_init : std_logic;
SIGNAL ww_SW : std_logic_vector(2 DOWNTO 0);
SIGNAL ww_write : std_logic;
SIGNAL ww_Msg : std_logic_vector(4 DOWNTO 0);
SIGNAL ww_full_LED : std_logic;
SIGNAL ww_empty_LED : std_logic;
SIGNAL ww_valid : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|ram_block3a0_PORTADATAIN_bus\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|ram_block3a0_PORTAADDR_bus\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|ram_block3a0_PORTBADDR_bus\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|ram_block3a0_PORTBDATAOUT_bus\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \inst4|OUT~clkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \rst~clkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \frq1|WideAnd0~clkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \clk~clkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \inst8|compl2|Add0~0_combout\ : std_logic;
SIGNAL \inst8|compl2|Add0~6_combout\ : std_logic;
SIGNAL \inst8|compl2|Add0~8_combout\ : std_logic;
SIGNAL \inst7|counter[1]~7_combout\ : std_logic;
SIGNAL \inst7|counter[4]~14\ : std_logic;
SIGNAL \inst7|counter[5]~15_combout\ : std_logic;
SIGNAL \inst7|counter[5]~16\ : std_logic;
SIGNAL \inst7|counter[6]~17_combout\ : std_logic;
SIGNAL \inst7|counter[6]~18\ : std_logic;
SIGNAL \inst7|counter[7]~19_combout\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[4]~18_combout\ : std_logic;
SIGNAL \frq2|cnt[0]~9_combout\ : std_logic;
SIGNAL \frq2|cnt[0]~10\ : std_logic;
SIGNAL \frq2|cnt[1]~11_combout\ : std_logic;
SIGNAL \frq2|cnt[1]~12\ : std_logic;
SIGNAL \frq2|cnt[2]~13_combout\ : std_logic;
SIGNAL \frq2|cnt[2]~14\ : std_logic;
SIGNAL \frq2|cnt[3]~15_combout\ : std_logic;
SIGNAL \frq2|cnt[3]~16\ : std_logic;
SIGNAL \frq2|cnt[4]~17_combout\ : std_logic;
SIGNAL \frq2|cnt[4]~18\ : std_logic;
SIGNAL \frq2|cnt[5]~19_combout\ : std_logic;
SIGNAL \frq2|cnt[5]~20\ : std_logic;
SIGNAL \frq2|cnt[6]~21_combout\ : std_logic;
SIGNAL \frq2|cnt[6]~22\ : std_logic;
SIGNAL \frq2|cnt[7]~23_combout\ : std_logic;
SIGNAL \frq2|cnt[7]~24\ : std_logic;
SIGNAL \frq2|cnt[8]~25_combout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita0~combout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita0~COUT\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita1~combout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita1~COUT\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita2~combout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita0~combout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita0~COUT\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita1~combout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita1~COUT\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita2~combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~1_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~4_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~11_combout\ : std_logic;
SIGNAL \inst9|OUT[4]~7_combout\ : std_logic;
SIGNAL \inst9|OUT[4]~8_combout\ : std_logic;
SIGNAL \inst9|OUT[3]~9_combout\ : std_logic;
SIGNAL \inst9|OUT[3]~10_combout\ : std_logic;
SIGNAL \inst9|OUT[0]~15_combout\ : std_logic;
SIGNAL \inst9|OUT[0]~16_combout\ : std_logic;
SIGNAL \inst6|MSG_REG|register~0_combout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|valid_wreq~combout\ : std_logic;
SIGNAL \inst6|SineCounter|Add0~0_combout\ : std_logic;
SIGNAL \inst6|SineCounter|Add0~1_combout\ : std_logic;
SIGNAL \frq2|WideAnd0~0_combout\ : std_logic;
SIGNAL \frq2|WideAnd0~1_combout\ : std_logic;
SIGNAL \frq2|WideAnd0~2_combout\ : std_logic;
SIGNAL \inst4|OUT~combout\ : std_logic;
SIGNAL \inst6|MSG_REG|register~2_combout\ : std_logic;
SIGNAL \frq2|always0~0_combout\ : std_logic;
SIGNAL \inst6|MSG_REG|register~3_combout\ : std_logic;
SIGNAL \inst6|MSG_REG|register~4_combout\ : std_logic;
SIGNAL \inst6|MSG_REG|register~5_combout\ : std_logic;
SIGNAL \inst6|MSG_REG|register~6_combout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|valid_rreq~combout\ : std_logic;
SIGNAL \inst6|MSG_REG|register~7_combout\ : std_logic;
SIGNAL \inst6|MSG_REG|register~8_combout\ : std_logic;
SIGNAL \inst6|MSG_REG|register~9_combout\ : std_logic;
SIGNAL \inst6|SineCounter|cnt[0]~5_combout\ : std_logic;
SIGNAL \init~combout\ : std_logic;
SIGNAL \inst4|OUT~clkctrl_outclk\ : std_logic;
SIGNAL \clk~combout\ : std_logic;
SIGNAL \clk~clkctrl_outclk\ : std_logic;
SIGNAL \inst8|PA|UC1|count[0]~15_combout\ : std_logic;
SIGNAL \rst~combout\ : std_logic;
SIGNAL \rst~clkctrl_outclk\ : std_logic;
SIGNAL \inst8|PA|UC1|count[1]~6\ : std_logic;
SIGNAL \inst8|PA|UC1|count[2]~7_combout\ : std_logic;
SIGNAL \inst8|PA|UC1|count[2]~8\ : std_logic;
SIGNAL \inst8|PA|UC1|count[3]~10\ : std_logic;
SIGNAL \inst8|PA|UC1|count[4]~11_combout\ : std_logic;
SIGNAL \inst8|PA|UC1|count[4]~12\ : std_logic;
SIGNAL \inst8|PA|UC1|count[5]~13_combout\ : std_logic;
SIGNAL \inst8|PA|UC1|count[3]~9_combout\ : std_logic;
SIGNAL \inst8|PA|UC1|count[1]~5_combout\ : std_logic;
SIGNAL \inst8|PA|UC1|Equal0~0_combout\ : std_logic;
SIGNAL \inst8|PA|UC1|Equal0~1_combout\ : std_logic;
SIGNAL \inst8|PA|UC1|cout~regout\ : std_logic;
SIGNAL \inst8|PA|ps.D~regout\ : std_logic;
SIGNAL \inst8|PA|ps.A~0_combout\ : std_logic;
SIGNAL \inst8|PA|ps.A~regout\ : std_logic;
SIGNAL \inst8|PA|ps.B~0_combout\ : std_logic;
SIGNAL \inst8|PA|ps.B~regout\ : std_logic;
SIGNAL \inst8|PA|ps.C~regout\ : std_logic;
SIGNAL \inst8|PA|phase~0_combout\ : std_logic;
SIGNAL \inst8|mux2_sel~0_combout\ : std_logic;
SIGNAL \inst8|mux2_sel~combout\ : std_logic;
SIGNAL \inst8|compl1|Add0~2_combout\ : std_logic;
SIGNAL \inst8|compl1|Add0~4\ : std_logic;
SIGNAL \inst8|compl1|Add0~6\ : std_logic;
SIGNAL \inst8|compl1|Add0~8\ : std_logic;
SIGNAL \inst8|compl1|Add0~10\ : std_logic;
SIGNAL \inst8|compl1|Add0~11_combout\ : std_logic;
SIGNAL \inst8|compl1|Add0~5_combout\ : std_logic;
SIGNAL \inst8|compl1|Add0~9_combout\ : std_logic;
SIGNAL \inst8|compl1|Add0~7_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~5_combout\ : std_logic;
SIGNAL \inst8|compl1|Add0~12\ : std_logic;
SIGNAL \inst8|compl1|Add0~13_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~6_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~7_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~8_combout\ : std_logic;
SIGNAL \inst8|compl1|Add0~3_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~9_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~10_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~12_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~13_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~14_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~15_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~16_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~17_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~18_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~19_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~20_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~21_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~22_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~27_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~23_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~25_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~24_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~26_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~28_combout\ : std_logic;
SIGNAL \inst8|compl2|Add0~1\ : std_logic;
SIGNAL \inst8|compl2|Add0~3\ : std_logic;
SIGNAL \inst8|compl2|Add0~5\ : std_logic;
SIGNAL \inst8|compl2|Add0~7\ : std_logic;
SIGNAL \inst8|compl2|Add0~9\ : std_logic;
SIGNAL \inst8|compl2|Add0~11\ : std_logic;
SIGNAL \inst8|compl2|Add0~13\ : std_logic;
SIGNAL \inst8|compl2|Add0~14_combout\ : std_logic;
SIGNAL \inst9|OUT[7]~1_combout\ : std_logic;
SIGNAL \Mode~combout\ : std_logic;
SIGNAL \inst9|OUT[6]~0_combout\ : std_logic;
SIGNAL \inst9|OUT[6]~2_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~0_combout\ : std_logic;
SIGNAL \inst9|OUT[6]~3_combout\ : std_logic;
SIGNAL \inst8|compl2|Add0~12_combout\ : std_logic;
SIGNAL \inst9|OUT[6]~4_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~2_combout\ : std_logic;
SIGNAL \inst8|sine_ROM|LUT~3_combout\ : std_logic;
SIGNAL \inst9|OUT[5]~5_combout\ : std_logic;
SIGNAL \inst8|compl2|Add0~10_combout\ : std_logic;
SIGNAL \inst9|OUT[5]~6_combout\ : std_logic;
SIGNAL \inst7|counter[0]~21_combout\ : std_logic;
SIGNAL \inst7|counter[1]~8\ : std_logic;
SIGNAL \inst7|counter[2]~9_combout\ : std_logic;
SIGNAL \inst7|counter[2]~10\ : std_logic;
SIGNAL \inst7|counter[3]~11_combout\ : std_logic;
SIGNAL \inst7|counter[3]~12\ : std_logic;
SIGNAL \inst7|counter[4]~13_combout\ : std_logic;
SIGNAL \inst9|OUT[2]~11_combout\ : std_logic;
SIGNAL \inst8|compl2|Add0~4_combout\ : std_logic;
SIGNAL \inst9|OUT[2]~12_combout\ : std_logic;
SIGNAL \inst9|OUT[1]~13_combout\ : std_logic;
SIGNAL \inst8|compl2|Add0~2_combout\ : std_logic;
SIGNAL \inst9|OUT[1]~14_combout\ : std_logic;
SIGNAL \inst7|LessThan0~1_cout\ : std_logic;
SIGNAL \inst7|LessThan0~3_cout\ : std_logic;
SIGNAL \inst7|LessThan0~5_cout\ : std_logic;
SIGNAL \inst7|LessThan0~7_cout\ : std_logic;
SIGNAL \inst7|LessThan0~9_cout\ : std_logic;
SIGNAL \inst7|LessThan0~11_cout\ : std_logic;
SIGNAL \inst7|LessThan0~13_cout\ : std_logic;
SIGNAL \inst7|LessThan0~14_combout\ : std_logic;
SIGNAL \inst7|pwm_out~regout\ : std_logic;
SIGNAL \write~combout\ : std_logic;
SIGNAL \inst11|Selector0~0_combout\ : std_logic;
SIGNAL \inst11|CS.A~regout\ : std_logic;
SIGNAL \inst11|NS.B~0_combout\ : std_logic;
SIGNAL \inst11|CS.B~regout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita0~combout\ : std_logic;
SIGNAL \send~combout\ : std_logic;
SIGNAL \inst1|Selector0~0_combout\ : std_logic;
SIGNAL \inst1|CS.A~regout\ : std_logic;
SIGNAL \inst1|NS.B~0_combout\ : std_logic;
SIGNAL \inst1|CS.B~regout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|fifo_state|_~0_combout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita0~COUT\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita1~combout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~0_combout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~1_combout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~regout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita1~COUT\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita2~combout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~0_combout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~1_combout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~regout\ : std_logic;
SIGNAL \frq1|cnt[0]~9_combout\ : std_logic;
SIGNAL \~GND~combout\ : std_logic;
SIGNAL \frq1|always0~0_combout\ : std_logic;
SIGNAL \frq1|cnt[0]~10\ : std_logic;
SIGNAL \frq1|cnt[1]~11_combout\ : std_logic;
SIGNAL \frq1|cnt[1]~12\ : std_logic;
SIGNAL \frq1|cnt[2]~14\ : std_logic;
SIGNAL \frq1|cnt[3]~15_combout\ : std_logic;
SIGNAL \frq1|cnt[3]~16\ : std_logic;
SIGNAL \frq1|cnt[4]~17_combout\ : std_logic;
SIGNAL \frq1|cnt[4]~18\ : std_logic;
SIGNAL \frq1|cnt[5]~19_combout\ : std_logic;
SIGNAL \frq1|cnt[5]~20\ : std_logic;
SIGNAL \frq1|cnt[6]~21_combout\ : std_logic;
SIGNAL \frq1|cnt[6]~22\ : std_logic;
SIGNAL \frq1|cnt[7]~23_combout\ : std_logic;
SIGNAL \frq1|cnt[7]~24\ : std_logic;
SIGNAL \frq1|cnt[8]~25_combout\ : std_logic;
SIGNAL \frq1|WideAnd0~1_combout\ : std_logic;
SIGNAL \frq1|cnt[2]~13_combout\ : std_logic;
SIGNAL \frq1|WideAnd0~0_combout\ : std_logic;
SIGNAL \frq1|WideAnd0~combout\ : std_logic;
SIGNAL \frq1|WideAnd0~clkctrl_outclk\ : std_logic;
SIGNAL \inst6|SineCounter|always0~0_combout\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[0]~11\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[1]~12_combout\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[8]~27\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[9]~28_combout\ : std_logic;
SIGNAL \inst6|SineMaker|Equal0~2_combout\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[2]~14_combout\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[3]~16_combout\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[0]~10_combout\ : std_logic;
SIGNAL \inst6|SineMaker|Equal0~0_combout\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[6]~22_combout\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[7]~24_combout\ : std_logic;
SIGNAL \inst6|SineMaker|Equal0~1_combout\ : std_logic;
SIGNAL \inst6|MSG_REG|register~1_combout\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[1]~13\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[2]~15\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[3]~17\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[4]~19\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[5]~20_combout\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[5]~21\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[6]~23\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[7]~25\ : std_logic;
SIGNAL \inst6|SineMaker|cnt[8]~26_combout\ : std_logic;
SIGNAL \inst6|SineMaker|Equal0~3_combout\ : std_logic;
SIGNAL \inst6|SineCounter|cnt[1]~4_combout\ : std_logic;
SIGNAL \inst6|SineCounter|cnt[2]~3_combout\ : std_logic;
SIGNAL \inst6|SineCounter|cnt[3]~2_combout\ : std_logic;
SIGNAL \inst6|SineCounter|Equal0~0_combout\ : std_logic;
SIGNAL \inst6|ns~0_combout\ : std_logic;
SIGNAL \inst6|ps~regout\ : std_logic;
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|safe_q\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \frq2|cnt\ : std_logic_vector(8 DOWNTO 0);
SIGNAL \inst7|counter\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \inst6|MSG_REG|register\ : std_logic_vector(8 DOWNTO 0);
SIGNAL \inst6|SineMaker|cnt\ : std_logic_vector(9 DOWNTO 0);
SIGNAL \inst6|SineCounter|cnt\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \frq1|cnt\ : std_logic_vector(8 DOWNTO 0);
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|q_b\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|safe_q\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \inst8|PA|UC1|count\ : std_logic_vector(5 DOWNTO 0);
SIGNAL \SW~combout\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \Msg~combout\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \inst|scfifo_component|auto_generated|dpfifo|fifo_state|ALT_INV_b_non_empty~regout\ : std_logic;

BEGIN

\out\ <= \ww_out\;
ww_clk <= clk;
ww_rst <= rst;
ww_Mode <= Mode;
ww_send <= send;
ww_init <= init;
ww_SW <= SW;
ww_write <= write;
ww_Msg <= Msg;
full_LED <= ww_full_LED;
empty_LED <= ww_empty_LED;
valid <= ww_valid;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|ram_block3a0_PORTADATAIN_bus\ <= (\Msg~combout\(4) & \Msg~combout\(3) & \Msg~combout\(2) & \Msg~combout\(1) & \Msg~combout\(0));

\inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|ram_block3a0_PORTAADDR_bus\ <= (\inst|scfifo_component|auto_generated|dpfifo|wr_ptr|safe_q\(2) & \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|safe_q\(1) & 
\inst|scfifo_component|auto_generated|dpfifo|wr_ptr|safe_q\(0));

\inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|ram_block3a0_PORTBADDR_bus\ <= (\inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|safe_q\(2) & \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|safe_q\(1) & 
\inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|safe_q\(0));

\inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|q_b\(0) <= \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|ram_block3a0_PORTBDATAOUT_bus\(0);
\inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|q_b\(1) <= \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|ram_block3a0_PORTBDATAOUT_bus\(1);
\inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|q_b\(2) <= \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|ram_block3a0_PORTBDATAOUT_bus\(2);
\inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|q_b\(3) <= \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|ram_block3a0_PORTBDATAOUT_bus\(3);
\inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|q_b\(4) <= \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|ram_block3a0_PORTBDATAOUT_bus\(4);

\inst4|OUT~clkctrl_INCLK_bus\ <= (gnd & gnd & gnd & \inst4|OUT~combout\);

\rst~clkctrl_INCLK_bus\ <= (gnd & gnd & gnd & \rst~combout\);

\frq1|WideAnd0~clkctrl_INCLK_bus\ <= (gnd & gnd & gnd & \frq1|WideAnd0~combout\);

\clk~clkctrl_INCLK_bus\ <= (gnd & gnd & gnd & \clk~combout\);
\inst|scfifo_component|auto_generated|dpfifo|fifo_state|ALT_INV_b_non_empty~regout\ <= NOT \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~regout\;

-- Location: LCFF_X31_Y20_N13
\inst7|counter[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst7|counter[7]~19_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst7|counter\(7));

-- Location: LCCOMB_X33_Y20_N0
\inst8|compl2|Add0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|compl2|Add0~0_combout\ = (((\inst8|mux2_sel~combout\ & !\inst8|sine_ROM|LUT~28_combout\)))
-- \inst8|compl2|Add0~1\ = CARRY((\inst8|mux2_sel~combout\ & !\inst8|sine_ROM|LUT~28_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110100100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|mux2_sel~combout\,
	datab => \inst8|sine_ROM|LUT~28_combout\,
	datad => VCC,
	combout => \inst8|compl2|Add0~0_combout\,
	cout => \inst8|compl2|Add0~1\);

-- Location: LCCOMB_X33_Y20_N6
\inst8|compl2|Add0~6\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|compl2|Add0~6_combout\ = (\inst8|compl2|Add0~5\ & (((\inst8|sine_ROM|LUT~10_combout\)) # (!\inst8|mux2_sel~combout\))) # (!\inst8|compl2|Add0~5\ & (((\inst8|mux2_sel~combout\ & !\inst8|sine_ROM|LUT~10_combout\)) # (GND)))
-- \inst8|compl2|Add0~7\ = CARRY(((\inst8|sine_ROM|LUT~10_combout\) # (!\inst8|compl2|Add0~5\)) # (!\inst8|mux2_sel~combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101001011011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|mux2_sel~combout\,
	datab => \inst8|sine_ROM|LUT~10_combout\,
	datad => VCC,
	cin => \inst8|compl2|Add0~5\,
	combout => \inst8|compl2|Add0~6_combout\,
	cout => \inst8|compl2|Add0~7\);

-- Location: LCCOMB_X33_Y20_N8
\inst8|compl2|Add0~8\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|compl2|Add0~8_combout\ = (\inst8|compl2|Add0~7\ & (\inst8|mux2_sel~combout\ & (!\inst8|sine_ROM|LUT~6_combout\ & VCC))) # (!\inst8|compl2|Add0~7\ & ((((\inst8|mux2_sel~combout\ & !\inst8|sine_ROM|LUT~6_combout\)))))
-- \inst8|compl2|Add0~9\ = CARRY((\inst8|mux2_sel~combout\ & (!\inst8|sine_ROM|LUT~6_combout\ & !\inst8|compl2|Add0~7\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010110100000010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|mux2_sel~combout\,
	datab => \inst8|sine_ROM|LUT~6_combout\,
	datad => VCC,
	cin => \inst8|compl2|Add0~7\,
	combout => \inst8|compl2|Add0~8_combout\,
	cout => \inst8|compl2|Add0~9\);

-- Location: LCFF_X31_Y20_N11
\inst7|counter[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst7|counter[6]~17_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst7|counter\(6));

-- Location: LCFF_X31_Y20_N9
\inst7|counter[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst7|counter[5]~15_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst7|counter\(5));

-- Location: LCFF_X31_Y20_N1
\inst7|counter[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst7|counter[1]~7_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst7|counter\(1));

-- Location: LCCOMB_X31_Y20_N0
\inst7|counter[1]~7\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst7|counter[1]~7_combout\ = (\inst7|counter\(1) & (\inst7|counter\(0) $ (VCC))) # (!\inst7|counter\(1) & (\inst7|counter\(0) & VCC))
-- \inst7|counter[1]~8\ = CARRY((\inst7|counter\(1) & \inst7|counter\(0)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110011010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst7|counter\(1),
	datab => \inst7|counter\(0),
	datad => VCC,
	combout => \inst7|counter[1]~7_combout\,
	cout => \inst7|counter[1]~8\);

-- Location: LCCOMB_X31_Y20_N6
\inst7|counter[4]~13\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst7|counter[4]~13_combout\ = (\inst7|counter\(4) & (!\inst7|counter[3]~12\)) # (!\inst7|counter\(4) & ((\inst7|counter[3]~12\) # (GND)))
-- \inst7|counter[4]~14\ = CARRY((!\inst7|counter[3]~12\) # (!\inst7|counter\(4)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst7|counter\(4),
	datad => VCC,
	cin => \inst7|counter[3]~12\,
	combout => \inst7|counter[4]~13_combout\,
	cout => \inst7|counter[4]~14\);

-- Location: LCCOMB_X31_Y20_N8
\inst7|counter[5]~15\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst7|counter[5]~15_combout\ = (\inst7|counter\(5) & (\inst7|counter[4]~14\ $ (GND))) # (!\inst7|counter\(5) & (!\inst7|counter[4]~14\ & VCC))
-- \inst7|counter[5]~16\ = CARRY((\inst7|counter\(5) & !\inst7|counter[4]~14\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \inst7|counter\(5),
	datad => VCC,
	cin => \inst7|counter[4]~14\,
	combout => \inst7|counter[5]~15_combout\,
	cout => \inst7|counter[5]~16\);

-- Location: LCCOMB_X31_Y20_N10
\inst7|counter[6]~17\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst7|counter[6]~17_combout\ = (\inst7|counter\(6) & (!\inst7|counter[5]~16\)) # (!\inst7|counter\(6) & ((\inst7|counter[5]~16\) # (GND)))
-- \inst7|counter[6]~18\ = CARRY((!\inst7|counter[5]~16\) # (!\inst7|counter\(6)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst7|counter\(6),
	datad => VCC,
	cin => \inst7|counter[5]~16\,
	combout => \inst7|counter[6]~17_combout\,
	cout => \inst7|counter[6]~18\);

-- Location: LCCOMB_X31_Y20_N12
\inst7|counter[7]~19\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst7|counter[7]~19_combout\ = \inst7|counter[6]~18\ $ (!\inst7|counter\(7))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => \inst7|counter\(7),
	cin => \inst7|counter[6]~18\,
	combout => \inst7|counter[7]~19_combout\);

-- Location: LCFF_X35_Y13_N19
\inst6|SineMaker|cnt[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|SineMaker|cnt[4]~18_combout\,
	aclr => \rst~clkctrl_outclk\,
	sclr => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|SineMaker|cnt\(4));

-- Location: LCFF_X27_Y10_N15
\frq2|cnt[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~combout\,
	datain => \frq2|cnt[0]~9_combout\,
	sdata => \~GND~combout\,
	aclr => \rst~clkctrl_outclk\,
	sload => \frq2|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq2|cnt\(0));

-- Location: LCFF_X27_Y10_N17
\frq2|cnt[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~combout\,
	datain => \frq2|cnt[1]~11_combout\,
	sdata => \~GND~combout\,
	aclr => \rst~clkctrl_outclk\,
	sload => \frq2|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq2|cnt\(1));

-- Location: LCFF_X27_Y10_N19
\frq2|cnt[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~combout\,
	datain => \frq2|cnt[2]~13_combout\,
	sdata => \~GND~combout\,
	aclr => \rst~clkctrl_outclk\,
	sload => \frq2|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq2|cnt\(2));

-- Location: LCFF_X27_Y10_N21
\frq2|cnt[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~combout\,
	datain => \frq2|cnt[3]~15_combout\,
	sdata => \~GND~combout\,
	aclr => \rst~clkctrl_outclk\,
	sload => \frq2|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq2|cnt\(3));

-- Location: LCFF_X27_Y10_N31
\frq2|cnt[8]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~combout\,
	datain => \frq2|cnt[8]~25_combout\,
	sdata => \~GND~combout\,
	aclr => \rst~clkctrl_outclk\,
	sload => \frq2|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq2|cnt\(8));

-- Location: LCFF_X27_Y10_N23
\frq2|cnt[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~combout\,
	datain => \frq2|cnt[4]~17_combout\,
	sdata => \~GND~combout\,
	aclr => \rst~clkctrl_outclk\,
	sload => \frq2|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq2|cnt\(4));

-- Location: LCFF_X27_Y10_N25
\frq2|cnt[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~combout\,
	datain => \frq2|cnt[5]~19_combout\,
	sdata => \SW~combout\(0),
	aclr => \rst~clkctrl_outclk\,
	sload => \frq2|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq2|cnt\(5));

-- Location: LCFF_X27_Y10_N27
\frq2|cnt[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~combout\,
	datain => \frq2|cnt[6]~21_combout\,
	sdata => \SW~combout\(1),
	aclr => \rst~clkctrl_outclk\,
	sload => \frq2|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq2|cnt\(6));

-- Location: LCFF_X27_Y10_N29
\frq2|cnt[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~combout\,
	datain => \frq2|cnt[7]~23_combout\,
	sdata => \SW~combout\(2),
	aclr => \rst~clkctrl_outclk\,
	sload => \frq2|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq2|cnt\(7));

-- Location: LCCOMB_X35_Y13_N18
\inst6|SineMaker|cnt[4]~18\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineMaker|cnt[4]~18_combout\ = (\inst6|SineMaker|cnt\(4) & (\inst6|SineMaker|cnt[3]~17\ $ (GND))) # (!\inst6|SineMaker|cnt\(4) & (!\inst6|SineMaker|cnt[3]~17\ & VCC))
-- \inst6|SineMaker|cnt[4]~19\ = CARRY((\inst6|SineMaker|cnt\(4) & !\inst6|SineMaker|cnt[3]~17\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|SineMaker|cnt\(4),
	datad => VCC,
	cin => \inst6|SineMaker|cnt[3]~17\,
	combout => \inst6|SineMaker|cnt[4]~18_combout\,
	cout => \inst6|SineMaker|cnt[4]~19\);

-- Location: LCCOMB_X27_Y10_N14
\frq2|cnt[0]~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq2|cnt[0]~9_combout\ = \frq2|cnt\(0) $ (VCC)
-- \frq2|cnt[0]~10\ = CARRY(\frq2|cnt\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \frq2|cnt\(0),
	datad => VCC,
	combout => \frq2|cnt[0]~9_combout\,
	cout => \frq2|cnt[0]~10\);

-- Location: LCCOMB_X27_Y10_N16
\frq2|cnt[1]~11\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq2|cnt[1]~11_combout\ = (\frq2|cnt\(1) & (!\frq2|cnt[0]~10\)) # (!\frq2|cnt\(1) & ((\frq2|cnt[0]~10\) # (GND)))
-- \frq2|cnt[1]~12\ = CARRY((!\frq2|cnt[0]~10\) # (!\frq2|cnt\(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \frq2|cnt\(1),
	datad => VCC,
	cin => \frq2|cnt[0]~10\,
	combout => \frq2|cnt[1]~11_combout\,
	cout => \frq2|cnt[1]~12\);

-- Location: LCCOMB_X27_Y10_N18
\frq2|cnt[2]~13\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq2|cnt[2]~13_combout\ = (\frq2|cnt\(2) & (\frq2|cnt[1]~12\ $ (GND))) # (!\frq2|cnt\(2) & (!\frq2|cnt[1]~12\ & VCC))
-- \frq2|cnt[2]~14\ = CARRY((\frq2|cnt\(2) & !\frq2|cnt[1]~12\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \frq2|cnt\(2),
	datad => VCC,
	cin => \frq2|cnt[1]~12\,
	combout => \frq2|cnt[2]~13_combout\,
	cout => \frq2|cnt[2]~14\);

-- Location: LCCOMB_X27_Y10_N20
\frq2|cnt[3]~15\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq2|cnt[3]~15_combout\ = (\frq2|cnt\(3) & (!\frq2|cnt[2]~14\)) # (!\frq2|cnt\(3) & ((\frq2|cnt[2]~14\) # (GND)))
-- \frq2|cnt[3]~16\ = CARRY((!\frq2|cnt[2]~14\) # (!\frq2|cnt\(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \frq2|cnt\(3),
	datad => VCC,
	cin => \frq2|cnt[2]~14\,
	combout => \frq2|cnt[3]~15_combout\,
	cout => \frq2|cnt[3]~16\);

-- Location: LCCOMB_X27_Y10_N22
\frq2|cnt[4]~17\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq2|cnt[4]~17_combout\ = (\frq2|cnt\(4) & (\frq2|cnt[3]~16\ $ (GND))) # (!\frq2|cnt\(4) & (!\frq2|cnt[3]~16\ & VCC))
-- \frq2|cnt[4]~18\ = CARRY((\frq2|cnt\(4) & !\frq2|cnt[3]~16\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \frq2|cnt\(4),
	datad => VCC,
	cin => \frq2|cnt[3]~16\,
	combout => \frq2|cnt[4]~17_combout\,
	cout => \frq2|cnt[4]~18\);

-- Location: LCCOMB_X27_Y10_N24
\frq2|cnt[5]~19\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq2|cnt[5]~19_combout\ = (\frq2|cnt\(5) & (!\frq2|cnt[4]~18\)) # (!\frq2|cnt\(5) & ((\frq2|cnt[4]~18\) # (GND)))
-- \frq2|cnt[5]~20\ = CARRY((!\frq2|cnt[4]~18\) # (!\frq2|cnt\(5)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \frq2|cnt\(5),
	datad => VCC,
	cin => \frq2|cnt[4]~18\,
	combout => \frq2|cnt[5]~19_combout\,
	cout => \frq2|cnt[5]~20\);

-- Location: LCCOMB_X27_Y10_N26
\frq2|cnt[6]~21\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq2|cnt[6]~21_combout\ = (\frq2|cnt\(6) & (\frq2|cnt[5]~20\ $ (GND))) # (!\frq2|cnt\(6) & (!\frq2|cnt[5]~20\ & VCC))
-- \frq2|cnt[6]~22\ = CARRY((\frq2|cnt\(6) & !\frq2|cnt[5]~20\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \frq2|cnt\(6),
	datad => VCC,
	cin => \frq2|cnt[5]~20\,
	combout => \frq2|cnt[6]~21_combout\,
	cout => \frq2|cnt[6]~22\);

-- Location: LCCOMB_X27_Y10_N28
\frq2|cnt[7]~23\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq2|cnt[7]~23_combout\ = (\frq2|cnt\(7) & (!\frq2|cnt[6]~22\)) # (!\frq2|cnt\(7) & ((\frq2|cnt[6]~22\) # (GND)))
-- \frq2|cnt[7]~24\ = CARRY((!\frq2|cnt[6]~22\) # (!\frq2|cnt\(7)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \frq2|cnt\(7),
	datad => VCC,
	cin => \frq2|cnt[6]~22\,
	combout => \frq2|cnt[7]~23_combout\,
	cout => \frq2|cnt[7]~24\);

-- Location: LCCOMB_X27_Y10_N30
\frq2|cnt[8]~25\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq2|cnt[8]~25_combout\ = \frq2|cnt[7]~24\ $ (!\frq2|cnt\(8))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => \frq2|cnt\(8),
	cin => \frq2|cnt[7]~24\,
	combout => \frq2|cnt[8]~25_combout\);

-- Location: LCFF_X43_Y13_N7
\inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_reg_bit4a[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita0~combout\,
	ena => \inst|scfifo_component|auto_generated|dpfifo|valid_wreq~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|safe_q\(0));

-- Location: LCFF_X43_Y13_N9
\inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_reg_bit4a[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita1~combout\,
	ena => \inst|scfifo_component|auto_generated|dpfifo|valid_wreq~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|safe_q\(1));

-- Location: LCFF_X43_Y13_N11
\inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_reg_bit4a[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita2~combout\,
	ena => \inst|scfifo_component|auto_generated|dpfifo|valid_wreq~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|safe_q\(2));

-- Location: LCFF_X43_Y13_N27
\inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_reg_bit4a[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita0~combout\,
	ena => \inst|scfifo_component|auto_generated|dpfifo|valid_rreq~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|safe_q\(0));

-- Location: LCFF_X43_Y13_N29
\inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_reg_bit4a[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita1~combout\,
	ena => \inst|scfifo_component|auto_generated|dpfifo|valid_rreq~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|safe_q\(1));

-- Location: LCFF_X43_Y13_N31
\inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_reg_bit4a[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita2~combout\,
	ena => \inst|scfifo_component|auto_generated|dpfifo|valid_rreq~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|safe_q\(2));

-- Location: LCCOMB_X43_Y13_N6
\inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita0~combout\ = \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|safe_q\(0) $ (VCC)
-- \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita0~COUT\ = CARRY(\inst|scfifo_component|auto_generated|dpfifo|wr_ptr|safe_q\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010110101010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|safe_q\(0),
	datad => VCC,
	combout => \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita0~combout\,
	cout => \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita0~COUT\);

-- Location: LCCOMB_X43_Y13_N8
\inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita1\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita1~combout\ = (\inst|scfifo_component|auto_generated|dpfifo|wr_ptr|safe_q\(1) & (!\inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita0~COUT\)) # 
-- (!\inst|scfifo_component|auto_generated|dpfifo|wr_ptr|safe_q\(1) & ((\inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita0~COUT\) # (GND)))
-- \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita1~COUT\ = CARRY((!\inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita0~COUT\) # (!\inst|scfifo_component|auto_generated|dpfifo|wr_ptr|safe_q\(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|safe_q\(1),
	datad => VCC,
	cin => \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita0~COUT\,
	combout => \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita1~combout\,
	cout => \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita1~COUT\);

-- Location: LCCOMB_X43_Y13_N10
\inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita2\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita2~combout\ = \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita1~COUT\ $ (!\inst|scfifo_component|auto_generated|dpfifo|wr_ptr|safe_q\(2))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|safe_q\(2),
	cin => \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita1~COUT\,
	combout => \inst|scfifo_component|auto_generated|dpfifo|wr_ptr|counter_comb_bita2~combout\);

-- Location: LCCOMB_X43_Y13_N26
\inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita0~combout\ = \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|safe_q\(0) $ (VCC)
-- \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita0~COUT\ = CARRY(\inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|safe_q\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|safe_q\(0),
	datad => VCC,
	combout => \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita0~combout\,
	cout => \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita0~COUT\);

-- Location: LCCOMB_X43_Y13_N28
\inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita1\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita1~combout\ = (\inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|safe_q\(1) & (!\inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita0~COUT\)) # 
-- (!\inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|safe_q\(1) & ((\inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita0~COUT\) # (GND)))
-- \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita1~COUT\ = CARRY((!\inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita0~COUT\) # (!\inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|safe_q\(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|safe_q\(1),
	datad => VCC,
	cin => \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita0~COUT\,
	combout => \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita1~combout\,
	cout => \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita1~COUT\);

-- Location: LCCOMB_X43_Y13_N30
\inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita2\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita2~combout\ = \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita1~COUT\ $ (!\inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|safe_q\(2))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|safe_q\(2),
	cin => \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita1~COUT\,
	combout => \inst|scfifo_component|auto_generated|dpfifo|rd_ptr_count|counter_comb_bita2~combout\);

-- Location: M4K_X41_Y13
\inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|ram_block3a0\ : cycloneii_ram_block
-- pragma translate_off
GENERIC MAP (
	data_interleave_offset_in_bits => 1,
	data_interleave_width_in_bits => 1,
	logical_ram_name => "fifo1:inst|scfifo:scfifo_component|scfifo_s931:auto_generated|a_dpfifo_3g31:dpfifo|dpram_ot01:FIFOram|altsyncram_orj1:altsyncram2|ALTSYNCRAM",
	mixed_port_feed_through_mode => "dont_care",
	operation_mode => "dual_port",
	port_a_address_clear => "none",
	port_a_address_width => 3,
	port_a_byte_enable_clear => "none",
	port_a_byte_enable_clock => "none",
	port_a_data_in_clear => "none",
	port_a_data_out_clear => "none",
	port_a_data_out_clock => "none",
	port_a_data_width => 5,
	port_a_first_address => 0,
	port_a_first_bit_number => 0,
	port_a_last_address => 7,
	port_a_logical_ram_depth => 8,
	port_a_logical_ram_width => 5,
	port_a_write_enable_clear => "none",
	port_b_address_clear => "none",
	port_b_address_clock => "clock1",
	port_b_address_width => 3,
	port_b_byte_enable_clear => "none",
	port_b_data_in_clear => "none",
	port_b_data_out_clear => "none",
	port_b_data_out_clock => "none",
	port_b_data_width => 5,
	port_b_first_address => 0,
	port_b_first_bit_number => 0,
	port_b_last_address => 7,
	port_b_logical_ram_depth => 8,
	port_b_logical_ram_width => 5,
	port_b_read_enable_write_enable_clear => "none",
	port_b_read_enable_write_enable_clock => "clock1",
	ram_block_type => "M4K",
	safe_write => "err_on_2clk")
-- pragma translate_on
PORT MAP (
	portawe => \inst|scfifo_component|auto_generated|dpfifo|valid_wreq~combout\,
	portbrewe => VCC,
	clk0 => \clk~clkctrl_outclk\,
	clk1 => \clk~clkctrl_outclk\,
	ena0 => \inst|scfifo_component|auto_generated|dpfifo|valid_wreq~combout\,
	ena1 => \inst|scfifo_component|auto_generated|dpfifo|valid_rreq~combout\,
	portadatain => \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|ram_block3a0_PORTADATAIN_bus\,
	portaaddr => \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|ram_block3a0_PORTAADDR_bus\,
	portbaddr => \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|ram_block3a0_PORTBADDR_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	portbdataout => \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|ram_block3a0_PORTBDATAOUT_bus\);

-- Location: LCCOMB_X34_Y20_N2
\inst8|sine_ROM|LUT~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~1_combout\ = (\inst8|sine_ROM|LUT~0_combout\) # (\inst8|compl1|Add0~13_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst8|sine_ROM|LUT~0_combout\,
	datad => \inst8|compl1|Add0~13_combout\,
	combout => \inst8|sine_ROM|LUT~1_combout\);

-- Location: LCCOMB_X34_Y20_N16
\inst8|sine_ROM|LUT~4\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~4_combout\ = (\inst8|compl1|Add0~5_combout\ & (((\inst8|compl1|Add0~3_combout\ & !\inst8|compl1|Add0~7_combout\)))) # (!\inst8|compl1|Add0~5_combout\ & (!\inst8|compl1|Add0~9_combout\ & ((\inst8|compl1|Add0~7_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~9_combout\,
	datab => \inst8|compl1|Add0~5_combout\,
	datac => \inst8|compl1|Add0~3_combout\,
	datad => \inst8|compl1|Add0~7_combout\,
	combout => \inst8|sine_ROM|LUT~4_combout\);

-- Location: LCCOMB_X33_Y21_N26
\inst8|sine_ROM|LUT~11\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~11_combout\ = (\inst8|compl1|Add0~7_combout\ & ((\inst8|compl1|Add0~11_combout\ $ (!\inst8|compl1|Add0~13_combout\)))) # (!\inst8|compl1|Add0~7_combout\ & (\inst8|compl1|Add0~11_combout\ & ((\inst8|compl1|Add0~13_combout\) # 
-- (!\inst8|compl1|Add0~3_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000011100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~3_combout\,
	datab => \inst8|compl1|Add0~7_combout\,
	datac => \inst8|compl1|Add0~11_combout\,
	datad => \inst8|compl1|Add0~13_combout\,
	combout => \inst8|sine_ROM|LUT~11_combout\);

-- Location: LCFF_X35_Y13_N1
\inst6|MSG_REG|register[8]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~combout\,
	datain => \inst6|MSG_REG|register~0_combout\,
	aclr => \rst~clkctrl_outclk\,
	ena => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|MSG_REG|register\(8));

-- Location: LCCOMB_X34_Y20_N20
\inst9|OUT[4]~7\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst9|OUT[4]~7_combout\ = (\inst9|OUT[6]~2_combout\ & ((\inst8|sine_ROM|LUT~6_combout\) # (!\inst8|mux2_sel~combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|mux2_sel~combout\,
	datac => \inst8|sine_ROM|LUT~6_combout\,
	datad => \inst9|OUT[6]~2_combout\,
	combout => \inst9|OUT[4]~7_combout\);

-- Location: LCCOMB_X32_Y20_N10
\inst9|OUT[4]~8\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst9|OUT[4]~8_combout\ = (\inst9|OUT[4]~7_combout\) # ((\inst9|OUT[6]~0_combout\ & \inst8|compl2|Add0~8_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst9|OUT[6]~0_combout\,
	datac => \inst8|compl2|Add0~8_combout\,
	datad => \inst9|OUT[4]~7_combout\,
	combout => \inst9|OUT[4]~8_combout\);

-- Location: LCCOMB_X33_Y20_N16
\inst9|OUT[3]~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst9|OUT[3]~9_combout\ = (\inst9|OUT[6]~2_combout\ & ((\inst8|sine_ROM|LUT~10_combout\) # (!\inst8|mux2_sel~combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|mux2_sel~combout\,
	datab => \inst9|OUT[6]~2_combout\,
	datad => \inst8|sine_ROM|LUT~10_combout\,
	combout => \inst9|OUT[3]~9_combout\);

-- Location: LCCOMB_X32_Y20_N28
\inst9|OUT[3]~10\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst9|OUT[3]~10_combout\ = (\inst9|OUT[3]~9_combout\) # ((\inst9|OUT[6]~0_combout\ & \inst8|compl2|Add0~6_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst9|OUT[6]~0_combout\,
	datac => \inst9|OUT[3]~9_combout\,
	datad => \inst8|compl2|Add0~6_combout\,
	combout => \inst9|OUT[3]~10_combout\);

-- Location: LCCOMB_X34_Y20_N22
\inst9|OUT[0]~15\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst9|OUT[0]~15_combout\ = (\inst9|OUT[6]~2_combout\ & ((\inst8|sine_ROM|LUT~28_combout\) # (!\inst8|mux2_sel~combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst9|OUT[6]~2_combout\,
	datac => \inst8|mux2_sel~combout\,
	datad => \inst8|sine_ROM|LUT~28_combout\,
	combout => \inst9|OUT[0]~15_combout\);

-- Location: LCCOMB_X32_Y20_N6
\inst9|OUT[0]~16\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst9|OUT[0]~16_combout\ = (\inst9|OUT[0]~15_combout\) # ((\inst9|OUT[6]~0_combout\ & \inst8|compl2|Add0~0_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst9|OUT[6]~0_combout\,
	datac => \inst8|compl2|Add0~0_combout\,
	datad => \inst9|OUT[0]~15_combout\,
	combout => \inst9|OUT[0]~16_combout\);

-- Location: LCFF_X40_Y13_N13
\inst6|SineCounter|cnt[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|SineCounter|cnt[0]~5_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|SineCounter|cnt\(0));

-- Location: LCFF_X36_Y13_N31
\inst6|MSG_REG|register[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|MSG_REG|register~2_combout\,
	aclr => \rst~clkctrl_outclk\,
	ena => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|MSG_REG|register\(7));

-- Location: LCCOMB_X35_Y13_N0
\inst6|MSG_REG|register~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|MSG_REG|register~0_combout\ = (\inst6|ps~regout\ & \inst6|MSG_REG|register\(7))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst6|ps~regout\,
	datad => \inst6|MSG_REG|register\(7),
	combout => \inst6|MSG_REG|register~0_combout\);

-- Location: LCCOMB_X42_Y13_N24
\inst|scfifo_component|auto_generated|dpfifo|valid_wreq\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst|scfifo_component|auto_generated|dpfifo|valid_wreq~combout\ = (\inst11|CS.B~regout\ & !\inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst11|CS.B~regout\,
	datad => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~regout\,
	combout => \inst|scfifo_component|auto_generated|dpfifo|valid_wreq~combout\);

-- Location: LCCOMB_X40_Y13_N24
\inst6|SineCounter|Add0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineCounter|Add0~0_combout\ = \inst6|SineCounter|cnt\(3) $ (((\inst6|SineCounter|cnt\(0) & (\inst6|SineCounter|cnt\(2) & \inst6|SineCounter|cnt\(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110110011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|SineCounter|cnt\(0),
	datab => \inst6|SineCounter|cnt\(3),
	datac => \inst6|SineCounter|cnt\(2),
	datad => \inst6|SineCounter|cnt\(1),
	combout => \inst6|SineCounter|Add0~0_combout\);

-- Location: LCCOMB_X40_Y13_N10
\inst6|SineCounter|Add0~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineCounter|Add0~1_combout\ = \inst6|SineCounter|cnt\(2) $ (((\inst6|SineCounter|cnt\(1) & \inst6|SineCounter|cnt\(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst6|SineCounter|cnt\(1),
	datac => \inst6|SineCounter|cnt\(2),
	datad => \inst6|SineCounter|cnt\(0),
	combout => \inst6|SineCounter|Add0~1_combout\);

-- Location: LCCOMB_X27_Y10_N12
\frq2|WideAnd0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq2|WideAnd0~0_combout\ = (\frq2|cnt\(1) & (\frq2|cnt\(0) & (\frq2|cnt\(3) & \frq2|cnt\(2))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \frq2|cnt\(1),
	datab => \frq2|cnt\(0),
	datac => \frq2|cnt\(3),
	datad => \frq2|cnt\(2),
	combout => \frq2|WideAnd0~0_combout\);

-- Location: LCCOMB_X27_Y10_N4
\frq2|WideAnd0~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq2|WideAnd0~1_combout\ = (\frq2|cnt\(6) & (\frq2|cnt\(7) & (\frq2|cnt\(5) & \frq2|cnt\(4))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \frq2|cnt\(6),
	datab => \frq2|cnt\(7),
	datac => \frq2|cnt\(5),
	datad => \frq2|cnt\(4),
	combout => \frq2|WideAnd0~1_combout\);

-- Location: LCCOMB_X27_Y10_N6
\frq2|WideAnd0~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq2|WideAnd0~2_combout\ = (\frq2|WideAnd0~0_combout\ & (\frq2|WideAnd0~1_combout\ & \frq2|cnt\(8)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \frq2|WideAnd0~0_combout\,
	datac => \frq2|WideAnd0~1_combout\,
	datad => \frq2|cnt\(8),
	combout => \frq2|WideAnd0~2_combout\);

-- Location: LCCOMB_X27_Y10_N10
\inst4|OUT\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst4|OUT~combout\ = LCELL((\inst6|MSG_REG|register\(8) & (\frq2|WideAnd0~2_combout\)) # (!\inst6|MSG_REG|register\(8) & ((\frq1|WideAnd0~combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010111110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \frq2|WideAnd0~2_combout\,
	datac => \inst6|MSG_REG|register\(8),
	datad => \frq1|WideAnd0~combout\,
	combout => \inst4|OUT~combout\);

-- Location: LCFF_X36_Y13_N13
\inst6|MSG_REG|register[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|MSG_REG|register~3_combout\,
	aclr => \rst~clkctrl_outclk\,
	ena => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|MSG_REG|register\(6));

-- Location: LCCOMB_X36_Y13_N30
\inst6|MSG_REG|register~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|MSG_REG|register~2_combout\ = (\inst6|MSG_REG|register\(6)) # (!\inst6|ps~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst6|ps~regout\,
	datad => \inst6|MSG_REG|register\(6),
	combout => \inst6|MSG_REG|register~2_combout\);

-- Location: LCCOMB_X27_Y10_N2
\frq2|always0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq2|always0~0_combout\ = ((\frq2|cnt\(8) & (\frq2|WideAnd0~1_combout\ & \frq2|WideAnd0~0_combout\))) # (!\init~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101010101010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \init~combout\,
	datab => \frq2|cnt\(8),
	datac => \frq2|WideAnd0~1_combout\,
	datad => \frq2|WideAnd0~0_combout\,
	combout => \frq2|always0~0_combout\);

-- Location: LCFF_X36_Y13_N11
\inst6|MSG_REG|register[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|MSG_REG|register~4_combout\,
	aclr => \rst~clkctrl_outclk\,
	ena => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|MSG_REG|register\(5));

-- Location: LCCOMB_X36_Y13_N12
\inst6|MSG_REG|register~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|MSG_REG|register~3_combout\ = (\inst6|ps~regout\ & \inst6|MSG_REG|register\(5))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst6|ps~regout\,
	datad => \inst6|MSG_REG|register\(5),
	combout => \inst6|MSG_REG|register~3_combout\);

-- Location: LCFF_X40_Y13_N21
\inst6|MSG_REG|register[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|MSG_REG|register~5_combout\,
	aclr => \rst~clkctrl_outclk\,
	ena => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|MSG_REG|register\(4));

-- Location: LCCOMB_X36_Y13_N10
\inst6|MSG_REG|register~4\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|MSG_REG|register~4_combout\ = (\inst6|MSG_REG|register\(4)) # (!\inst6|ps~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst6|ps~regout\,
	datad => \inst6|MSG_REG|register\(4),
	combout => \inst6|MSG_REG|register~4_combout\);

-- Location: LCFF_X40_Y13_N19
\inst6|MSG_REG|register[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|MSG_REG|register~6_combout\,
	aclr => \rst~clkctrl_outclk\,
	ena => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|MSG_REG|register\(3));

-- Location: LCCOMB_X40_Y13_N20
\inst6|MSG_REG|register~5\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|MSG_REG|register~5_combout\ = (\inst6|ps~regout\ & (\inst6|MSG_REG|register\(3))) # (!\inst6|ps~regout\ & ((\inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|q_b\(4))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst6|MSG_REG|register\(3),
	datac => \inst6|ps~regout\,
	datad => \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|q_b\(4),
	combout => \inst6|MSG_REG|register~5_combout\);

-- Location: LCFF_X40_Y13_N29
\inst6|MSG_REG|register[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|MSG_REG|register~7_combout\,
	aclr => \rst~clkctrl_outclk\,
	ena => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|MSG_REG|register\(2));

-- Location: LCCOMB_X40_Y13_N18
\inst6|MSG_REG|register~6\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|MSG_REG|register~6_combout\ = (\inst6|ps~regout\ & (\inst6|MSG_REG|register\(2))) # (!\inst6|ps~regout\ & ((\inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|q_b\(3))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst6|MSG_REG|register\(2),
	datac => \inst6|ps~regout\,
	datad => \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|q_b\(3),
	combout => \inst6|MSG_REG|register~6_combout\);

-- Location: LCCOMB_X42_Y13_N22
\inst|scfifo_component|auto_generated|dpfifo|valid_rreq\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst|scfifo_component|auto_generated|dpfifo|valid_rreq~combout\ = (\inst1|CS.B~regout\ & \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst1|CS.B~regout\,
	datad => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~regout\,
	combout => \inst|scfifo_component|auto_generated|dpfifo|valid_rreq~combout\);

-- Location: LCFF_X40_Y13_N23
\inst6|MSG_REG|register[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|MSG_REG|register~8_combout\,
	aclr => \rst~clkctrl_outclk\,
	ena => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|MSG_REG|register\(1));

-- Location: LCCOMB_X40_Y13_N28
\inst6|MSG_REG|register~7\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|MSG_REG|register~7_combout\ = (\inst6|ps~regout\ & (\inst6|MSG_REG|register\(1))) # (!\inst6|ps~regout\ & ((\inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|q_b\(2))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst6|MSG_REG|register\(1),
	datac => \inst6|ps~regout\,
	datad => \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|q_b\(2),
	combout => \inst6|MSG_REG|register~7_combout\);

-- Location: LCFF_X40_Y13_N9
\inst6|MSG_REG|register[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|MSG_REG|register~9_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|MSG_REG|register\(0));

-- Location: LCCOMB_X40_Y13_N22
\inst6|MSG_REG|register~8\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|MSG_REG|register~8_combout\ = (\inst6|ps~regout\ & (\inst6|MSG_REG|register\(0))) # (!\inst6|ps~regout\ & ((\inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|q_b\(1))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst6|MSG_REG|register\(0),
	datac => \inst6|ps~regout\,
	datad => \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|q_b\(1),
	combout => \inst6|MSG_REG|register~8_combout\);

-- Location: LCCOMB_X40_Y13_N8
\inst6|MSG_REG|register~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|MSG_REG|register~9_combout\ = (\inst6|ps~regout\ & (\inst6|SineMaker|Equal0~3_combout\ & (\inst6|MSG_REG|register\(0)))) # (!\inst6|ps~regout\ & (((\inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|q_b\(0)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011001110000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|SineMaker|Equal0~3_combout\,
	datab => \inst6|ps~regout\,
	datac => \inst6|MSG_REG|register\(0),
	datad => \inst|scfifo_component|auto_generated|dpfifo|FIFOram|altsyncram2|q_b\(0),
	combout => \inst6|MSG_REG|register~9_combout\);

-- Location: LCCOMB_X40_Y13_N12
\inst6|SineCounter|cnt[0]~5\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineCounter|cnt[0]~5_combout\ = (\inst6|ps~regout\ & (!\inst6|SineCounter|Equal0~0_combout\ & (\inst6|SineCounter|cnt\(0) $ (!\inst6|SineMaker|Equal0~3_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|ps~regout\,
	datab => \inst6|SineCounter|Equal0~0_combout\,
	datac => \inst6|SineCounter|cnt\(0),
	datad => \inst6|SineMaker|Equal0~3_combout\,
	combout => \inst6|SineCounter|cnt[0]~5_combout\);

-- Location: PIN_R22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\init~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_init,
	combout => \init~combout\);

-- Location: PIN_W12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\Msg[4]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_Msg(4),
	combout => \Msg~combout\(4));

-- Location: PIN_V12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\Msg[3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_Msg(3),
	combout => \Msg~combout\(3));

-- Location: PIN_M22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\Msg[2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_Msg(2),
	combout => \Msg~combout\(2));

-- Location: PIN_L21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\Msg[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_Msg(1),
	combout => \Msg~combout\(1));

-- Location: PIN_L22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\Msg[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_Msg(0),
	combout => \Msg~combout\(0));

-- Location: CLKCTRL_G12
\inst4|OUT~clkctrl\ : cycloneii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \inst4|OUT~clkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \inst4|OUT~clkctrl_outclk\);

-- Location: PIN_L1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\clk~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_clk,
	combout => \clk~combout\);

-- Location: CLKCTRL_G2
\clk~clkctrl\ : cycloneii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \clk~clkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \clk~clkctrl_outclk\);

-- Location: LCCOMB_X32_Y21_N28
\inst8|PA|UC1|count[0]~15\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|PA|UC1|count[0]~15_combout\ = !\inst8|PA|UC1|count\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst8|PA|UC1|count\(0),
	combout => \inst8|PA|UC1|count[0]~15_combout\);

-- Location: PIN_L2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\rst~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_rst,
	combout => \rst~combout\);

-- Location: CLKCTRL_G1
\rst~clkctrl\ : cycloneii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \rst~clkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \rst~clkctrl_outclk\);

-- Location: LCFF_X32_Y21_N29
\inst8|PA|UC1|count[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \inst4|OUT~clkctrl_outclk\,
	datain => \inst8|PA|UC1|count[0]~15_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst8|PA|UC1|count\(0));

-- Location: LCCOMB_X32_Y21_N12
\inst8|PA|UC1|count[1]~5\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|PA|UC1|count[1]~5_combout\ = (\inst8|PA|UC1|count\(1) & (\inst8|PA|UC1|count\(0) $ (VCC))) # (!\inst8|PA|UC1|count\(1) & (\inst8|PA|UC1|count\(0) & VCC))
-- \inst8|PA|UC1|count[1]~6\ = CARRY((\inst8|PA|UC1|count\(1) & \inst8|PA|UC1|count\(0)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110011010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|PA|UC1|count\(1),
	datab => \inst8|PA|UC1|count\(0),
	datad => VCC,
	combout => \inst8|PA|UC1|count[1]~5_combout\,
	cout => \inst8|PA|UC1|count[1]~6\);

-- Location: LCCOMB_X32_Y21_N14
\inst8|PA|UC1|count[2]~7\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|PA|UC1|count[2]~7_combout\ = (\inst8|PA|UC1|count\(2) & (!\inst8|PA|UC1|count[1]~6\)) # (!\inst8|PA|UC1|count\(2) & ((\inst8|PA|UC1|count[1]~6\) # (GND)))
-- \inst8|PA|UC1|count[2]~8\ = CARRY((!\inst8|PA|UC1|count[1]~6\) # (!\inst8|PA|UC1|count\(2)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \inst8|PA|UC1|count\(2),
	datad => VCC,
	cin => \inst8|PA|UC1|count[1]~6\,
	combout => \inst8|PA|UC1|count[2]~7_combout\,
	cout => \inst8|PA|UC1|count[2]~8\);

-- Location: LCFF_X32_Y21_N15
\inst8|PA|UC1|count[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \inst4|OUT~clkctrl_outclk\,
	datain => \inst8|PA|UC1|count[2]~7_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst8|PA|UC1|count\(2));

-- Location: LCCOMB_X32_Y21_N16
\inst8|PA|UC1|count[3]~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|PA|UC1|count[3]~9_combout\ = (\inst8|PA|UC1|count\(3) & (\inst8|PA|UC1|count[2]~8\ $ (GND))) # (!\inst8|PA|UC1|count\(3) & (!\inst8|PA|UC1|count[2]~8\ & VCC))
-- \inst8|PA|UC1|count[3]~10\ = CARRY((\inst8|PA|UC1|count\(3) & !\inst8|PA|UC1|count[2]~8\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|PA|UC1|count\(3),
	datad => VCC,
	cin => \inst8|PA|UC1|count[2]~8\,
	combout => \inst8|PA|UC1|count[3]~9_combout\,
	cout => \inst8|PA|UC1|count[3]~10\);

-- Location: LCCOMB_X32_Y21_N18
\inst8|PA|UC1|count[4]~11\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|PA|UC1|count[4]~11_combout\ = (\inst8|PA|UC1|count\(4) & (!\inst8|PA|UC1|count[3]~10\)) # (!\inst8|PA|UC1|count\(4) & ((\inst8|PA|UC1|count[3]~10\) # (GND)))
-- \inst8|PA|UC1|count[4]~12\ = CARRY((!\inst8|PA|UC1|count[3]~10\) # (!\inst8|PA|UC1|count\(4)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \inst8|PA|UC1|count\(4),
	datad => VCC,
	cin => \inst8|PA|UC1|count[3]~10\,
	combout => \inst8|PA|UC1|count[4]~11_combout\,
	cout => \inst8|PA|UC1|count[4]~12\);

-- Location: LCFF_X32_Y21_N19
\inst8|PA|UC1|count[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \inst4|OUT~clkctrl_outclk\,
	datain => \inst8|PA|UC1|count[4]~11_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst8|PA|UC1|count\(4));

-- Location: LCCOMB_X32_Y21_N20
\inst8|PA|UC1|count[5]~13\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|PA|UC1|count[5]~13_combout\ = \inst8|PA|UC1|count\(5) $ (!\inst8|PA|UC1|count[4]~12\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010110100101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|PA|UC1|count\(5),
	cin => \inst8|PA|UC1|count[4]~12\,
	combout => \inst8|PA|UC1|count[5]~13_combout\);

-- Location: LCFF_X32_Y21_N21
\inst8|PA|UC1|count[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \inst4|OUT~clkctrl_outclk\,
	datain => \inst8|PA|UC1|count[5]~13_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst8|PA|UC1|count\(5));

-- Location: LCFF_X32_Y21_N17
\inst8|PA|UC1|count[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \inst4|OUT~clkctrl_outclk\,
	datain => \inst8|PA|UC1|count[3]~9_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst8|PA|UC1|count\(3));

-- Location: LCFF_X32_Y21_N13
\inst8|PA|UC1|count[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \inst4|OUT~clkctrl_outclk\,
	datain => \inst8|PA|UC1|count[1]~5_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst8|PA|UC1|count\(1));

-- Location: LCCOMB_X32_Y21_N22
\inst8|PA|UC1|Equal0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|PA|UC1|Equal0~0_combout\ = (!\inst8|PA|UC1|count\(0) & (\inst8|PA|UC1|count\(2) & (\inst8|PA|UC1|count\(3) & \inst8|PA|UC1|count\(1))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|PA|UC1|count\(0),
	datab => \inst8|PA|UC1|count\(2),
	datac => \inst8|PA|UC1|count\(3),
	datad => \inst8|PA|UC1|count\(1),
	combout => \inst8|PA|UC1|Equal0~0_combout\);

-- Location: LCCOMB_X33_Y21_N30
\inst8|PA|UC1|Equal0~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|PA|UC1|Equal0~1_combout\ = (\inst8|PA|UC1|count\(4) & (\inst8|PA|UC1|count\(5) & \inst8|PA|UC1|Equal0~0_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst8|PA|UC1|count\(4),
	datac => \inst8|PA|UC1|count\(5),
	datad => \inst8|PA|UC1|Equal0~0_combout\,
	combout => \inst8|PA|UC1|Equal0~1_combout\);

-- Location: LCFF_X33_Y21_N31
\inst8|PA|UC1|cout\ : cycloneii_lcell_ff
PORT MAP (
	clk => \inst4|OUT~clkctrl_outclk\,
	datain => \inst8|PA|UC1|Equal0~1_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst8|PA|UC1|cout~regout\);

-- Location: LCFF_X33_Y21_N5
\inst8|PA|ps.D\ : cycloneii_lcell_ff
PORT MAP (
	clk => \inst4|OUT~clkctrl_outclk\,
	sdata => \inst8|PA|ps.C~regout\,
	aclr => \rst~clkctrl_outclk\,
	sload => VCC,
	ena => \inst8|PA|UC1|cout~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst8|PA|ps.D~regout\);

-- Location: LCCOMB_X33_Y21_N14
\inst8|PA|ps.A~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|PA|ps.A~0_combout\ = !\inst8|PA|ps.D~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst8|PA|ps.D~regout\,
	combout => \inst8|PA|ps.A~0_combout\);

-- Location: LCFF_X33_Y21_N15
\inst8|PA|ps.A\ : cycloneii_lcell_ff
PORT MAP (
	clk => \inst4|OUT~clkctrl_outclk\,
	datain => \inst8|PA|ps.A~0_combout\,
	aclr => \rst~clkctrl_outclk\,
	ena => \inst8|PA|UC1|cout~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst8|PA|ps.A~regout\);

-- Location: LCCOMB_X34_Y20_N18
\inst8|PA|ps.B~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|PA|ps.B~0_combout\ = !\inst8|PA|ps.A~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \inst8|PA|ps.A~regout\,
	combout => \inst8|PA|ps.B~0_combout\);

-- Location: LCFF_X34_Y20_N19
\inst8|PA|ps.B\ : cycloneii_lcell_ff
PORT MAP (
	clk => \inst4|OUT~clkctrl_outclk\,
	datain => \inst8|PA|ps.B~0_combout\,
	aclr => \rst~clkctrl_outclk\,
	ena => \inst8|PA|UC1|cout~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst8|PA|ps.B~regout\);

-- Location: LCFF_X33_Y21_N25
\inst8|PA|ps.C\ : cycloneii_lcell_ff
PORT MAP (
	clk => \inst4|OUT~clkctrl_outclk\,
	sdata => \inst8|PA|ps.B~regout\,
	aclr => \rst~clkctrl_outclk\,
	sload => VCC,
	ena => \inst8|PA|UC1|cout~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst8|PA|ps.C~regout\);

-- Location: LCCOMB_X33_Y21_N24
\inst8|PA|phase~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|PA|phase~0_combout\ = (\inst8|PA|ps.C~regout\) # (!\inst8|PA|ps.A~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst8|PA|ps.C~regout\,
	datad => \inst8|PA|ps.A~regout\,
	combout => \inst8|PA|phase~0_combout\);

-- Location: LCCOMB_X32_Y21_N26
\inst8|mux2_sel~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|mux2_sel~0_combout\ = (\inst8|PA|UC1|count\(3)) # ((\inst8|PA|UC1|count\(2)) # ((\inst8|PA|UC1|count\(5)) # (\inst8|PA|UC1|count\(4))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|PA|UC1|count\(3),
	datab => \inst8|PA|UC1|count\(2),
	datac => \inst8|PA|UC1|count\(5),
	datad => \inst8|PA|UC1|count\(4),
	combout => \inst8|mux2_sel~0_combout\);

-- Location: LCCOMB_X32_Y21_N4
\inst8|mux2_sel\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|mux2_sel~combout\ = (\inst8|PA|UC1|count\(1)) # ((\inst8|PA|UC1|count\(0)) # ((\inst8|PA|phase~0_combout\) # (\inst8|mux2_sel~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|PA|UC1|count\(1),
	datab => \inst8|PA|UC1|count\(0),
	datac => \inst8|PA|phase~0_combout\,
	datad => \inst8|mux2_sel~0_combout\,
	combout => \inst8|mux2_sel~combout\);

-- Location: LCCOMB_X33_Y21_N22
\inst8|compl1|Add0~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|compl1|Add0~2_combout\ = \inst8|PA|UC1|count\(0) $ (((\inst8|PA|ps.C~regout\) # (!\inst8|PA|ps.A~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000110011110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst8|PA|ps.A~regout\,
	datac => \inst8|PA|ps.C~regout\,
	datad => \inst8|PA|UC1|count\(0),
	combout => \inst8|compl1|Add0~2_combout\);

-- Location: LCCOMB_X33_Y21_N0
\inst8|compl1|Add0~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|compl1|Add0~3_combout\ = (\inst8|PA|phase~0_combout\ & (!\inst8|compl1|Add0~2_combout\ & VCC)) # (!\inst8|PA|phase~0_combout\ & (\inst8|compl1|Add0~2_combout\ $ (GND)))
-- \inst8|compl1|Add0~4\ = CARRY((!\inst8|PA|phase~0_combout\ & !\inst8|compl1|Add0~2_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110011000010001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|PA|phase~0_combout\,
	datab => \inst8|compl1|Add0~2_combout\,
	datad => VCC,
	combout => \inst8|compl1|Add0~3_combout\,
	cout => \inst8|compl1|Add0~4\);

-- Location: LCCOMB_X33_Y21_N2
\inst8|compl1|Add0~5\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|compl1|Add0~5_combout\ = (\inst8|compl1|Add0~4\ & (\inst8|PA|UC1|count\(1) $ ((\inst8|PA|phase~0_combout\)))) # (!\inst8|compl1|Add0~4\ & ((\inst8|PA|UC1|count\(1) $ (!\inst8|PA|phase~0_combout\)) # (GND)))
-- \inst8|compl1|Add0~6\ = CARRY((\inst8|PA|UC1|count\(1) $ (\inst8|PA|phase~0_combout\)) # (!\inst8|compl1|Add0~4\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100101101111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|PA|UC1|count\(1),
	datab => \inst8|PA|phase~0_combout\,
	datad => VCC,
	cin => \inst8|compl1|Add0~4\,
	combout => \inst8|compl1|Add0~5_combout\,
	cout => \inst8|compl1|Add0~6\);

-- Location: LCCOMB_X33_Y21_N4
\inst8|compl1|Add0~7\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|compl1|Add0~7_combout\ = (\inst8|compl1|Add0~6\ & ((\inst8|PA|UC1|count\(2) $ (!\inst8|PA|phase~0_combout\)))) # (!\inst8|compl1|Add0~6\ & (\inst8|PA|UC1|count\(2) $ (\inst8|PA|phase~0_combout\ $ (GND))))
-- \inst8|compl1|Add0~8\ = CARRY((!\inst8|compl1|Add0~6\ & (\inst8|PA|UC1|count\(2) $ (!\inst8|PA|phase~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000001001",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|PA|UC1|count\(2),
	datab => \inst8|PA|phase~0_combout\,
	datad => VCC,
	cin => \inst8|compl1|Add0~6\,
	combout => \inst8|compl1|Add0~7_combout\,
	cout => \inst8|compl1|Add0~8\);

-- Location: LCCOMB_X33_Y21_N6
\inst8|compl1|Add0~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|compl1|Add0~9_combout\ = (\inst8|compl1|Add0~8\ & (\inst8|PA|phase~0_combout\ $ ((\inst8|PA|UC1|count\(3))))) # (!\inst8|compl1|Add0~8\ & ((\inst8|PA|phase~0_combout\ $ (!\inst8|PA|UC1|count\(3))) # (GND)))
-- \inst8|compl1|Add0~10\ = CARRY((\inst8|PA|phase~0_combout\ $ (\inst8|PA|UC1|count\(3))) # (!\inst8|compl1|Add0~8\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100101101111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|PA|phase~0_combout\,
	datab => \inst8|PA|UC1|count\(3),
	datad => VCC,
	cin => \inst8|compl1|Add0~8\,
	combout => \inst8|compl1|Add0~9_combout\,
	cout => \inst8|compl1|Add0~10\);

-- Location: LCCOMB_X33_Y21_N8
\inst8|compl1|Add0~11\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|compl1|Add0~11_combout\ = (\inst8|compl1|Add0~10\ & ((\inst8|PA|UC1|count\(4) $ (!\inst8|PA|phase~0_combout\)))) # (!\inst8|compl1|Add0~10\ & (\inst8|PA|UC1|count\(4) $ (\inst8|PA|phase~0_combout\ $ (GND))))
-- \inst8|compl1|Add0~12\ = CARRY((!\inst8|compl1|Add0~10\ & (\inst8|PA|UC1|count\(4) $ (!\inst8|PA|phase~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000001001",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|PA|UC1|count\(4),
	datab => \inst8|PA|phase~0_combout\,
	datad => VCC,
	cin => \inst8|compl1|Add0~10\,
	combout => \inst8|compl1|Add0~11_combout\,
	cout => \inst8|compl1|Add0~12\);

-- Location: LCCOMB_X34_Y20_N14
\inst8|sine_ROM|LUT~5\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~5_combout\ = (\inst8|compl1|Add0~9_combout\ & ((!\inst8|compl1|Add0~7_combout\))) # (!\inst8|compl1|Add0~9_combout\ & (\inst8|compl1|Add0~5_combout\ & \inst8|compl1|Add0~7_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst8|compl1|Add0~5_combout\,
	datac => \inst8|compl1|Add0~9_combout\,
	datad => \inst8|compl1|Add0~7_combout\,
	combout => \inst8|sine_ROM|LUT~5_combout\);

-- Location: LCCOMB_X33_Y21_N10
\inst8|compl1|Add0~13\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|compl1|Add0~13_combout\ = \inst8|PA|UC1|count\(5) $ (\inst8|compl1|Add0~12\ $ (!\inst8|PA|phase~0_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101010100101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|PA|UC1|count\(5),
	datad => \inst8|PA|phase~0_combout\,
	cin => \inst8|compl1|Add0~12\,
	combout => \inst8|compl1|Add0~13_combout\);

-- Location: LCCOMB_X34_Y20_N8
\inst8|sine_ROM|LUT~6\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~6_combout\ = (\inst8|compl1|Add0~11_combout\ & (((\inst8|compl1|Add0~13_combout\) # (!\inst8|sine_ROM|LUT~5_combout\)))) # (!\inst8|compl1|Add0~11_combout\ & (!\inst8|sine_ROM|LUT~4_combout\ & (\inst8|sine_ROM|LUT~5_combout\ $ 
-- (\inst8|compl1|Add0~13_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110100011100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|sine_ROM|LUT~4_combout\,
	datab => \inst8|compl1|Add0~11_combout\,
	datac => \inst8|sine_ROM|LUT~5_combout\,
	datad => \inst8|compl1|Add0~13_combout\,
	combout => \inst8|sine_ROM|LUT~6_combout\);

-- Location: LCCOMB_X34_Y21_N0
\inst8|sine_ROM|LUT~7\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~7_combout\ = (\inst8|compl1|Add0~11_combout\ & (\inst8|compl1|Add0~13_combout\ & ((\inst8|compl1|Add0~9_combout\) # (\inst8|compl1|Add0~7_combout\)))) # (!\inst8|compl1|Add0~11_combout\ & ((\inst8|compl1|Add0~13_combout\ & 
-- ((!\inst8|compl1|Add0~7_combout\))) # (!\inst8|compl1|Add0~13_combout\ & (\inst8|compl1|Add0~9_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010110101000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~11_combout\,
	datab => \inst8|compl1|Add0~9_combout\,
	datac => \inst8|compl1|Add0~7_combout\,
	datad => \inst8|compl1|Add0~13_combout\,
	combout => \inst8|sine_ROM|LUT~7_combout\);

-- Location: LCCOMB_X34_Y21_N2
\inst8|sine_ROM|LUT~8\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~8_combout\ = (\inst8|compl1|Add0~9_combout\ & ((\inst8|compl1|Add0~11_combout\) # ((\inst8|compl1|Add0~13_combout\)))) # (!\inst8|compl1|Add0~9_combout\ & (((\inst8|compl1|Add0~7_combout\ & \inst8|compl1|Add0~13_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~11_combout\,
	datab => \inst8|compl1|Add0~7_combout\,
	datac => \inst8|compl1|Add0~9_combout\,
	datad => \inst8|compl1|Add0~13_combout\,
	combout => \inst8|sine_ROM|LUT~8_combout\);

-- Location: LCCOMB_X34_Y21_N12
\inst8|sine_ROM|LUT~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~9_combout\ = (\inst8|compl1|Add0~5_combout\ & (!\inst8|compl1|Add0~7_combout\ & ((\inst8|compl1|Add0~3_combout\) # (\inst8|sine_ROM|LUT~8_combout\)))) # (!\inst8|compl1|Add0~5_combout\ & ((\inst8|compl1|Add0~7_combout\ & 
-- ((!\inst8|sine_ROM|LUT~8_combout\))) # (!\inst8|compl1|Add0~7_combout\ & (\inst8|compl1|Add0~3_combout\ & \inst8|sine_ROM|LUT~8_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001001100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~5_combout\,
	datab => \inst8|compl1|Add0~7_combout\,
	datac => \inst8|compl1|Add0~3_combout\,
	datad => \inst8|sine_ROM|LUT~8_combout\,
	combout => \inst8|sine_ROM|LUT~9_combout\);

-- Location: LCCOMB_X34_Y21_N18
\inst8|sine_ROM|LUT~10\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~10_combout\ = (\inst8|sine_ROM|LUT~7_combout\ & ((\inst8|sine_ROM|LUT~8_combout\) # (!\inst8|sine_ROM|LUT~9_combout\))) # (!\inst8|sine_ROM|LUT~7_combout\ & ((\inst8|sine_ROM|LUT~9_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst8|sine_ROM|LUT~7_combout\,
	datac => \inst8|sine_ROM|LUT~8_combout\,
	datad => \inst8|sine_ROM|LUT~9_combout\,
	combout => \inst8|sine_ROM|LUT~10_combout\);

-- Location: LCCOMB_X33_Y21_N20
\inst8|sine_ROM|LUT~12\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~12_combout\ = (\inst8|compl1|Add0~7_combout\ & ((\inst8|compl1|Add0~11_combout\) # ((!\inst8|compl1|Add0~3_combout\ & !\inst8|compl1|Add0~13_combout\)))) # (!\inst8|compl1|Add0~7_combout\ & (\inst8|compl1|Add0~3_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011100110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~3_combout\,
	datab => \inst8|compl1|Add0~7_combout\,
	datac => \inst8|compl1|Add0~11_combout\,
	datad => \inst8|compl1|Add0~13_combout\,
	combout => \inst8|sine_ROM|LUT~12_combout\);

-- Location: LCCOMB_X33_Y21_N28
\inst8|sine_ROM|LUT~13\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~13_combout\ = (\inst8|compl1|Add0~7_combout\ & ((\inst8|compl1|Add0~3_combout\ & ((!\inst8|compl1|Add0~13_combout\) # (!\inst8|compl1|Add0~11_combout\))) # (!\inst8|compl1|Add0~3_combout\ & (!\inst8|compl1|Add0~11_combout\ & 
-- !\inst8|compl1|Add0~13_combout\)))) # (!\inst8|compl1|Add0~7_combout\ & (((\inst8|compl1|Add0~11_combout\ & \inst8|compl1|Add0~13_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011100010001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~3_combout\,
	datab => \inst8|compl1|Add0~7_combout\,
	datac => \inst8|compl1|Add0~11_combout\,
	datad => \inst8|compl1|Add0~13_combout\,
	combout => \inst8|sine_ROM|LUT~13_combout\);

-- Location: LCCOMB_X33_Y20_N24
\inst8|sine_ROM|LUT~14\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~14_combout\ = (\inst8|compl1|Add0~9_combout\ & (\inst8|compl1|Add0~5_combout\)) # (!\inst8|compl1|Add0~9_combout\ & ((\inst8|compl1|Add0~5_combout\ & (!\inst8|sine_ROM|LUT~12_combout\)) # (!\inst8|compl1|Add0~5_combout\ & 
-- ((\inst8|sine_ROM|LUT~13_combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001110110001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~9_combout\,
	datab => \inst8|compl1|Add0~5_combout\,
	datac => \inst8|sine_ROM|LUT~12_combout\,
	datad => \inst8|sine_ROM|LUT~13_combout\,
	combout => \inst8|sine_ROM|LUT~14_combout\);

-- Location: LCCOMB_X34_Y21_N24
\inst8|sine_ROM|LUT~15\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~15_combout\ = (\inst8|compl1|Add0~7_combout\ & (!\inst8|compl1|Add0~11_combout\ & (!\inst8|compl1|Add0~3_combout\))) # (!\inst8|compl1|Add0~7_combout\ & (!\inst8|compl1|Add0~13_combout\ & (\inst8|compl1|Add0~11_combout\ $ 
-- (\inst8|compl1|Add0~3_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000000010110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~11_combout\,
	datab => \inst8|compl1|Add0~3_combout\,
	datac => \inst8|compl1|Add0~7_combout\,
	datad => \inst8|compl1|Add0~13_combout\,
	combout => \inst8|sine_ROM|LUT~15_combout\);

-- Location: LCCOMB_X33_Y20_N18
\inst8|sine_ROM|LUT~16\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~16_combout\ = (\inst8|compl1|Add0~9_combout\ & ((\inst8|sine_ROM|LUT~14_combout\ & ((!\inst8|sine_ROM|LUT~15_combout\))) # (!\inst8|sine_ROM|LUT~14_combout\ & (\inst8|sine_ROM|LUT~11_combout\)))) # (!\inst8|compl1|Add0~9_combout\ & 
-- (((\inst8|sine_ROM|LUT~14_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011100011111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|sine_ROM|LUT~11_combout\,
	datab => \inst8|compl1|Add0~9_combout\,
	datac => \inst8|sine_ROM|LUT~14_combout\,
	datad => \inst8|sine_ROM|LUT~15_combout\,
	combout => \inst8|sine_ROM|LUT~16_combout\);

-- Location: LCCOMB_X33_Y21_N18
\inst8|sine_ROM|LUT~17\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~17_combout\ = (\inst8|compl1|Add0~9_combout\ & ((\inst8|compl1|Add0~3_combout\ & (\inst8|compl1|Add0~5_combout\)) # (!\inst8|compl1|Add0~3_combout\ & ((!\inst8|compl1|Add0~13_combout\))))) # (!\inst8|compl1|Add0~9_combout\ & 
-- (\inst8|compl1|Add0~3_combout\ $ ((\inst8|compl1|Add0~5_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001010010110110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~9_combout\,
	datab => \inst8|compl1|Add0~3_combout\,
	datac => \inst8|compl1|Add0~5_combout\,
	datad => \inst8|compl1|Add0~13_combout\,
	combout => \inst8|sine_ROM|LUT~17_combout\);

-- Location: LCCOMB_X33_Y21_N12
\inst8|sine_ROM|LUT~18\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~18_combout\ = (\inst8|compl1|Add0~5_combout\ & (((!\inst8|compl1|Add0~9_combout\ & \inst8|compl1|Add0~13_combout\)) # (!\inst8|compl1|Add0~3_combout\))) # (!\inst8|compl1|Add0~5_combout\ & ((\inst8|compl1|Add0~3_combout\ & 
-- ((!\inst8|compl1|Add0~13_combout\))) # (!\inst8|compl1|Add0~3_combout\ & (!\inst8|compl1|Add0~9_combout\ & \inst8|compl1|Add0~13_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100110100111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~9_combout\,
	datab => \inst8|compl1|Add0~5_combout\,
	datac => \inst8|compl1|Add0~3_combout\,
	datad => \inst8|compl1|Add0~13_combout\,
	combout => \inst8|sine_ROM|LUT~18_combout\);

-- Location: LCCOMB_X33_Y21_N16
\inst8|sine_ROM|LUT~19\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~19_combout\ = \inst8|compl1|Add0~3_combout\ $ (((\inst8|compl1|Add0~5_combout\ & ((!\inst8|compl1|Add0~13_combout\) # (!\inst8|compl1|Add0~9_combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011010000111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~9_combout\,
	datab => \inst8|compl1|Add0~5_combout\,
	datac => \inst8|compl1|Add0~3_combout\,
	datad => \inst8|compl1|Add0~13_combout\,
	combout => \inst8|sine_ROM|LUT~19_combout\);

-- Location: LCCOMB_X33_Y20_N20
\inst8|sine_ROM|LUT~20\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~20_combout\ = (\inst8|compl1|Add0~7_combout\ & ((\inst8|compl1|Add0~11_combout\) # ((\inst8|sine_ROM|LUT~18_combout\)))) # (!\inst8|compl1|Add0~7_combout\ & (!\inst8|compl1|Add0~11_combout\ & ((\inst8|sine_ROM|LUT~19_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100110101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~7_combout\,
	datab => \inst8|compl1|Add0~11_combout\,
	datac => \inst8|sine_ROM|LUT~18_combout\,
	datad => \inst8|sine_ROM|LUT~19_combout\,
	combout => \inst8|sine_ROM|LUT~20_combout\);

-- Location: LCCOMB_X34_Y21_N22
\inst8|sine_ROM|LUT~21\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~21_combout\ = (!\inst8|compl1|Add0~3_combout\ & (\inst8|compl1|Add0~13_combout\ $ (((\inst8|compl1|Add0~5_combout\) # (\inst8|compl1|Add0~9_combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100001110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~5_combout\,
	datab => \inst8|compl1|Add0~9_combout\,
	datac => \inst8|compl1|Add0~3_combout\,
	datad => \inst8|compl1|Add0~13_combout\,
	combout => \inst8|sine_ROM|LUT~21_combout\);

-- Location: LCCOMB_X33_Y20_N22
\inst8|sine_ROM|LUT~22\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~22_combout\ = (\inst8|compl1|Add0~11_combout\ & ((\inst8|sine_ROM|LUT~20_combout\ & ((!\inst8|sine_ROM|LUT~21_combout\))) # (!\inst8|sine_ROM|LUT~20_combout\ & (\inst8|sine_ROM|LUT~17_combout\)))) # (!\inst8|compl1|Add0~11_combout\ & 
-- (((\inst8|sine_ROM|LUT~20_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101100011111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~11_combout\,
	datab => \inst8|sine_ROM|LUT~17_combout\,
	datac => \inst8|sine_ROM|LUT~20_combout\,
	datad => \inst8|sine_ROM|LUT~21_combout\,
	combout => \inst8|sine_ROM|LUT~22_combout\);

-- Location: LCCOMB_X34_Y21_N28
\inst8|sine_ROM|LUT~27\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~27_combout\ = (\inst8|compl1|Add0~5_combout\ & ((\inst8|compl1|Add0~13_combout\) # ((!\inst8|compl1|Add0~7_combout\ & \inst8|compl1|Add0~11_combout\)))) # (!\inst8|compl1|Add0~5_combout\ & (\inst8|compl1|Add0~7_combout\ & 
-- ((\inst8|compl1|Add0~11_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110011010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~5_combout\,
	datab => \inst8|compl1|Add0~7_combout\,
	datac => \inst8|compl1|Add0~13_combout\,
	datad => \inst8|compl1|Add0~11_combout\,
	combout => \inst8|sine_ROM|LUT~27_combout\);

-- Location: LCCOMB_X34_Y21_N16
\inst8|sine_ROM|LUT~23\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~23_combout\ = (\inst8|compl1|Add0~7_combout\ & (!\inst8|compl1|Add0~5_combout\ & ((\inst8|compl1|Add0~13_combout\) # (\inst8|compl1|Add0~11_combout\)))) # (!\inst8|compl1|Add0~7_combout\ & (\inst8|compl1|Add0~13_combout\ & 
-- ((\inst8|compl1|Add0~5_combout\) # (\inst8|compl1|Add0~11_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111010001100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~5_combout\,
	datab => \inst8|compl1|Add0~7_combout\,
	datac => \inst8|compl1|Add0~13_combout\,
	datad => \inst8|compl1|Add0~11_combout\,
	combout => \inst8|sine_ROM|LUT~23_combout\);

-- Location: LCCOMB_X34_Y21_N20
\inst8|sine_ROM|LUT~25\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~25_combout\ = (\inst8|compl1|Add0~7_combout\ & (\inst8|compl1|Add0~11_combout\)) # (!\inst8|compl1|Add0~7_combout\ & (\inst8|compl1|Add0~13_combout\ & ((\inst8|compl1|Add0~11_combout\) # (!\inst8|compl1|Add0~5_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~11_combout\,
	datab => \inst8|compl1|Add0~7_combout\,
	datac => \inst8|compl1|Add0~5_combout\,
	datad => \inst8|compl1|Add0~13_combout\,
	combout => \inst8|sine_ROM|LUT~25_combout\);

-- Location: LCCOMB_X34_Y21_N10
\inst8|sine_ROM|LUT~24\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~24_combout\ = (\inst8|compl1|Add0~13_combout\ & (!\inst8|compl1|Add0~7_combout\ & (\inst8|compl1|Add0~11_combout\ $ (!\inst8|compl1|Add0~5_combout\)))) # (!\inst8|compl1|Add0~13_combout\ & (\inst8|compl1|Add0~11_combout\ & 
-- ((\inst8|compl1|Add0~5_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~11_combout\,
	datab => \inst8|compl1|Add0~7_combout\,
	datac => \inst8|compl1|Add0~5_combout\,
	datad => \inst8|compl1|Add0~13_combout\,
	combout => \inst8|sine_ROM|LUT~24_combout\);

-- Location: LCCOMB_X34_Y21_N30
\inst8|sine_ROM|LUT~26\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~26_combout\ = (\inst8|compl1|Add0~3_combout\ & (\inst8|compl1|Add0~9_combout\)) # (!\inst8|compl1|Add0~3_combout\ & ((\inst8|compl1|Add0~9_combout\ & ((\inst8|sine_ROM|LUT~24_combout\))) # (!\inst8|compl1|Add0~9_combout\ & 
-- (\inst8|sine_ROM|LUT~25_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110010011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~3_combout\,
	datab => \inst8|compl1|Add0~9_combout\,
	datac => \inst8|sine_ROM|LUT~25_combout\,
	datad => \inst8|sine_ROM|LUT~24_combout\,
	combout => \inst8|sine_ROM|LUT~26_combout\);

-- Location: LCCOMB_X34_Y21_N26
\inst8|sine_ROM|LUT~28\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~28_combout\ = (\inst8|compl1|Add0~3_combout\ & ((\inst8|sine_ROM|LUT~26_combout\ & (!\inst8|sine_ROM|LUT~27_combout\)) # (!\inst8|sine_ROM|LUT~26_combout\ & ((!\inst8|sine_ROM|LUT~23_combout\))))) # (!\inst8|compl1|Add0~3_combout\ & 
-- (((\inst8|sine_ROM|LUT~26_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111011100001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~3_combout\,
	datab => \inst8|sine_ROM|LUT~27_combout\,
	datac => \inst8|sine_ROM|LUT~23_combout\,
	datad => \inst8|sine_ROM|LUT~26_combout\,
	combout => \inst8|sine_ROM|LUT~28_combout\);

-- Location: LCCOMB_X33_Y20_N2
\inst8|compl2|Add0~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|compl2|Add0~2_combout\ = (\inst8|compl2|Add0~1\ & (((\inst8|sine_ROM|LUT~22_combout\)) # (!\inst8|mux2_sel~combout\))) # (!\inst8|compl2|Add0~1\ & (((\inst8|mux2_sel~combout\ & !\inst8|sine_ROM|LUT~22_combout\)) # (GND)))
-- \inst8|compl2|Add0~3\ = CARRY(((\inst8|sine_ROM|LUT~22_combout\) # (!\inst8|compl2|Add0~1\)) # (!\inst8|mux2_sel~combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101001011011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|mux2_sel~combout\,
	datab => \inst8|sine_ROM|LUT~22_combout\,
	datad => VCC,
	cin => \inst8|compl2|Add0~1\,
	combout => \inst8|compl2|Add0~2_combout\,
	cout => \inst8|compl2|Add0~3\);

-- Location: LCCOMB_X33_Y20_N4
\inst8|compl2|Add0~4\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|compl2|Add0~4_combout\ = (\inst8|compl2|Add0~3\ & (\inst8|mux2_sel~combout\ & (!\inst8|sine_ROM|LUT~16_combout\ & VCC))) # (!\inst8|compl2|Add0~3\ & ((((\inst8|mux2_sel~combout\ & !\inst8|sine_ROM|LUT~16_combout\)))))
-- \inst8|compl2|Add0~5\ = CARRY((\inst8|mux2_sel~combout\ & (!\inst8|sine_ROM|LUT~16_combout\ & !\inst8|compl2|Add0~3\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010110100000010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|mux2_sel~combout\,
	datab => \inst8|sine_ROM|LUT~16_combout\,
	datad => VCC,
	cin => \inst8|compl2|Add0~3\,
	combout => \inst8|compl2|Add0~4_combout\,
	cout => \inst8|compl2|Add0~5\);

-- Location: LCCOMB_X33_Y20_N10
\inst8|compl2|Add0~10\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|compl2|Add0~10_combout\ = (\inst8|compl2|Add0~9\ & ((\inst8|sine_ROM|LUT~3_combout\) # ((!\inst8|mux2_sel~combout\)))) # (!\inst8|compl2|Add0~9\ & (((!\inst8|sine_ROM|LUT~3_combout\ & \inst8|mux2_sel~combout\)) # (GND)))
-- \inst8|compl2|Add0~11\ = CARRY((\inst8|sine_ROM|LUT~3_combout\) # ((!\inst8|compl2|Add0~9\) # (!\inst8|mux2_sel~combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011010010111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|sine_ROM|LUT~3_combout\,
	datab => \inst8|mux2_sel~combout\,
	datad => VCC,
	cin => \inst8|compl2|Add0~9\,
	combout => \inst8|compl2|Add0~10_combout\,
	cout => \inst8|compl2|Add0~11\);

-- Location: LCCOMB_X33_Y20_N12
\inst8|compl2|Add0~12\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|compl2|Add0~12_combout\ = (\inst8|compl2|Add0~11\ & (!\inst8|sine_ROM|LUT~1_combout\ & (\inst8|mux2_sel~combout\ & VCC))) # (!\inst8|compl2|Add0~11\ & ((((!\inst8|sine_ROM|LUT~1_combout\ & \inst8|mux2_sel~combout\)))))
-- \inst8|compl2|Add0~13\ = CARRY((!\inst8|sine_ROM|LUT~1_combout\ & (\inst8|mux2_sel~combout\ & !\inst8|compl2|Add0~11\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100101100000100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|sine_ROM|LUT~1_combout\,
	datab => \inst8|mux2_sel~combout\,
	datad => VCC,
	cin => \inst8|compl2|Add0~11\,
	combout => \inst8|compl2|Add0~12_combout\,
	cout => \inst8|compl2|Add0~13\);

-- Location: LCCOMB_X33_Y20_N14
\inst8|compl2|Add0~14\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|compl2|Add0~14_combout\ = \inst8|compl2|Add0~13\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	cin => \inst8|compl2|Add0~13\,
	combout => \inst8|compl2|Add0~14_combout\);

-- Location: LCCOMB_X32_Y20_N0
\inst9|OUT[7]~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst9|OUT[7]~1_combout\ = (\inst8|compl2|Add0~14_combout\) # (!\inst9|OUT[6]~0_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010111110101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst9|OUT[6]~0_combout\,
	datac => \inst8|compl2|Add0~14_combout\,
	combout => \inst9|OUT[7]~1_combout\);

-- Location: PIN_M1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\Mode~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_Mode,
	combout => \Mode~combout\);

-- Location: LCCOMB_X34_Y20_N28
\inst9|OUT[6]~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst9|OUT[6]~0_combout\ = (\inst8|PA|ps.A~regout\ & (!\inst8|PA|ps.B~regout\ & ((\inst6|MSG_REG|register\(8)) # (\Mode~combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|MSG_REG|register\(8),
	datab => \inst8|PA|ps.A~regout\,
	datac => \Mode~combout\,
	datad => \inst8|PA|ps.B~regout\,
	combout => \inst9|OUT[6]~0_combout\);

-- Location: LCCOMB_X34_Y20_N26
\inst9|OUT[6]~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst9|OUT[6]~2_combout\ = (\inst6|MSG_REG|register\(8) & (((\inst8|PA|ps.B~regout\)) # (!\inst8|PA|ps.A~regout\))) # (!\inst6|MSG_REG|register\(8) & (\Mode~combout\ & ((\inst8|PA|ps.B~regout\) # (!\inst8|PA|ps.A~regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101000110010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|MSG_REG|register\(8),
	datab => \inst8|PA|ps.A~regout\,
	datac => \Mode~combout\,
	datad => \inst8|PA|ps.B~regout\,
	combout => \inst9|OUT[6]~2_combout\);

-- Location: LCCOMB_X34_Y20_N24
\inst8|sine_ROM|LUT~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~0_combout\ = (\inst8|compl1|Add0~11_combout\ & ((\inst8|compl1|Add0~9_combout\) # ((\inst8|compl1|Add0~5_combout\ & \inst8|compl1|Add0~7_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~9_combout\,
	datab => \inst8|compl1|Add0~11_combout\,
	datac => \inst8|compl1|Add0~5_combout\,
	datad => \inst8|compl1|Add0~7_combout\,
	combout => \inst8|sine_ROM|LUT~0_combout\);

-- Location: LCCOMB_X34_Y20_N0
\inst9|OUT[6]~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst9|OUT[6]~3_combout\ = (\inst9|OUT[6]~2_combout\ & (((\inst8|sine_ROM|LUT~0_combout\) # (\inst8|compl1|Add0~13_combout\)) # (!\inst8|mux2_sel~combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|mux2_sel~combout\,
	datab => \inst9|OUT[6]~2_combout\,
	datac => \inst8|sine_ROM|LUT~0_combout\,
	datad => \inst8|compl1|Add0~13_combout\,
	combout => \inst9|OUT[6]~3_combout\);

-- Location: LCCOMB_X33_Y20_N28
\inst9|OUT[6]~4\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst9|OUT[6]~4_combout\ = (\inst9|OUT[6]~3_combout\) # ((\inst9|OUT[6]~0_combout\ & \inst8|compl2|Add0~12_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst9|OUT[6]~0_combout\,
	datac => \inst9|OUT[6]~3_combout\,
	datad => \inst8|compl2|Add0~12_combout\,
	combout => \inst9|OUT[6]~4_combout\);

-- Location: LCCOMB_X34_Y20_N4
\inst8|sine_ROM|LUT~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~2_combout\ = (\inst8|compl1|Add0~11_combout\ & (((\inst8|compl1|Add0~5_combout\ & \inst8|compl1|Add0~7_combout\)))) # (!\inst8|compl1|Add0~11_combout\ & ((\inst8|compl1|Add0~7_combout\) # ((\inst8|compl1|Add0~3_combout\ & 
-- \inst8|compl1|Add0~5_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001100100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~3_combout\,
	datab => \inst8|compl1|Add0~11_combout\,
	datac => \inst8|compl1|Add0~5_combout\,
	datad => \inst8|compl1|Add0~7_combout\,
	combout => \inst8|sine_ROM|LUT~2_combout\);

-- Location: LCCOMB_X34_Y20_N6
\inst8|sine_ROM|LUT~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst8|sine_ROM|LUT~3_combout\ = (\inst8|compl1|Add0~9_combout\ & ((\inst8|compl1|Add0~13_combout\) # ((!\inst8|compl1|Add0~11_combout\ & \inst8|sine_ROM|LUT~2_combout\)))) # (!\inst8|compl1|Add0~9_combout\ & ((\inst8|sine_ROM|LUT~2_combout\ & 
-- ((\inst8|compl1|Add0~13_combout\))) # (!\inst8|sine_ROM|LUT~2_combout\ & (\inst8|compl1|Add0~11_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111000100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|compl1|Add0~9_combout\,
	datab => \inst8|compl1|Add0~11_combout\,
	datac => \inst8|sine_ROM|LUT~2_combout\,
	datad => \inst8|compl1|Add0~13_combout\,
	combout => \inst8|sine_ROM|LUT~3_combout\);

-- Location: LCCOMB_X34_Y20_N10
\inst9|OUT[5]~5\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst9|OUT[5]~5_combout\ = (\inst9|OUT[6]~2_combout\ & ((\inst8|sine_ROM|LUT~3_combout\) # (!\inst8|mux2_sel~combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst9|OUT[6]~2_combout\,
	datac => \inst8|mux2_sel~combout\,
	datad => \inst8|sine_ROM|LUT~3_combout\,
	combout => \inst9|OUT[5]~5_combout\);

-- Location: LCCOMB_X33_Y20_N30
\inst9|OUT[5]~6\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst9|OUT[5]~6_combout\ = (\inst9|OUT[5]~5_combout\) # ((\inst9|OUT[6]~0_combout\ & \inst8|compl2|Add0~10_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst9|OUT[6]~0_combout\,
	datac => \inst9|OUT[5]~5_combout\,
	datad => \inst8|compl2|Add0~10_combout\,
	combout => \inst9|OUT[5]~6_combout\);

-- Location: LCCOMB_X32_Y20_N8
\inst7|counter[0]~21\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst7|counter[0]~21_combout\ = !\inst7|counter\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst7|counter\(0),
	combout => \inst7|counter[0]~21_combout\);

-- Location: LCFF_X32_Y20_N9
\inst7|counter[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst7|counter[0]~21_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst7|counter\(0));

-- Location: LCCOMB_X31_Y20_N2
\inst7|counter[2]~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst7|counter[2]~9_combout\ = (\inst7|counter\(2) & (!\inst7|counter[1]~8\)) # (!\inst7|counter\(2) & ((\inst7|counter[1]~8\) # (GND)))
-- \inst7|counter[2]~10\ = CARRY((!\inst7|counter[1]~8\) # (!\inst7|counter\(2)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \inst7|counter\(2),
	datad => VCC,
	cin => \inst7|counter[1]~8\,
	combout => \inst7|counter[2]~9_combout\,
	cout => \inst7|counter[2]~10\);

-- Location: LCFF_X31_Y20_N3
\inst7|counter[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst7|counter[2]~9_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst7|counter\(2));

-- Location: LCCOMB_X31_Y20_N4
\inst7|counter[3]~11\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst7|counter[3]~11_combout\ = (\inst7|counter\(3) & (\inst7|counter[2]~10\ $ (GND))) # (!\inst7|counter\(3) & (!\inst7|counter[2]~10\ & VCC))
-- \inst7|counter[3]~12\ = CARRY((\inst7|counter\(3) & !\inst7|counter[2]~10\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \inst7|counter\(3),
	datad => VCC,
	cin => \inst7|counter[2]~10\,
	combout => \inst7|counter[3]~11_combout\,
	cout => \inst7|counter[3]~12\);

-- Location: LCFF_X31_Y20_N5
\inst7|counter[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst7|counter[3]~11_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst7|counter\(3));

-- Location: LCFF_X31_Y20_N7
\inst7|counter[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst7|counter[4]~13_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst7|counter\(4));

-- Location: LCCOMB_X33_Y20_N26
\inst9|OUT[2]~11\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst9|OUT[2]~11_combout\ = (\inst9|OUT[6]~2_combout\ & ((\inst8|sine_ROM|LUT~16_combout\) # (!\inst8|mux2_sel~combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst8|mux2_sel~combout\,
	datac => \inst9|OUT[6]~2_combout\,
	datad => \inst8|sine_ROM|LUT~16_combout\,
	combout => \inst9|OUT[2]~11_combout\);

-- Location: LCCOMB_X32_Y20_N30
\inst9|OUT[2]~12\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst9|OUT[2]~12_combout\ = (\inst9|OUT[2]~11_combout\) # ((\inst9|OUT[6]~0_combout\ & \inst8|compl2|Add0~4_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst9|OUT[6]~0_combout\,
	datac => \inst9|OUT[2]~11_combout\,
	datad => \inst8|compl2|Add0~4_combout\,
	combout => \inst9|OUT[2]~12_combout\);

-- Location: LCCOMB_X32_Y20_N4
\inst9|OUT[1]~13\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst9|OUT[1]~13_combout\ = (\inst9|OUT[6]~2_combout\ & ((\inst8|sine_ROM|LUT~22_combout\) # (!\inst8|mux2_sel~combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst8|mux2_sel~combout\,
	datac => \inst9|OUT[6]~2_combout\,
	datad => \inst8|sine_ROM|LUT~22_combout\,
	combout => \inst9|OUT[1]~13_combout\);

-- Location: LCCOMB_X32_Y20_N2
\inst9|OUT[1]~14\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst9|OUT[1]~14_combout\ = (\inst9|OUT[1]~13_combout\) # ((\inst9|OUT[6]~0_combout\ & \inst8|compl2|Add0~2_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst9|OUT[6]~0_combout\,
	datac => \inst9|OUT[1]~13_combout\,
	datad => \inst8|compl2|Add0~2_combout\,
	combout => \inst9|OUT[1]~14_combout\);

-- Location: LCCOMB_X32_Y20_N12
\inst7|LessThan0~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst7|LessThan0~1_cout\ = CARRY((\inst9|OUT[0]~16_combout\ & !\inst7|counter\(0)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000100010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst9|OUT[0]~16_combout\,
	datab => \inst7|counter\(0),
	datad => VCC,
	cout => \inst7|LessThan0~1_cout\);

-- Location: LCCOMB_X32_Y20_N14
\inst7|LessThan0~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst7|LessThan0~3_cout\ = CARRY((\inst7|counter\(1) & ((!\inst7|LessThan0~1_cout\) # (!\inst9|OUT[1]~14_combout\))) # (!\inst7|counter\(1) & (!\inst9|OUT[1]~14_combout\ & !\inst7|LessThan0~1_cout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst7|counter\(1),
	datab => \inst9|OUT[1]~14_combout\,
	datad => VCC,
	cin => \inst7|LessThan0~1_cout\,
	cout => \inst7|LessThan0~3_cout\);

-- Location: LCCOMB_X32_Y20_N16
\inst7|LessThan0~5\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst7|LessThan0~5_cout\ = CARRY((\inst7|counter\(2) & (\inst9|OUT[2]~12_combout\ & !\inst7|LessThan0~3_cout\)) # (!\inst7|counter\(2) & ((\inst9|OUT[2]~12_combout\) # (!\inst7|LessThan0~3_cout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst7|counter\(2),
	datab => \inst9|OUT[2]~12_combout\,
	datad => VCC,
	cin => \inst7|LessThan0~3_cout\,
	cout => \inst7|LessThan0~5_cout\);

-- Location: LCCOMB_X32_Y20_N18
\inst7|LessThan0~7\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst7|LessThan0~7_cout\ = CARRY((\inst9|OUT[3]~10_combout\ & (\inst7|counter\(3) & !\inst7|LessThan0~5_cout\)) # (!\inst9|OUT[3]~10_combout\ & ((\inst7|counter\(3)) # (!\inst7|LessThan0~5_cout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst9|OUT[3]~10_combout\,
	datab => \inst7|counter\(3),
	datad => VCC,
	cin => \inst7|LessThan0~5_cout\,
	cout => \inst7|LessThan0~7_cout\);

-- Location: LCCOMB_X32_Y20_N20
\inst7|LessThan0~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst7|LessThan0~9_cout\ = CARRY((\inst9|OUT[4]~8_combout\ & ((!\inst7|LessThan0~7_cout\) # (!\inst7|counter\(4)))) # (!\inst9|OUT[4]~8_combout\ & (!\inst7|counter\(4) & !\inst7|LessThan0~7_cout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst9|OUT[4]~8_combout\,
	datab => \inst7|counter\(4),
	datad => VCC,
	cin => \inst7|LessThan0~7_cout\,
	cout => \inst7|LessThan0~9_cout\);

-- Location: LCCOMB_X32_Y20_N22
\inst7|LessThan0~11\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst7|LessThan0~11_cout\ = CARRY((\inst7|counter\(5) & ((!\inst7|LessThan0~9_cout\) # (!\inst9|OUT[5]~6_combout\))) # (!\inst7|counter\(5) & (!\inst9|OUT[5]~6_combout\ & !\inst7|LessThan0~9_cout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst7|counter\(5),
	datab => \inst9|OUT[5]~6_combout\,
	datad => VCC,
	cin => \inst7|LessThan0~9_cout\,
	cout => \inst7|LessThan0~11_cout\);

-- Location: LCCOMB_X32_Y20_N24
\inst7|LessThan0~13\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst7|LessThan0~13_cout\ = CARRY((\inst7|counter\(6) & (\inst9|OUT[6]~4_combout\ & !\inst7|LessThan0~11_cout\)) # (!\inst7|counter\(6) & ((\inst9|OUT[6]~4_combout\) # (!\inst7|LessThan0~11_cout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst7|counter\(6),
	datab => \inst9|OUT[6]~4_combout\,
	datad => VCC,
	cin => \inst7|LessThan0~11_cout\,
	cout => \inst7|LessThan0~13_cout\);

-- Location: LCCOMB_X32_Y20_N26
\inst7|LessThan0~14\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst7|LessThan0~14_combout\ = (\inst7|counter\(7) & (\inst7|LessThan0~13_cout\ & \inst9|OUT[7]~1_combout\)) # (!\inst7|counter\(7) & ((\inst7|LessThan0~13_cout\) # (\inst9|OUT[7]~1_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010101010000",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst7|counter\(7),
	datad => \inst9|OUT[7]~1_combout\,
	cin => \inst7|LessThan0~13_cout\,
	combout => \inst7|LessThan0~14_combout\);

-- Location: LCFF_X32_Y20_N27
\inst7|pwm_out\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst7|LessThan0~14_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst7|pwm_out~regout\);

-- Location: PIN_T22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\write~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_write,
	combout => \write~combout\);

-- Location: LCCOMB_X42_Y13_N18
\inst11|Selector0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst11|Selector0~0_combout\ = (\inst11|CS.B~regout\) # (!\write~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst11|CS.B~regout\,
	datad => \write~combout\,
	combout => \inst11|Selector0~0_combout\);

-- Location: LCFF_X42_Y13_N19
\inst11|CS.A\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst11|Selector0~0_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst11|CS.A~regout\);

-- Location: LCCOMB_X42_Y13_N4
\inst11|NS.B~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst11|NS.B~0_combout\ = (!\inst11|CS.A~regout\ & !\write~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst11|CS.A~regout\,
	datad => \write~combout\,
	combout => \inst11|NS.B~0_combout\);

-- Location: LCFF_X42_Y13_N5
\inst11|CS.B\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst11|NS.B~0_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst11|CS.B~regout\);

-- Location: LCCOMB_X42_Y13_N12
\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita0~combout\ = \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(0) $ (((VCC) # 
-- (!\inst|scfifo_component|auto_generated|dpfifo|valid_wreq~combout\)))
-- \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita0~COUT\ = CARRY(\inst|scfifo_component|auto_generated|dpfifo|valid_wreq~combout\ $ (!\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(0)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001110011001",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst|scfifo_component|auto_generated|dpfifo|valid_wreq~combout\,
	datab => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(0),
	datad => VCC,
	combout => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita0~combout\,
	cout => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita0~COUT\);

-- Location: PIN_R21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\send~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_send,
	combout => \send~combout\);

-- Location: LCCOMB_X42_Y13_N20
\inst1|Selector0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst1|Selector0~0_combout\ = (\inst1|CS.B~regout\) # (!\send~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010111110101111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst1|CS.B~regout\,
	datac => \send~combout\,
	combout => \inst1|Selector0~0_combout\);

-- Location: LCFF_X42_Y13_N21
\inst1|CS.A\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst1|Selector0~0_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst1|CS.A~regout\);

-- Location: LCCOMB_X42_Y13_N0
\inst1|NS.B~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst1|NS.B~0_combout\ = (!\send~combout\ & !\inst1|CS.A~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010100000101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \send~combout\,
	datac => \inst1|CS.A~regout\,
	combout => \inst1|NS.B~0_combout\);

-- Location: LCFF_X42_Y13_N1
\inst1|CS.B\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst1|NS.B~0_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst1|CS.B~regout\);

-- Location: LCCOMB_X42_Y13_N26
\inst|scfifo_component|auto_generated|dpfifo|fifo_state|_~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst|scfifo_component|auto_generated|dpfifo|fifo_state|_~0_combout\ = (\inst11|CS.B~regout\ & (\inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~regout\ $ (((!\inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~regout\) # 
-- (!\inst1|CS.B~regout\))))) # (!\inst11|CS.B~regout\ & (\inst1|CS.B~regout\ & ((\inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100011000001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst11|CS.B~regout\,
	datab => \inst1|CS.B~regout\,
	datac => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~regout\,
	datad => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~regout\,
	combout => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|_~0_combout\);

-- Location: LCFF_X42_Y13_N13
\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_reg_bit1a[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita0~combout\,
	ena => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|_~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(0));

-- Location: LCCOMB_X42_Y13_N14
\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita1\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita1~combout\ = (\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita0~COUT\ & 
-- (\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(1) $ (((\inst|scfifo_component|auto_generated|dpfifo|valid_wreq~combout\) # (VCC))))) # 
-- (!\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita0~COUT\ & (((\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(1)) # (GND))))
-- \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita1~COUT\ = CARRY((\inst|scfifo_component|auto_generated|dpfifo|valid_wreq~combout\ $ (\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(1))) # 
-- (!\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita0~COUT\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110001101111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst|scfifo_component|auto_generated|dpfifo|valid_wreq~combout\,
	datab => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(1),
	datad => VCC,
	cin => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita0~COUT\,
	combout => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita1~combout\,
	cout => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita1~COUT\);

-- Location: LCFF_X42_Y13_N15
\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_reg_bit1a[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita1~combout\,
	ena => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|_~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(1));

-- Location: LCCOMB_X42_Y13_N2
\inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~0_combout\ = (\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(2)) # ((\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(1)) # 
-- ((!\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(0)) # (!\inst1|CS.B~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(2),
	datab => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(1),
	datac => \inst1|CS.B~regout\,
	datad => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(0),
	combout => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~0_combout\);

-- Location: LCCOMB_X42_Y13_N30
\inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~1_combout\ = (\inst11|CS.B~regout\) # ((\inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~regout\) # 
-- ((\inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~regout\ & \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111011101110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst11|CS.B~regout\,
	datab => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~regout\,
	datac => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~regout\,
	datad => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~0_combout\,
	combout => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~1_combout\);

-- Location: LCFF_X42_Y13_N31
\inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~regout\);

-- Location: LCCOMB_X42_Y13_N16
\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita2\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita2~combout\ = \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(2) $ 
-- (!\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita1~COUT\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010110100101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(2),
	cin => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita1~COUT\,
	combout => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita2~combout\);

-- Location: LCFF_X42_Y13_N17
\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_reg_bit1a[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|counter_comb_bita2~combout\,
	ena => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|_~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(2));

-- Location: LCCOMB_X42_Y13_N10
\inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~0_combout\ = (\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(1) & (\inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~regout\ & 
-- (\inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(2) & \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(1),
	datab => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_non_empty~regout\,
	datac => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(2),
	datad => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|count_usedw|safe_q\(0),
	combout => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~0_combout\);

-- Location: LCCOMB_X42_Y13_N28
\inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~1_combout\ = (!\inst1|CS.B~regout\ & ((\inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~regout\) # ((\inst11|CS.B~regout\ & 
-- \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst1|CS.B~regout\,
	datab => \inst11|CS.B~regout\,
	datac => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~regout\,
	datad => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~0_combout\,
	combout => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~1_combout\);

-- Location: LCFF_X42_Y13_N29
\inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~regout\);

-- Location: LCCOMB_X29_Y10_N12
\frq1|cnt[0]~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq1|cnt[0]~9_combout\ = \frq1|cnt\(0) $ (VCC)
-- \frq1|cnt[0]~10\ = CARRY(\frq1|cnt\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \frq1|cnt\(0),
	datad => VCC,
	combout => \frq1|cnt[0]~9_combout\,
	cout => \frq1|cnt[0]~10\);

-- Location: LCCOMB_X29_Y10_N8
\~GND\ : cycloneii_lcell_comb
-- Equation(s):
-- \~GND~combout\ = GND

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	combout => \~GND~combout\);

-- Location: LCCOMB_X29_Y10_N10
\frq1|always0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq1|always0~0_combout\ = (\frq1|WideAnd0~combout\) # (!\init~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111101010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \init~combout\,
	datad => \frq1|WideAnd0~combout\,
	combout => \frq1|always0~0_combout\);

-- Location: LCFF_X29_Y10_N13
\frq1|cnt[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~clkctrl_outclk\,
	datain => \frq1|cnt[0]~9_combout\,
	sdata => \~GND~combout\,
	aclr => \rst~clkctrl_outclk\,
	sload => \frq1|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq1|cnt\(0));

-- Location: LCCOMB_X29_Y10_N14
\frq1|cnt[1]~11\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq1|cnt[1]~11_combout\ = (\frq1|cnt\(1) & (!\frq1|cnt[0]~10\)) # (!\frq1|cnt\(1) & ((\frq1|cnt[0]~10\) # (GND)))
-- \frq1|cnt[1]~12\ = CARRY((!\frq1|cnt[0]~10\) # (!\frq1|cnt\(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \frq1|cnt\(1),
	datad => VCC,
	cin => \frq1|cnt[0]~10\,
	combout => \frq1|cnt[1]~11_combout\,
	cout => \frq1|cnt[1]~12\);

-- Location: LCFF_X29_Y10_N15
\frq1|cnt[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~combout\,
	datain => \frq1|cnt[1]~11_combout\,
	sdata => \~GND~combout\,
	aclr => \rst~clkctrl_outclk\,
	sload => \frq1|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq1|cnt\(1));

-- Location: LCCOMB_X29_Y10_N16
\frq1|cnt[2]~13\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq1|cnt[2]~13_combout\ = (\frq1|cnt\(2) & (\frq1|cnt[1]~12\ $ (GND))) # (!\frq1|cnt\(2) & (!\frq1|cnt[1]~12\ & VCC))
-- \frq1|cnt[2]~14\ = CARRY((\frq1|cnt\(2) & !\frq1|cnt[1]~12\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \frq1|cnt\(2),
	datad => VCC,
	cin => \frq1|cnt[1]~12\,
	combout => \frq1|cnt[2]~13_combout\,
	cout => \frq1|cnt[2]~14\);

-- Location: LCCOMB_X29_Y10_N18
\frq1|cnt[3]~15\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq1|cnt[3]~15_combout\ = (\frq1|cnt\(3) & (!\frq1|cnt[2]~14\)) # (!\frq1|cnt\(3) & ((\frq1|cnt[2]~14\) # (GND)))
-- \frq1|cnt[3]~16\ = CARRY((!\frq1|cnt[2]~14\) # (!\frq1|cnt\(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \frq1|cnt\(3),
	datad => VCC,
	cin => \frq1|cnt[2]~14\,
	combout => \frq1|cnt[3]~15_combout\,
	cout => \frq1|cnt[3]~16\);

-- Location: LCFF_X29_Y10_N19
\frq1|cnt[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~combout\,
	datain => \frq1|cnt[3]~15_combout\,
	sdata => \~GND~combout\,
	aclr => \rst~clkctrl_outclk\,
	sload => \frq1|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq1|cnt\(3));

-- Location: LCCOMB_X29_Y10_N20
\frq1|cnt[4]~17\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq1|cnt[4]~17_combout\ = (\frq1|cnt\(4) & (\frq1|cnt[3]~16\ $ (GND))) # (!\frq1|cnt\(4) & (!\frq1|cnt[3]~16\ & VCC))
-- \frq1|cnt[4]~18\ = CARRY((\frq1|cnt\(4) & !\frq1|cnt[3]~16\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \frq1|cnt\(4),
	datad => VCC,
	cin => \frq1|cnt[3]~16\,
	combout => \frq1|cnt[4]~17_combout\,
	cout => \frq1|cnt[4]~18\);

-- Location: LCFF_X29_Y10_N21
\frq1|cnt[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~combout\,
	datain => \frq1|cnt[4]~17_combout\,
	sdata => \~GND~combout\,
	aclr => \rst~clkctrl_outclk\,
	sload => \frq1|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq1|cnt\(4));

-- Location: LCCOMB_X29_Y10_N22
\frq1|cnt[5]~19\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq1|cnt[5]~19_combout\ = (\frq1|cnt\(5) & (!\frq1|cnt[4]~18\)) # (!\frq1|cnt\(5) & ((\frq1|cnt[4]~18\) # (GND)))
-- \frq1|cnt[5]~20\ = CARRY((!\frq1|cnt[4]~18\) # (!\frq1|cnt\(5)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \frq1|cnt\(5),
	datad => VCC,
	cin => \frq1|cnt[4]~18\,
	combout => \frq1|cnt[5]~19_combout\,
	cout => \frq1|cnt[5]~20\);

-- Location: PIN_U12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\SW[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_SW(0),
	combout => \SW~combout\(0));

-- Location: LCFF_X29_Y10_N23
\frq1|cnt[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~combout\,
	datain => \frq1|cnt[5]~19_combout\,
	sdata => \SW~combout\(0),
	aclr => \rst~clkctrl_outclk\,
	sload => \frq1|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq1|cnt\(5));

-- Location: LCCOMB_X29_Y10_N24
\frq1|cnt[6]~21\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq1|cnt[6]~21_combout\ = (\frq1|cnt\(6) & (\frq1|cnt[5]~20\ $ (GND))) # (!\frq1|cnt\(6) & (!\frq1|cnt[5]~20\ & VCC))
-- \frq1|cnt[6]~22\ = CARRY((\frq1|cnt\(6) & !\frq1|cnt[5]~20\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \frq1|cnt\(6),
	datad => VCC,
	cin => \frq1|cnt[5]~20\,
	combout => \frq1|cnt[6]~21_combout\,
	cout => \frq1|cnt[6]~22\);

-- Location: PIN_U11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\SW[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_SW(1),
	combout => \SW~combout\(1));

-- Location: LCFF_X29_Y10_N25
\frq1|cnt[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~combout\,
	datain => \frq1|cnt[6]~21_combout\,
	sdata => \SW~combout\(1),
	aclr => \rst~clkctrl_outclk\,
	sload => \frq1|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq1|cnt\(6));

-- Location: LCCOMB_X29_Y10_N26
\frq1|cnt[7]~23\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq1|cnt[7]~23_combout\ = (\frq1|cnt\(7) & (!\frq1|cnt[6]~22\)) # (!\frq1|cnt\(7) & ((\frq1|cnt[6]~22\) # (GND)))
-- \frq1|cnt[7]~24\ = CARRY((!\frq1|cnt[6]~22\) # (!\frq1|cnt\(7)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \frq1|cnt\(7),
	datad => VCC,
	cin => \frq1|cnt[6]~22\,
	combout => \frq1|cnt[7]~23_combout\,
	cout => \frq1|cnt[7]~24\);

-- Location: PIN_M2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\SW[2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_SW(2),
	combout => \SW~combout\(2));

-- Location: LCFF_X29_Y10_N27
\frq1|cnt[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~combout\,
	datain => \frq1|cnt[7]~23_combout\,
	sdata => \SW~combout\(2),
	aclr => \rst~clkctrl_outclk\,
	sload => \frq1|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq1|cnt\(7));

-- Location: LCCOMB_X29_Y10_N28
\frq1|cnt[8]~25\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq1|cnt[8]~25_combout\ = \frq1|cnt[7]~24\ $ (!\frq1|cnt\(8))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => \frq1|cnt\(8),
	cin => \frq1|cnt[7]~24\,
	combout => \frq1|cnt[8]~25_combout\);

-- Location: LCFF_X29_Y10_N29
\frq1|cnt[8]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~combout\,
	datain => \frq1|cnt[8]~25_combout\,
	sdata => VCC,
	aclr => \rst~clkctrl_outclk\,
	sload => \frq1|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq1|cnt\(8));

-- Location: LCCOMB_X29_Y10_N4
\frq1|WideAnd0~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq1|WideAnd0~1_combout\ = (\frq1|cnt\(4) & (\frq1|cnt\(7) & (\frq1|cnt\(6) & \frq1|cnt\(5))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \frq1|cnt\(4),
	datab => \frq1|cnt\(7),
	datac => \frq1|cnt\(6),
	datad => \frq1|cnt\(5),
	combout => \frq1|WideAnd0~1_combout\);

-- Location: LCFF_X29_Y10_N17
\frq1|cnt[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk~combout\,
	datain => \frq1|cnt[2]~13_combout\,
	sdata => \~GND~combout\,
	aclr => \rst~clkctrl_outclk\,
	sload => \frq1|always0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \frq1|cnt\(2));

-- Location: LCCOMB_X29_Y10_N6
\frq1|WideAnd0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq1|WideAnd0~0_combout\ = (\frq1|cnt\(1) & (\frq1|cnt\(3) & (\frq1|cnt\(2) & \frq1|cnt\(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \frq1|cnt\(1),
	datab => \frq1|cnt\(3),
	datac => \frq1|cnt\(2),
	datad => \frq1|cnt\(0),
	combout => \frq1|WideAnd0~0_combout\);

-- Location: LCCOMB_X29_Y10_N30
\frq1|WideAnd0\ : cycloneii_lcell_comb
-- Equation(s):
-- \frq1|WideAnd0~combout\ = LCELL((\frq1|cnt\(8) & (\frq1|WideAnd0~1_combout\ & \frq1|WideAnd0~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \frq1|cnt\(8),
	datac => \frq1|WideAnd0~1_combout\,
	datad => \frq1|WideAnd0~0_combout\,
	combout => \frq1|WideAnd0~combout\);

-- Location: CLKCTRL_G4
\frq1|WideAnd0~clkctrl\ : cycloneii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \frq1|WideAnd0~clkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \frq1|WideAnd0~clkctrl_outclk\);

-- Location: LCCOMB_X40_Y13_N26
\inst6|SineCounter|always0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineCounter|always0~0_combout\ = (\inst6|SineCounter|Equal0~0_combout\) # (!\inst6|ps~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst6|ps~regout\,
	datad => \inst6|SineCounter|Equal0~0_combout\,
	combout => \inst6|SineCounter|always0~0_combout\);

-- Location: LCCOMB_X35_Y13_N10
\inst6|SineMaker|cnt[0]~10\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineMaker|cnt[0]~10_combout\ = (\inst6|SineMaker|cnt\(0) & (\inst6|ps~regout\ $ (VCC))) # (!\inst6|SineMaker|cnt\(0) & (\inst6|ps~regout\ & VCC))
-- \inst6|SineMaker|cnt[0]~11\ = CARRY((\inst6|SineMaker|cnt\(0) & \inst6|ps~regout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110011010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|SineMaker|cnt\(0),
	datab => \inst6|ps~regout\,
	datad => VCC,
	combout => \inst6|SineMaker|cnt[0]~10_combout\,
	cout => \inst6|SineMaker|cnt[0]~11\);

-- Location: LCCOMB_X35_Y13_N12
\inst6|SineMaker|cnt[1]~12\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineMaker|cnt[1]~12_combout\ = (\inst6|SineMaker|cnt\(1) & (!\inst6|SineMaker|cnt[0]~11\)) # (!\inst6|SineMaker|cnt\(1) & ((\inst6|SineMaker|cnt[0]~11\) # (GND)))
-- \inst6|SineMaker|cnt[1]~13\ = CARRY((!\inst6|SineMaker|cnt[0]~11\) # (!\inst6|SineMaker|cnt\(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \inst6|SineMaker|cnt\(1),
	datad => VCC,
	cin => \inst6|SineMaker|cnt[0]~11\,
	combout => \inst6|SineMaker|cnt[1]~12_combout\,
	cout => \inst6|SineMaker|cnt[1]~13\);

-- Location: LCCOMB_X35_Y13_N26
\inst6|SineMaker|cnt[8]~26\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineMaker|cnt[8]~26_combout\ = (\inst6|SineMaker|cnt\(8) & (\inst6|SineMaker|cnt[7]~25\ $ (GND))) # (!\inst6|SineMaker|cnt\(8) & (!\inst6|SineMaker|cnt[7]~25\ & VCC))
-- \inst6|SineMaker|cnt[8]~27\ = CARRY((\inst6|SineMaker|cnt\(8) & !\inst6|SineMaker|cnt[7]~25\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \inst6|SineMaker|cnt\(8),
	datad => VCC,
	cin => \inst6|SineMaker|cnt[7]~25\,
	combout => \inst6|SineMaker|cnt[8]~26_combout\,
	cout => \inst6|SineMaker|cnt[8]~27\);

-- Location: LCCOMB_X35_Y13_N28
\inst6|SineMaker|cnt[9]~28\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineMaker|cnt[9]~28_combout\ = \inst6|SineMaker|cnt\(9) $ (\inst6|SineMaker|cnt[8]~27\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|SineMaker|cnt\(9),
	cin => \inst6|SineMaker|cnt[8]~27\,
	combout => \inst6|SineMaker|cnt[9]~28_combout\);

-- Location: LCFF_X35_Y13_N29
\inst6|SineMaker|cnt[9]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|SineMaker|cnt[9]~28_combout\,
	aclr => \rst~clkctrl_outclk\,
	sclr => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|SineMaker|cnt\(9));

-- Location: LCCOMB_X35_Y13_N8
\inst6|SineMaker|Equal0~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineMaker|Equal0~2_combout\ = (!\inst6|SineMaker|cnt\(9)) # (!\inst6|SineMaker|cnt\(8))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst6|SineMaker|cnt\(8),
	datad => \inst6|SineMaker|cnt\(9),
	combout => \inst6|SineMaker|Equal0~2_combout\);

-- Location: LCCOMB_X35_Y13_N14
\inst6|SineMaker|cnt[2]~14\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineMaker|cnt[2]~14_combout\ = (\inst6|SineMaker|cnt\(2) & (\inst6|SineMaker|cnt[1]~13\ $ (GND))) # (!\inst6|SineMaker|cnt\(2) & (!\inst6|SineMaker|cnt[1]~13\ & VCC))
-- \inst6|SineMaker|cnt[2]~15\ = CARRY((\inst6|SineMaker|cnt\(2) & !\inst6|SineMaker|cnt[1]~13\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|SineMaker|cnt\(2),
	datad => VCC,
	cin => \inst6|SineMaker|cnt[1]~13\,
	combout => \inst6|SineMaker|cnt[2]~14_combout\,
	cout => \inst6|SineMaker|cnt[2]~15\);

-- Location: LCFF_X35_Y13_N15
\inst6|SineMaker|cnt[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|SineMaker|cnt[2]~14_combout\,
	aclr => \rst~clkctrl_outclk\,
	sclr => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|SineMaker|cnt\(2));

-- Location: LCCOMB_X35_Y13_N16
\inst6|SineMaker|cnt[3]~16\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineMaker|cnt[3]~16_combout\ = (\inst6|SineMaker|cnt\(3) & (!\inst6|SineMaker|cnt[2]~15\)) # (!\inst6|SineMaker|cnt\(3) & ((\inst6|SineMaker|cnt[2]~15\) # (GND)))
-- \inst6|SineMaker|cnt[3]~17\ = CARRY((!\inst6|SineMaker|cnt[2]~15\) # (!\inst6|SineMaker|cnt\(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|SineMaker|cnt\(3),
	datad => VCC,
	cin => \inst6|SineMaker|cnt[2]~15\,
	combout => \inst6|SineMaker|cnt[3]~16_combout\,
	cout => \inst6|SineMaker|cnt[3]~17\);

-- Location: LCFF_X35_Y13_N17
\inst6|SineMaker|cnt[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|SineMaker|cnt[3]~16_combout\,
	aclr => \rst~clkctrl_outclk\,
	sclr => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|SineMaker|cnt\(3));

-- Location: LCFF_X35_Y13_N11
\inst6|SineMaker|cnt[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|SineMaker|cnt[0]~10_combout\,
	aclr => \rst~clkctrl_outclk\,
	sclr => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|SineMaker|cnt\(0));

-- Location: LCCOMB_X35_Y13_N4
\inst6|SineMaker|Equal0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineMaker|Equal0~0_combout\ = (((!\inst6|SineMaker|cnt\(0)) # (!\inst6|SineMaker|cnt\(3))) # (!\inst6|SineMaker|cnt\(2))) # (!\inst6|SineMaker|cnt\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111111111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|SineMaker|cnt\(1),
	datab => \inst6|SineMaker|cnt\(2),
	datac => \inst6|SineMaker|cnt\(3),
	datad => \inst6|SineMaker|cnt\(0),
	combout => \inst6|SineMaker|Equal0~0_combout\);

-- Location: LCCOMB_X35_Y13_N22
\inst6|SineMaker|cnt[6]~22\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineMaker|cnt[6]~22_combout\ = (\inst6|SineMaker|cnt\(6) & (\inst6|SineMaker|cnt[5]~21\ $ (GND))) # (!\inst6|SineMaker|cnt\(6) & (!\inst6|SineMaker|cnt[5]~21\ & VCC))
-- \inst6|SineMaker|cnt[6]~23\ = CARRY((\inst6|SineMaker|cnt\(6) & !\inst6|SineMaker|cnt[5]~21\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|SineMaker|cnt\(6),
	datad => VCC,
	cin => \inst6|SineMaker|cnt[5]~21\,
	combout => \inst6|SineMaker|cnt[6]~22_combout\,
	cout => \inst6|SineMaker|cnt[6]~23\);

-- Location: LCFF_X35_Y13_N23
\inst6|SineMaker|cnt[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|SineMaker|cnt[6]~22_combout\,
	aclr => \rst~clkctrl_outclk\,
	sclr => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|SineMaker|cnt\(6));

-- Location: LCCOMB_X35_Y13_N24
\inst6|SineMaker|cnt[7]~24\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineMaker|cnt[7]~24_combout\ = (\inst6|SineMaker|cnt\(7) & (!\inst6|SineMaker|cnt[6]~23\)) # (!\inst6|SineMaker|cnt\(7) & ((\inst6|SineMaker|cnt[6]~23\) # (GND)))
-- \inst6|SineMaker|cnt[7]~25\ = CARRY((!\inst6|SineMaker|cnt[6]~23\) # (!\inst6|SineMaker|cnt\(7)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|SineMaker|cnt\(7),
	datad => VCC,
	cin => \inst6|SineMaker|cnt[6]~23\,
	combout => \inst6|SineMaker|cnt[7]~24_combout\,
	cout => \inst6|SineMaker|cnt[7]~25\);

-- Location: LCFF_X35_Y13_N25
\inst6|SineMaker|cnt[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|SineMaker|cnt[7]~24_combout\,
	aclr => \rst~clkctrl_outclk\,
	sclr => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|SineMaker|cnt\(7));

-- Location: LCCOMB_X35_Y13_N2
\inst6|SineMaker|Equal0~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineMaker|Equal0~1_combout\ = (((!\inst6|SineMaker|cnt\(7)) # (!\inst6|SineMaker|cnt\(5))) # (!\inst6|SineMaker|cnt\(6))) # (!\inst6|SineMaker|cnt\(4))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111111111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|SineMaker|cnt\(4),
	datab => \inst6|SineMaker|cnt\(6),
	datac => \inst6|SineMaker|cnt\(5),
	datad => \inst6|SineMaker|cnt\(7),
	combout => \inst6|SineMaker|Equal0~1_combout\);

-- Location: LCCOMB_X35_Y13_N30
\inst6|MSG_REG|register~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|MSG_REG|register~1_combout\ = ((!\inst6|SineMaker|Equal0~2_combout\ & (!\inst6|SineMaker|Equal0~0_combout\ & !\inst6|SineMaker|Equal0~1_combout\))) # (!\inst6|ps~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010101010111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|ps~regout\,
	datab => \inst6|SineMaker|Equal0~2_combout\,
	datac => \inst6|SineMaker|Equal0~0_combout\,
	datad => \inst6|SineMaker|Equal0~1_combout\,
	combout => \inst6|MSG_REG|register~1_combout\);

-- Location: LCFF_X35_Y13_N13
\inst6|SineMaker|cnt[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|SineMaker|cnt[1]~12_combout\,
	aclr => \rst~clkctrl_outclk\,
	sclr => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|SineMaker|cnt\(1));

-- Location: LCCOMB_X35_Y13_N20
\inst6|SineMaker|cnt[5]~20\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineMaker|cnt[5]~20_combout\ = (\inst6|SineMaker|cnt\(5) & (!\inst6|SineMaker|cnt[4]~19\)) # (!\inst6|SineMaker|cnt\(5) & ((\inst6|SineMaker|cnt[4]~19\) # (GND)))
-- \inst6|SineMaker|cnt[5]~21\ = CARRY((!\inst6|SineMaker|cnt[4]~19\) # (!\inst6|SineMaker|cnt\(5)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \inst6|SineMaker|cnt\(5),
	datad => VCC,
	cin => \inst6|SineMaker|cnt[4]~19\,
	combout => \inst6|SineMaker|cnt[5]~20_combout\,
	cout => \inst6|SineMaker|cnt[5]~21\);

-- Location: LCFF_X35_Y13_N21
\inst6|SineMaker|cnt[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|SineMaker|cnt[5]~20_combout\,
	aclr => \rst~clkctrl_outclk\,
	sclr => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|SineMaker|cnt\(5));

-- Location: LCFF_X35_Y13_N27
\inst6|SineMaker|cnt[8]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|SineMaker|cnt[8]~26_combout\,
	aclr => \rst~clkctrl_outclk\,
	sclr => \inst6|MSG_REG|register~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|SineMaker|cnt\(8));

-- Location: LCCOMB_X35_Y13_N6
\inst6|SineMaker|Equal0~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineMaker|Equal0~3_combout\ = (((\inst6|SineMaker|Equal0~1_combout\) # (\inst6|SineMaker|Equal0~0_combout\)) # (!\inst6|SineMaker|cnt\(8))) # (!\inst6|SineMaker|cnt\(9))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111110111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|SineMaker|cnt\(9),
	datab => \inst6|SineMaker|cnt\(8),
	datac => \inst6|SineMaker|Equal0~1_combout\,
	datad => \inst6|SineMaker|Equal0~0_combout\,
	combout => \inst6|SineMaker|Equal0~3_combout\);

-- Location: LCCOMB_X40_Y13_N2
\inst6|SineCounter|cnt[1]~4\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineCounter|cnt[1]~4_combout\ = (!\inst6|SineCounter|always0~0_combout\ & (\inst6|SineCounter|cnt\(1) $ (((\inst6|SineCounter|cnt\(0) & !\inst6|SineMaker|Equal0~3_combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000000010010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|SineCounter|cnt\(0),
	datab => \inst6|SineCounter|always0~0_combout\,
	datac => \inst6|SineCounter|cnt\(1),
	datad => \inst6|SineMaker|Equal0~3_combout\,
	combout => \inst6|SineCounter|cnt[1]~4_combout\);

-- Location: LCFF_X40_Y13_N3
\inst6|SineCounter|cnt[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|SineCounter|cnt[1]~4_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|SineCounter|cnt\(1));

-- Location: LCCOMB_X40_Y13_N16
\inst6|SineCounter|cnt[2]~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineCounter|cnt[2]~3_combout\ = (!\inst6|SineCounter|always0~0_combout\ & ((\inst6|SineMaker|Equal0~3_combout\ & ((\inst6|SineCounter|cnt\(2)))) # (!\inst6|SineMaker|Equal0~3_combout\ & (\inst6|SineCounter|Add0~1_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|SineCounter|Add0~1_combout\,
	datab => \inst6|SineCounter|always0~0_combout\,
	datac => \inst6|SineCounter|cnt\(2),
	datad => \inst6|SineMaker|Equal0~3_combout\,
	combout => \inst6|SineCounter|cnt[2]~3_combout\);

-- Location: LCFF_X40_Y13_N17
\inst6|SineCounter|cnt[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|SineCounter|cnt[2]~3_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|SineCounter|cnt\(2));

-- Location: LCCOMB_X40_Y13_N30
\inst6|SineCounter|cnt[3]~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineCounter|cnt[3]~2_combout\ = (!\inst6|SineCounter|always0~0_combout\ & ((\inst6|SineMaker|Equal0~3_combout\ & ((\inst6|SineCounter|cnt\(3)))) # (!\inst6|SineMaker|Equal0~3_combout\ & (\inst6|SineCounter|Add0~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|SineCounter|Add0~0_combout\,
	datab => \inst6|SineCounter|always0~0_combout\,
	datac => \inst6|SineCounter|cnt\(3),
	datad => \inst6|SineMaker|Equal0~3_combout\,
	combout => \inst6|SineCounter|cnt[3]~2_combout\);

-- Location: LCFF_X40_Y13_N31
\inst6|SineCounter|cnt[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|SineCounter|cnt[3]~2_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|SineCounter|cnt\(3));

-- Location: LCCOMB_X40_Y13_N0
\inst6|SineCounter|Equal0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|SineCounter|Equal0~0_combout\ = (\inst6|SineCounter|cnt\(0) & (!\inst6|SineCounter|cnt\(1) & (!\inst6|SineCounter|cnt\(2) & \inst6|SineCounter|cnt\(3))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|SineCounter|cnt\(0),
	datab => \inst6|SineCounter|cnt\(1),
	datac => \inst6|SineCounter|cnt\(2),
	datad => \inst6|SineCounter|cnt\(3),
	combout => \inst6|SineCounter|Equal0~0_combout\);

-- Location: LCCOMB_X36_Y13_N8
\inst6|ns~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inst6|ns~0_combout\ = (\inst6|ps~regout\ & (!\inst6|SineCounter|Equal0~0_combout\)) # (!\inst6|ps~regout\ & ((!\send~combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000000111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst6|SineCounter|Equal0~0_combout\,
	datac => \inst6|ps~regout\,
	datad => \send~combout\,
	combout => \inst6|ns~0_combout\);

-- Location: LCFF_X36_Y13_N9
\inst6|ps\ : cycloneii_lcell_ff
PORT MAP (
	clk => \frq1|WideAnd0~clkctrl_outclk\,
	datain => \inst6|ns~0_combout\,
	aclr => \rst~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst6|ps~regout\);

-- Location: PIN_A13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\out~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \inst7|pwm_out~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => \ww_out\);

-- Location: PIN_U22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\full_LED~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|b_full~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_full_LED);

-- Location: PIN_R20,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\empty_LED~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \inst|scfifo_component|auto_generated|dpfifo|fifo_state|ALT_INV_b_non_empty~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_empty_LED);

-- Location: PIN_A14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\valid~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \inst6|ps~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_valid);
END structure;


