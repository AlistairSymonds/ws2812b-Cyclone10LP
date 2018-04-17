library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

entity ws2812_test is
	port(
		C10_CLk50M : in std_logic;
		ARDUINO_IO : inout std_logic_vector(13 downto 0);
		USER_PB : in std_logic_vector(3 downto 0)
	);
end entity;

architecture arch of ws2812_test is
	

	component WS2812_container is
		generic(num_leds : integer);
		port(
			clk : in std_logic;
			w_addr : in unsigned(3 downto 0);
			w_val : in std_logic_vector(7 downto 0);
			w_enable : in std_logic;
			output_requested : in std_logic;
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
	signal address : unsigned(3 downto 0) := "0000";
	signal test_val : std_logic_vector(7 downto 0);
	signal copy_enable : std_logic;
	
	--end test rom
	
------ instantiations
	begin

		leds : WS2812_container
			generic map (num_leds => 4)
			port map(
				clk => C10_CLK50M,
				w_addr => address,
				w_val => test_val,
				w_enable => copy_enable,
				output_requested => USER_PB(0),
				serial_out => ARDUINO_IO(13)
			
			);	
			
			
			
		test_data : test_rom
			port map(
				r_addr => address,
				r_val => test_val
			);
			
		load_data : process(C10_CLK50M)
		begin
			if rising_edge(C10_CLK50M) then
				if address < 14 then
					copy_enable <= '1';
					address <= address + 1;
					
				else
					copy_enable <= '0';
					
				end if;			
			end if;
		end process;
	
	
end arch;