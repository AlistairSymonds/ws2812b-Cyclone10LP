library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftreg_piso is
	port(
		clk : in std_logic;
		sclr : in std_logic;
		load : in std_logic;
		enable_out : in std_logic;
		data : in std_logic_vector(7 downto 0);
		shiftpos : out unsigned (2 downto 0);
		shiftout : out std_logic
	);

end entity;

architecture arch of shiftreg_piso is
signal i_shiftpos : integer range 0 to 7 := 7;
signal q : std_logic_vector (7 downto 0);


begin

	process (clk)
	begin
		if(rising_edge(clk)) then
			if(sclr = '1') then
				q <= (others=>'0');
				i_shiftpos <= 7;
			else
			
				if(load ='1') then
					q <= data;
				elsif(enable_out) then
					
					if(i_shiftpos = 0) then
						i_shiftpos <= 7;
					else
						i_shiftpos <= i_shiftpos-1;
					end if;
				end if;
				
			end if;
		
		
		end if;	
	end process;



	shiftpos <= to_unsigned(i_shiftpos,3);
	shiftout <= q(i_shiftpos);

end architecture;