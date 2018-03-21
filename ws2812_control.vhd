library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ws2812_control is 
	port(
		clk : in std_logic;
		request_write : in std_logic;
		
		output_requested
		buffer_address
		
		
		
	);
end entity;

type FSM_States is (waiting, writing);
signal state : FSM_States;