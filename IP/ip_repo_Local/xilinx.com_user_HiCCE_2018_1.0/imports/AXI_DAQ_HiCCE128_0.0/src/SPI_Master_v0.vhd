----------------------------------------------------------------------------------
-- Company       	: RRCAT, INDORE  
-- Engineer      	: K. M. KHARE
-- 
-- Create Date   	: October, 14, 2013 at 10:00 Hrs 
-- Design Name   	: Testing of Digital potentiometers
-- Module Name   	: Testing of SPI Interface - Behavioral 
-- Project Name  	: Intan and ADC Interface 
-- Target Devices	: Spartan 6, XC6S-LX16-2FTG256
-- Tool versions 	: ISE 14.2
-- Description   	: 
-- Revision      	: Version 3, Revision 01 
-- Revision 0.01 -: File Created
-- Additional Comments: Implementtion of SPI interface for Digital Potentiometer
--                  
-- Last Modified on   : October, 29, 2013 at 18:00 Hrs 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SPI_Master_v0 is
	PORT(
		SYS_CLK   	: IN   STD_LOGIC;                             -- system CLK
		RESET 		: IN   STD_LOGIC;                             -- asynchronous reset(Active LOW)
		BW_SELECT   : IN   STD_LOGIC_VECTOR(1 downto 0);          -- Band Width Select
		SCLK    	: OUT  STD_LOGIC;                             -- SPI CLK
		CHIP_SEL    : OUT  STD_LOGIC_VECTOR(11 downto 0);         -- slave select
		MOSI    	: OUT  STD_LOGIC;							  -- Master out, slave in DATA
        ACK_SPI     : OUT  STD_LOGIC         		
      );
end SPI_Master_v0;
architecture Behavioral of SPI_Master_v0 is

  type statetype is(ready, execute);                           	-- state statetype data type
  signal state       : statetype;                              	-- current state

  SIGNAL count       : INTEGER range 0 to 32;                     -- counter to trigger SCLK from CLK
  SIGNAL clk_toggles : INTEGER RANGE 0 TO 34;     		            -- count spi CLK toggles
  SIGNAL SCLK_INT    : STD_LOGIC;                            		-- Internal Serial clock
  SIGNAL last_bit_tx : INTEGER := 32;         		      			-- last Tx data bit(2* data bits)
  signal assert_data : STD_LOGIC;
  signal CS_INT      : STD_LOGIC;
  
  signal count_slave : STD_LOGIC_VECTOR(3 downto 0);
  signal count_next  : STD_LOGIC_VECTOR(5 downto 0);
  signal DATA_INT_C, DATA_INT_L, DATA_INT_H1, DATA_INT_H2 : STD_LOGIC_VECTOR(7 downto 0);
  signal DATA_TX, buffer_tx   : STD_LOGIC_VECTOR(15 DOWNTO 0); 	-- transmit data buffer 
  signal CLK_SLAVE   : STD_LOGIC;
  signal INCR_SLAVE  : STD_LOGIC;
  signal ENABLE_INT  : STD_LOGIC;
  signal CLK_1Mhz    : STD_LOGIC;
  signal clk_div     : STD_LOGIC_VECTOR(3 downto 0);
  signal BW_SELCT_INT: STD_LOGIC_VECTOR(1 downto 0);
begin
--------------------------------------------
-- Clock Division(Should be less than 5 Mhz)
--------------------------------------------
process(SYS_CLK, RESET)
begin
if(reset = '1') then        								         -- Reset system (Active high)
    clk_div <= "0000";    										      -- Deassert slave select          							-- go to ready state with reset
