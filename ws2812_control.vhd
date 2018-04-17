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
		write_req : in std_logic;
		interface_ready : in std_logic;
		
		buffer_address : out unsigned (2**NUM_WORDS-1 downto 0)
		
		
		
	);
end entity;



architecture arch of ws2812_control is

type FSM_States is (waiting, writing);
signal state : FSM_States;
signal ram_r_addr : unsigned (2**NUM_WORDS-1 downto 0);

begin

set_state : process(clk, write_req, interface_ready)
	begin
		if(rising_edge(clk)) then
		
			if(state = waiting and interface_ready = '1') then
				if(write_req = '1') then
					state <= writing;
				else
					state <= waiting;
				end if;
			elsif(state = writing) then
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