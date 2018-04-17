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
	
	
	--SERIALISER INTERFACE
	
	component ws2812_interface is
		port(
			clk : in std_logic;
			request_write : in std_logic;
			R : in std_logic_vector(7 downto 0);
			G : in std_logic_vector(7 downto 0);
			B : in std_logic_vector(7 downto 0);
			ready_flag : out std_logic;
			serial_out : out std_logic
		);	
	end component;
	signal request_write : std_logic;
	signal interface_ready : std_logic;
	signal red, green, blue : std_logic_vector(7 downto 0);
	-- END SERIALISER
	
	
	
	--CONTROL LOGIC
	component ws2812_control is
		generic(
			WORD_SIZE : in integer;
			NUM_WORDS : in integer
		);
		port(
			clk : in std_logic;
			request_write : in std_logic;
			buffer_address : unsigned (2**NUM_WORDS-1 downto 0)
		);
	end component;

	--END CONTROL LOGIC
	
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
	
	
	leds_out : ws2812_interface
	port map(
		clk => clk,
		request_write => request_write,
		R => red,
		G => green,
		B => blue,
		ready_flag => interface_ready,
		serial_out => serial_out
	);
	


end architecture;