elsif(SYS_CLK'event and SYS_CLK = '1') then	
--      if clk_div ="11000" then
--		   clk_div <= "00000";
--      else			
		clk_div <= clk_div + '1';
--		end if;
end if;		 
end process;  

CLK_1Mhz <= clk_div(3);  

process(CLK_1Mhz, RESET)
begin
if(reset = '1') then        								         -- Reset system (Active high)
    count_next <= "000000";    										-- Deassert slave select          							-- go to ready state with reset
elsif(CLK_1Mhz'event and CLK_1Mhz = '1') then
	  count_next <= count_next + '1';
end if;		 
end process;  

CLK_SLAVE  <= '1' when count_next= "111111" else
              '0';
INCR_SLAVE <= '1' when count_next= "111111" else
              '0';

ENABLE_INT <= 	INCR_SLAVE;			  
---------------------
-- Slave Selection
---------------------
process(CLK_SLAVE, RESET)
begin
if(reset = '1') then        								         -- Reset system (Active High)
    count_slave <= "0000";    										-- Deassert slave select          							-- go to ready state with reset
elsif(CLK_SLAVE'event and CLK_SLAVE = '1') then
    if (count_slave="1101") then
	     ACK_SPI  <= '1';
    else
 	     ACK_SPI  <= '0';
	  end if;	  
    if (count_slave="1110") then
	     count_slave <= "1110";
    else
		  count_slave <= count_slave + '1';
	 end if;	
end if;	 
end process;   

--ACK_SPI    <= '1' when count_slave = "1101"  else
--				  '0';

---------------------------------------------------------------------					  
 -- Assingment of Chip Select 
 -- Chip Select for Variable Resisotr(Band Width Selection Resistor) 
 -- CS_SetH1, CS_SetH2, CS_SetL 
---------------------------------------------------------------------

CHIP_SEL <= CS_INT &      "11111111111"  when count_slave ="0001" else          -- CS_SetL, DATA_INT_L
			   '1' & CS_INT & "1111111111"  when count_slave ="0010" else       -- CS_SetH2, DATA_INT_H2
				"11" & CS_INT & "111111111"  when count_slave ="0011" else      -- CS_SetH1, DATA_INT_H1
				"111" & CS_INT & "11111111"  when count_slave ="0100" else
				"1111" & CS_INT & "1111111"  when count_slave ="0101" else
				"11111" & CS_INT & "111111"  when count_slave ="0110" else
				"111111" & CS_INT & "11111"  when count_slave ="0111" else
				"1111111" & CS_INT & "1111"  when count_slave ="1000" else
				"11111111" & CS_INT & "111"  when count_slave ="1001" else
				"111111111" & CS_INT & "11"  when count_slave ="1010" else
				"1111111111" & CS_INT & '1'  when count_slave ="1011" else
				"11111111111" & CS_INT       when count_slave ="1100" else
				"111111111111"; 

----------------------------------------
-- Band Width Selection Resistors(INTAN)
--------------------------------------------------------------------------------------
-- "SetL" (DATA_INT_L : 000-Narrower Band, 255-Wider Band): for lowest freq limit set
-- "SetH2"(DATA_INT_H2: 128-Narrower Band, 002-Wider Band): for highets freq limit set
-- "SetH1"(DATA_INT_H1: 125-Narrower Band, 002-Wider Band): for highets freq limit set
-- Control Word (DATA_INT_C: "00000000"- -- Write into Wiper register (Volatile values)
-- Control Word (DATA_INT_C: "00100000"- -- Write into Nonvolatile(NV)register 
---------------------------------------------------------------------------------------

BW_SELCT_INT <= BW_SELECT;

DATA_INT_C  <= "00000000";      -- Write into Wiper register (Volatile values)

DATA_INT_L <=  "00000000" when BW_SELCT_INT = "01" else  -- narrower BW  	--(from 1 KHz)
               "11111111" when BW_SELCT_INT = "11" else  -- wider BW 		--(from 0.75 KHz)
			   "00000000";                         
DATA_INT_H2 <= "10000000" when BW_SELCT_INT = "01" else  -- narrower BW		--(up to 1 KHz)
               "00000010" when BW_SELCT_INT = "11" else  -- wider BW 		--(up to 20 KHz)
			   "00000000";                    
DATA_INT_H1 <= "01101001" when BW_SELCT_INT = "01" else  -- narrower BW --(up to 1 KHz)
               "00000010" when BW_SELCT_INT = "11" else  -- wider BW	--(up to 20 KHz)			  
               "00000000";
					
DATA_TX <= DATA_INT_C & DATA_INT_L  when count_slave ="0001" else
           DATA_INT_C & DATA_INT_H2 when count_slave ="0010" else 
		   DATA_INT_C & DATA_INT_H1 when count_slave ="0011" else
		   DATA_INT_C & DATA_INT_L  when count_slave ="0100" else
		   DATA_INT_C & DATA_INT_H2 when count_slave ="0101" else
		   DATA_INT_C & DATA_INT_H1 when count_slave ="0110" else
		   DATA_INT_C & DATA_INT_L  when count_slave ="0111" else
		   DATA_INT_C & DATA_INT_H2 when count_slave ="1000" else 
		   DATA_INT_C & DATA_INT_H1 when count_slave ="1001" else
           DATA_INT_C & DATA_INT_L  when count_slave ="1010" else
           DATA_INT_C & DATA_INT_H2 when count_slave ="1011" else
           DATA_INT_C & DATA_INT_H1 when count_slave ="1100" else
		   "0000000000000000";

process(CLK_1Mhz, RESET)
begin
if(reset = '1') then                 					-- Reset system (Active High)
   CS_INT   <= '1';    										-- Deassert slave select
   MOSI     <= 'Z';                						-- Set master out to high impedance
   SCLK_INT <= '1';                                -- Initialise the serial clock
	assert_data <= '1';
   state <= ready;             							-- go to ready state with reset
elsif(CLK_1Mhz'event and CLK_1Mhz = '1') then
	CASE (state) is              							--state statetype
		when ready =>
					CS_INT   <= '1'; 							-- set all slave select outputs high
					MOSI     <= 'Z';             	  		-- set MOSI output high impedance
					assert_data <= '1';				
						if(ENABLE_INT = '1') then      		-- User input to initiate transaction  
							buffer_tx   <= DATA_TX;    	-- Data to transmit
							clk_toggles <= 0;        		-- Initiate CLK toggle counter
							SCLK_INT <= '1';			      -- Initiate Serial Clock
							assert_data <= '0';				-- Initiate data assert			
							state <= execute;        		-- proceed to execute state			   
                  else
					      state <= ready;          		   --remain in ready state
                  end if;
      when execute =>
                CS_INT <= '0'; 						     --set slave select output
            		if(clk_toggles = 34) then
							clk_toggles <= 0;               --reset spi CLK toggles counter
						else
							clk_toggles <= clk_toggles + 1; --increment spi CLK toggles counter
						end if;
				     
						if (CS_INT = '0' and clk_toggles <= 32) then 
							SCLK_INT <= NOT SCLK_INT; 							--toggle SPI CLK
						end if;
																		--transmit SPI DATA 
						if(assert_data = '1' AND clk_toggles < last_bit_tx) then  
							MOSI 		 <= buffer_tx(15);                -- CLK out MSB data bit
							buffer_tx <= buffer_tx(14 downto 0) & '0'; -- shift data transmit buffer
						end if;
																		--end of transaction
						if(clk_toggles = 34) THEN   
							CS_INT   <= '1';    					-- Set slave selects High
                     MOSI     <= 'Z';             		-- set MOSI output high impedance
							state <= ready;          			-- return to ready state
						else                       		
						count <= count + 1; 						-- increment counter
						assert_data <= not assert_data;  	-- Change assert for serial data shift
						state <= execute;        				-- remain in execute state
						end if;
      end case;
    end if;
  end process; 
  
SCLK     <= SCLK_INT;                              	-- Assingment of Serial Clock
                           
end Behavioral;