library ieee;
use ieee.std_logic_1164.all;
entity ws2812b_serialiser is
	port(
		clk : in std_logic;
		reqw : in std_logic;
		bit_value_in : in std_logic;
		req_out : in std_logic;
		output : out std_logic;
		busy_flag : out std_logic
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

	signal busy : std_logic;
	
	type state_t is (idle, bit_loaded, outputting_high, outputting_low);
	signal state : state_t;
	
begin	
	
	set_state : process(clk)
	begin
		if(rising_edge(clk)) then
			case state is
			
				when idle =>
					if(reqw = '1') then
						bit_value <= bit_value_in;
						state <= outputting_high;
					end if;
					cycle_counter <= 0;
				
				
				when bit_loaded =>
					if(req_out = '1') then
						state <= outputting_high;
					end if;
				
					cycle_counter <= 0;
				when outputting_high =>
					if(bit_value = '1') then
						if(cycle_counter >= t1h_cycles)then
							state <= outputting_low;
						end if;
					else
						if(cycle_counter >= t0h_cycles)then
							state <= outputting_low;
						end if;
					end if;
					cycle_counter<= cycle_counter+1;
					
				when outputting_low =>
					if(bit_value = '1') then
						if(cycle_counter >= t1l_cycles+t1h_cycles)then
							state <= idle;
						end if;
					else
						if(cycle_counter >= t0l_cycles+t0h_cycles)then
							state <= idle;
						end if;
					end if;
					cycle_counter<= cycle_counter+1;
				
			
			end case;
		end if;
		
	end process;
		
		
	
	
	set_outputs : process(state)
	begin
		case state is
			
			when idle =>
				output <= '0';
				busy <= '0';
				
			when bit_loaded =>
				output <= '0';
				busy <= '0';
				
			when outputting_high =>
				output <= '1';
				busy <= '1';
				
			when outputting_low =>
				output <= '0';
				busy <= '1';
			
			
		end case;
	end process;
		
	
	busy_flag <= busy;
	

end architecture;