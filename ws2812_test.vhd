library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ws2812_test is
	port(
		C10_CLk50M : in std_logic;
		GPIO : inout std_logic_vector(35 downto 0);
		USER_PB : in std_logic_vector(3 downto 0)
	);
end entity;

architecture arch of ws2812_test is


	component WS2812_container is
		generic(num_leds : integer);
		port(
			clk : in std_logic;
			w_addr : in unsigned((2**num_leds)*3);
			w_val : in std_logic_vector(7 downto 0);
			w_enable : in std_logic;
			output_requested : in std_logic
			serial_out : out std_logic
		);

	end component;
	
	
	-- test rom
	
	component test_rom is
		port(
			r_addr : in unsigned(3 downto 0);
			r_val : out std_logic_vector(7 downto 0)
		);
	end component;
	signal address : unsigned(3 downto 0) := 0;
	signal test_val : std_logic_vector(7 downto 0);
	
	--end test rom
	
------ instantiations
	begin

		leds : WS2812_container
			generic map (num_leds => 4)
			port map(
				clk => C10_CLK50M,
				w_addr =>
				w_val =>
				w_enable =>
				output_requested => USER_PB(0),
				serial_out => GPIO(0)
			
			);	
			
			
			
		test_data : test_rom
			port map(
				r_addr => address,
				r_val => test_val
			);
	
	
end arch;