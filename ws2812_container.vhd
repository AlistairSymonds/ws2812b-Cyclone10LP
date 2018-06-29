library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WS2812_container is
	generic(num_leds : integer);
	port(
		clk : in std_logic;
		w_addr : in unsigned(3 downto 0);
		w_val : in std_logic_vector(7 downto 0);
		w_enable : in std_logic;
		output_requested : in std_logic;
		serial_out : out std_logic
	);

end entity;

architecture arch of ws2812_container is
	
	type FSM_States is (waiting, writing);
	signal state : FSM_States;

	--RAM for led buffer
	component sram is
	generic(
		WORD_SIZE : in integer;
		NUM_WORDS : in integer
	);
	
	port(
		clk : in std_logic;
		
		r_addr : in unsigned(7 downto 0);
		r_val : out std_logic_vector(WORD_SIZE-1 downto 0);
		
		w_addr : in unsigned(7 downto 0);
		w_val : in std_logic_vector(WORD_SIZE-1 downto 0);
		w_enable : in std_logic
	);
	end component;
	signal ram_r_addr, ram_w_addr : unsigned (7 downto 0);
	signal ram_r_val, ram_w_val : std_logic_vector(7 downto 0);
	signal ram_w_enable : std_logic;
	
	--END RAM
	
	

	

begin

	ram_w_val <= w_val;
	ram_w_addr <= "0000" & w_addr;
	ram_w_enable <= w_enable;

	strip_buffer : sram
	generic map (
		WORD_SIZE => 8,
		NUM_WORDS => 16
	)
	port map(
		clk => clk,
		r_addr => ram_r_addr,
		r_val => ram_r_val,
		w_addr => ram_w_addr,
		w_val => ram_w_val,
		w_enable => ram_w_enable
	);
	
	
	
	serialiser : ws2812b_serialiser is
	port(
		clk => clk,
		request_write => 
		bit_value_in =>
		write_enable =>
		output => serial_out,
		done_flag =>
	);
	
	-- FSM
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