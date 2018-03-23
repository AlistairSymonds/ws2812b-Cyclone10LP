library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ws2812_control is
	generic(
		WORD_SIZE : in integer;
		NUM_WORDS : in integer
	);
	port(
		clk : in std_logic;
		request_write : in std_logic;
		
		
		buffer_address : unsigned (2**NUM_WORDS-1 downto 0)
		
		
		
	);
end entity;



architecture arch of ws2812_control is

type FSM_States is (waiting, writing);
signal state : FSM_States;

begin

set_state : process(clk, USER_PB(0), interface_ready)
	begin
		if(rising_edge(clk)) then
		
			if(states = waiting and interface_ready = '1') then
				if(write_req = '1') then
					state <= writing;
				else
					state <= waiting;
				end if;
			elsif(states = writing) then
				ram_r_addr <= ram_r_addr + 1;
			end if;
		end if;
	end process;
	
	
	set_outputs : process(state)
	begin
		if(state = waiting) then
			
		elsif(state = writing) then
			
		end if;
	end process;
end architecture;