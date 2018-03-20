-- Copyright (C) 2017  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "03/20/2018 23:07:00"
                                                            
-- Vhdl Test Bench template for design  :  ws2812_test
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY ws2812_test_vhd_tst IS
END ws2812_test_vhd_tst;

ARCHITECTURE ws2812_test_arch OF ws2812_test_vhd_tst IS

                                                
-- signals                                                   
SIGNAL clk : STD_LOGIC := '0';
SIGNAL GPIO : STD_LOGIC_VECTOR(35 DOWNTO 0);
COMPONENT ws2812_test
	PORT (
	C10_CLk50M : IN STD_LOGIC;
	GPIO : inout STD_LOGIC_VECTOR(35 DOWNTO 0)
	);
END COMPONENT;
BEGIN

	i1 : ws2812_test
	PORT MAP (
	-- list connections between master ports and signals
		C10_CLk50M => clk,
		GPIO => GPIO
	);
                                             
                                        
clk_proc: process 
	begin         
		wait for 10 ns;
		CLK <= not(CLK);
	end process;                                       
END ws2812_test_arch;
