library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_rom is
	port(
		r_addr : in unsigned(3 downto 0);
		r_val : out std_logic_vector(7 downto 0)
	);
end entity;	

architecture arch of test_rom is

type data_store is array (0 to (2**NUM_WORDS-1)) of std_logic_vector(WORD_SIZE-1 downto 0);
signal data : data_store :=((others=> (others=>'0')));
	
begin
	data(0) <= x"FF";
	data(1) <= x"00";
	data(2) <= x"00";
	
	data(3) <= x"00";
	data(4) <= x"FF";
	data(5) <= x"00";
	
	data(6) <= x"00";
	data(7) <= x"00";
	data(8) <= x"FF";
	
	data(9) <= x"C0";
	data(10) <= x"C0";
	data(11) <= x"C0";
	
	
	r_val <= data(to_integer(r_addr));
end architecture;
	