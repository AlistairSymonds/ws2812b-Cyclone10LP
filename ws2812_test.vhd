library ieee;
use ieee.std_logic_1164.all;

entity ws2812_test is
	port(
		C10_CLk50M : in std_logic;
		GPIO : inout std_logic_vector(35 downto 0)
	);
end entity;

architecture arch of ws2812_test is

	component ws2812_interface is
		port(
			clk : in std_logic;
			
			R : in std_logic_vector(7 downto 0);
			G : in std_logic_vector(7 downto 0);
			B : in std_logic_vector(7 downto 0);
			
			ready_flag : out std_logic;
			serial_out : out std_logic
		);	
	end component;
	
	signal interface_ready : std_logic;

	begin
	
	leds_out : ws2812_interface
	port map(
		clk => C10_CLk50M,
		R => "01010101",
		G => "11111111",
		B => "00000000",
		ready_flag => interface_ready,
		serial_out => GPIO(0)
	);
	
	
	
	
end arch;