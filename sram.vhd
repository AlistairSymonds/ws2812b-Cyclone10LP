library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sram is
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
end entity;

architecture arch of sram is
	type data_store is array (0 to (2**NUM_WORDS-1)) of std_logic_vector(WORD_SIZE-1 downto 0);
	
	signal data : data_store :=((others=> (others=>'0')));
	
	
begin

	write_proc : process(clk, w_addr)
	begin
		if(rising_edge(clk)) then
			if(w_enable = '1') then
				data( (to_integer(w_addr)) ) <= w_val;
				
				
				
			end if;
		end if;
	end process;
	
	
	r_val <= data(to_integer(r_addr));

	
	
end architecture;
