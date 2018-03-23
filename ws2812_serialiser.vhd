library ieee;
use ieee.std_logic_1164.all;
entity ws2812b_serialiser is
	port(
		clk : in std_logic;
		request_write : in std_logic;
		bit_value_in : in std_logic;
		write_enable : in std_logic;
		output : out std_logic;
		done_flag : out std_logic
	);

end entity;

architecture arch of ws2812b_serialiser is

	--always t_high then t_low	
	--					 num cycles @50MHz
	--t0h = 0.4us  | 20
	--t0l = 0.85us | 42.5
	--t1h = 0.8us  | 40
	--t0l = 0.45us | 22.5
	constant t0h_cycles : integer := 20;
	constant t0l_cycles : integer := 43;
	constant t1h_cycles : integer := 40;
	constant t1l_cycles : integer := 23;

	signal cycle_counter : integer range 0 to 64;
	
	signal bit_value : std_logic;
	signal done : std_logic := '0';

begin	
	save_proc : process(clk)
	begin
		if rising_edge(clk) then
			if(write_enable = '1' and done = '1') then
				bit_value <= bit_value_in;
				done <= '0';
			end if;
		end if;
		
		if rising_edge(clk) then
			if(done = '0') then
				if(bit_value = '0') then
					if(cycle_counter <= t0h_cycles) then
						output <= '1';
					else
						output <= '0';
					end if;
					cycle_counter <= cycle_counter + 1;
				else
					if(cycle_counter <= t1h_cycles) then
						output <= '1';
					else
						output <= '0';
					end if;
					cycle_counter <= cycle_counter + 1;
				end if;
			end if;
			
			if(cycle_counter >= 63) then
				cycle_counter <= 0;
				done <= '1';
			end if;
			
			if(done = '1' and request_write = '0') then
				output <= '0';
			end if;
			
		end if;
	end process;
	
	done_flag <= done;
	

end architecture;