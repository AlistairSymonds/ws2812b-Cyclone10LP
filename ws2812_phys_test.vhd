
LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;                                

ENTITY ws2812_phys_test IS

	port(
		USER_PB : in std_logic_vector(3 downto 0);
		C10_CLK50M : in std_logic;
		ARDUINO_IO : out std_logic_vector(13 downto 0);
		USER_LED : out std_logic_vector(3 downto 0)
	);

END ws2812_phys_test;



ARCHITECTURE arch OF ws2812_phys_test IS
-- constants                                                 
-- signals                                                   
SIGNAL byteIn : STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL load_byte : STD_LOGIC;
SIGNAL sclr : STD_LOGIC;
SIGNAL serialOut : STD_LOGIC;
SIGNAL triggerWriteOut : STD_LOGIC;

COMPONENT ws2812Controller
	PORT (
	byteIn : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	clk : IN STD_LOGIC;
	load_byte : IN STD_LOGIC;
	sclr : IN STD_LOGIC;
	serialOut : BUFFER STD_LOGIC;
	triggerWriteOut : IN STD_LOGIC
	);
END COMPONENT;


signal div_clk : std_logic := '0';
signal div : integer := 0;

BEGIN
	i1 : ws2812Controller
	PORT MAP (
-- list connections between master ports and signals
	byteIn => byteIn,
	clk => C10_CLK50M,
	load_byte => load_byte,
	sclr => sclr,
	serialOut => serialOut,
	triggerWriteOut => triggerWriteOut
	);
		

	
	process(C10_CLK50M)
	begin
		if(rising_edge(C10_CLK50M)) then
			if div > 20000000 then
				div_clk <= not div_clk;
				div <= 0;
			else
				div <= div + 1;
			end if;
			
			
			load_byte <= '0';
			triggerWriteOut <= '0';
		
			if(div < 5) then
				sclr <= '1';
			else
				sclr <= '0';
			end if;
				
			
			if(div > 5 and div < 16) then

				load_byte <= '1';
				--byte order GRB
				case div is
				
					--Red pixel
					when 6 =>
						byteIn <= x"00";
					when 7 =>
						byteIn <= x"AA";
					when 8 =>
						byteIn <= x"00";
						
					--green pixel
					when 9 =>
						byteIn <= x"AA";
					when 10 =>
						byteIn <= x"00";
					when 11 =>
						byteIn <= x"00";
						
					--blue pixel
					when 12 =>
						byteIn <= x"00";
					when 13 =>
						byteIn <= x"00";
					when 14 =>
						byteIn <= x"AA";
					when others =>
						byteIn <= x"AA";
						load_byte <= '0';
				end case;
			
			elsif(div = 100)then
				triggerWriteOut <= '1';
				
			end if;
		end if;
		
		
		
		
		
	end process;
	
	ARDUINO_IO(13) <= serialOut;
	ARDUINO_IO(12) <= serialOut;
	USER_LED(0) <= div_clk;
END arch;
