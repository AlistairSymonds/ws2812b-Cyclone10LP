library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

entity ws2812Controller is
	port(
		clk : in std_logic;
		sclr : in std_logic;
		triggerWriteOut : in std_logic;
		load_byte : in std_logic;
		byteIn : in std_logic_vector(7 downto 0);
		serialOut : out std_LOGIC
	);


end entity;

architecture arch of ws2812Controller is

	signal i_byteIn : std_logic_vector(7 downto 0);



	signal fifo_sclr : std_logic;
	signal fifo_rdreq : std_logic;
	signal fifo_wreq : std_logic;
	signal fifo_empty : std_logic;
	signal fifo_full : std_logic;
	signal fifo_q : std_logic_vector(7 downto 0);
	signal fifo_usedw : std_LOGIC_VECTOR(7 downto 0);
	component fifo is
		PORT
		(
			clock		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			rdreq		: IN STD_LOGIC ;
			sclr		: IN STD_LOGIC ;
			wrreq		: IN STD_LOGIC ;
			empty		: OUT STD_LOGIC ;
			full		: OUT STD_LOGIC ;
			q			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			usedw		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	end component;

	signal shiftReg_load : std_logic;
	signal shiftReg_enable : std_logic;
	signal shiftReg_bit : std_logic;
	
	component shiftreg_piso is
		port(
			clk : in std_logic;
			sclr : in std_logic;
			load : in std_logic;
			enable_out : in std_logic;
			data : in std_logic_vector(7 downto 0);
			shiftpos : out unsigned (2 downto 0);
			shiftout : out std_logic
		);
	end component;
	
	
	signal serialiser_reqw : std_logic;
	signal serialiser_req_out : std_logic;
	signal serialiserBusy : std_logic;
	component ws2812b_serialiser is
		port(
			clk : in std_logic;
			reqw : in std_logic;
			bit_value_in : in std_logic;
			req_out : in std_logic;
			output : out std_logic;
			busy_flag : out std_logic
		);
	end component;
	
	
	type top_level_state_type is (idle, outputting);
	signal top_level_state : top_level_state_type;

	type fifo_to_shift_state_t is (idle, loading, shift_ready);
	signal fifo_to_shift_state : fifo_to_shift_state_t;
	signal bits_shifted_cnt : integer range 0 to 7;
	signal bits_shifted_cnt_us : unsigned (2 downto 0);
	
	signal serial_output : std_logic;
	
	
	type shift_out_to_ser_t is (idle,loading,outputting,bit_done,byte_done);
	signal shift_out_to_ser_state : shift_out_to_ser_t;
	
begin

	fifo_load_proc : process(clk)
	begin
		if(rising_edge(clk)) then
			if(fifo_full = '0' and load_byte = '1') then
				fifo_wreq <= '1';
			else
				fifo_wreq <= '0';		
			end if;	
		end if;	
	end process;



	triggerWriteProc : process(clk)
	begin
		if(rising_edge(clk))then
			case top_level_state is
				when idle =>
					if(triggerWriteOut = '1')then
						top_level_state <= outputting;
					end if;
				
				when outputting =>
					if(fifo_usedw = x"00") then
						top_level_state <= idle;
					end if;
					
				when others =>
					--nothing
			
			end case;
		
		end if;
	end process;

	

	

	fifoIn : fifo
	port map(
		clock => clk,
		data => byteIn,
		rdreq	=> fifo_rdreq,
		sclr => fifo_sclr,
		wrreq	=> fifo_wreq,
		empty => fifo_empty,
		full => fifo_full,
		q => fifo_q,
		usedw => fifo_usedw
		
	);
	
	
	fifo_t_shift_set : process(clk)
	begin
		if(rising_edge(clk)) then
			case fifo_to_shift_state is
				when idle =>
					if(top_level_state = outputting and shift_out_to_ser_state = idle) then
						fifo_to_shift_state <= shift_ready;
					end if;
					
					
				
				when loading =>					
					fifo_to_shift_state <= shift_ready;
					
				when shift_ready =>
					if(bits_shifted_cnt >= 7) then
						fifo_to_shift_state <= idle;
					end if;
				
			end case;
				
		end if;	
	end process;
	
	fifo2shift_output : process(fifo_to_shift_state)
	begin
		case fifo_to_shift_state is
				when idle =>
					fifo_rdreq <= '0';
					shiftReg_load <= '0';
				when loading =>
					fifo_rdreq <= '1';
					shiftReg_load <= '1';
				when shift_ready =>
					fifo_rdreq <= '0';
					shiftReg_load <= '0';
			end case;
	end process;
	
	
	shift_to_serial_set : process(clk)
	begin
		if(rising_edge(clk)) then
			case shift_out_to_ser_state is
				when idle =>
					if(serialiserBusy = '0' and top_level_state = outputting and fifo_to_shift_state = shift_ready)then
						shift_out_to_ser_state <= loading;
					end if;
					
				when loading =>	
					shift_out_to_ser_state <= outputting;
			
				when outputting =>
					if(serialiserBusy = '0') then

						shift_out_to_ser_state <= bit_done;
					end if;
				
				when bit_done =>
					if(bits_shifted_cnt = 7) then
						shift_out_to_ser_state <= byte_done;
					else
						shift_out_to_ser_state <= loading;
					end if;
				when byte_done =>
					shift_out_to_ser_state <= idle;
					
			end case;
		end if;
		
	end process;
	
	process(shift_out_to_ser_state)
	begin
		case shift_out_to_ser_state is
			when idle =>
				shiftReg_enable <= '0';
				serialiser_reqw <= '0';
				serialiser_req_out <= '0';
			when loading =>
				shiftReg_enable <= '1';
				serialiser_reqw <= '1';
				serialiser_req_out <= '0';
				
				
			when outputting =>
				shiftReg_enable <= '0';
				serialiser_reqw <= '0';
				serialiser_req_out <= '1';
				
			when bit_done =>
				shiftReg_enable <= '0';
				serialiser_reqw <= '0';
				serialiser_req_out <= '0';
				
			when byte_done =>
				shiftReg_enable <= '0';
				serialiser_reqw <= '0';
				serialiser_req_out <= '0';
				
		end case;
	end process;
	
	
	
	
	shiftOutReg : shiftreg_piso
	port map(
		clk => clk,
		sclr => sclr,
		load => shiftReg_load,
		data => fifo_q,
		shiftout => shiftReg_bit,
		enable_out => shiftReg_enable,
		shiftpos => bits_shifted_cnt_us		
	);
	bits_shifted_cnt <= 7 - to_integer(bits_shifted_cnt_us);
	
	
	
	
	serial_out : ws2812b_serialiser
	port map(
		clk => clk,
		reqw => serialiser_reqw,
		bit_value_in => shiftReg_bit,
		req_out => serialiser_req_out,
		output => serial_output,
		busy_flag => serialiserBusy 
	);
	
	
	serialOut <= serial_output;
	

end architecture;