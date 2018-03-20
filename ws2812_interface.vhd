library ieee;
use ieee.std_logic_1164.all;

entity ws2812_interface is

	port(
		clk : in std_logic;
		R : in std_logic_vector(7 downto 0);
		G : in std_logic_vector(7 downto 0);
		B : in std_logic_vector(7 downto 0);
		ready_flag : out std_logic;
		serial_out : out std_logic
	);

end entity;

architecture arch of ws2812_interface is

	signal pixel_buffer : std_logic_vector(23 downto 0);
	signal writing_flag : std_logic := '0'; --0 = waiting, 1 = writing
	signal bit_pos : integer range 0 to 24;
	
	component ws2812b_serialiser is
		port(
			clk : in std_logic;
			bit_value_in : in std_logic;
			write_enable : in std_logic;
			output : out std_logic;
			done_flag : out std_logic
		);
	end component;
	signal current_bit, serialiser_done, serialiser_write : std_logic;

	begin
		--component instantiation
		ser : ws2812b_serialiser port map(
			clk => clk,
			bit_value_in => current_bit,
			write_enable => serialiser_write,
			output => serial_out,
			done_flag => serialiser_done			
		);
	
		set_state : process(clk)
		begin
			if rising_edge(clk) then
				if writing_flag = '0' then
					ready_flag <= '0';
					writing_flag <= '1';
					pixel_buffer <= r&g&b;
				end if;
			end if;
			
			if rising_edge(clk)then
				if(serialiser_done = '1' and serialiser_write = '0') then
					serialiser_write <= '1';
					bit_pos <= bit_pos + 1;
				elsif(serialiser_done = '0') then
					serialiser_write <= '0';
				end if;
			end if;
			
			if(bit_pos >= 23) then
				bit_pos <= 0;
				ready_flag <= '1';
			end if;	
		end process;
		
		bit_select_proc : process(bit_pos)
		begin
			current_bit <= pixel_buffer(bit_pos);
		end process;
		
end architecture;


