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

	signal red, green, blue : std_logic_vector(7 downto 0);
	
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
	
	
	signal write_req : std_logic;
------ instantiations
	begin
	write_req <= not USER_PB(0);
	
	strip_buffer : sram
	generic map (
		WORD_SIZE => 8,
		NUM_WORDS => 16
	)
	port map(
		clk => C10_CLk50M,
		r_addr => ram_r_addr,
		r_val => ram_r_val,
		w_addr => ram_w_addr,
		w_val => ram_w_val,
		w_enable => ram_w_enable
	);
	
	
	leds_out : ws2812_interface
	port map(
		clk => C10_CLk50M,
		R => red,
		G => green,
		B => blue,
		ready_flag => interface_ready,
		serial_out => GPIO(0)
	);
	
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
	
	
	
	
	
	
	
	
	
end arch;