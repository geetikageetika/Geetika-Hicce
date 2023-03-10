----------------------------------------------------------------------------------
-- Company       	: M-Lab, ICTP, TRIESTE  
-- Engineer      	: K M KHARE, A. CICUTTIN, M. L. CRESPO, M. MAGNASCO
-- 
-- Create Date   	: September, 18, 2013 at 10:00 Hrs 
-- Design Name   	: HiCCE Control Card
-- Module Name   	: My_intan_ADC_Ver3 - Behavioral 
-- Project Name  	: Intan and ADC Interface with HiCCE Lx1 Card 
-- Target Devices	: ZYNQ , XC7Z-7020-1FTG484
-- Tool versions 	: ISE 14.2
-- Description   	: 
--
-- Dependencies  	: 
--
-- Revision      	: Version 3, Revision 01 
-- Revision 0.01 -: File Created
-- Additional Comments: Implementaed the Sequential Access of the Intan Multiplexer output
--                    : Required to set Mode='1'(Sequential Access)    
--                    :                 Mode='0'(Random Access) of Multiplexer Output                    
-- Last Modified on   : October 21, 2013 at 18:00 Hrs 
--------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_MISC.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity intan_RHA_ADC_v0 is
 PORT (
--------------------------------
-- COMMON INTERFACE SIGNALS
--------------------------------			  
		SYS_CLK         : in  STD_LOGIC; 		-- Input SYS_CLK
		FIFO_clk          : in  STD_LOGIC; 		-- TI, Internal Clock
		SYS_RESET       : in  STD_LOGIC;		-- Input SYSTEM RESET, active high
		DAQ_start       : in  STD_LOGIC; 		-- Input to start DAQ
        CONFIG_RES_IN   : in  STD_LOGIC_VECTOR(10 downto 0); 
        FIFO_WRITE_ENB  : in STD_LOGIC;
        FIFO_READ_ENB   : in  STD_LOGIC;		
        FIFO_DATA_OUT   : out STD_LOGIC_VECTOR(15 downto 0); 
		FIFO_READ_ACK   : out STD_LOGIC;                  --FIFO_FULL
		FIFO_empty      : out STD_LOGIC;
		LED_TEST_1		: out STD_LOGIC; 		-- For Test Signal (FIFO_FULL)
		LED_TEST_2		: out STD_LOGIC; 		-- For Test Signal			
		CLK_SWITCH      : out STD_LOGIC;
------------------------------------------------------
-- FMC Interface: INTAN CHIP (Digital Control signals)
------------------------------------------------------
		TEST_EN  		: out STD_LOGIC; 		-- LOC="B2" #FMC sig: LA27_P, FMC PIN: C26, Fpga Pad: L52P_3
		CONN_ALL		: out STD_LOGIC; 		-- LOC="A2" #FMC sig: LA27_N, FMC PIN: C27, Fpga Pad: L52N_3
		SETTLE       	: out STD_LOGIC; 		-- LOC="E7" #FMC sig: LA01_P_CC, FMC PIN: D8, Fpga Pad: L36P_GCLK15_0
		SEL0_RESET   	: out STD_LOGIC; 		-- LOC="E8" #FMC sig: LA01_N_CC, FMC PIN: D9, Fpga Pad: L36N_GCLK14_0
		SEL1_STEP    	: out STD_LOGIC; 		-- LOC="C13"#FMC sig: LA05_P, FMC PIN: D11, Fpga Pad: L63P_0
		SEL2_SYNC       : inout STD_LOGIC; 	-- LOC="A13"#FMC sig: LA05_N, FMC PIN: D12, Fpga Pad: L63N_0
		SEL3     	    : inout STD_LOGIC; 	-- LOC="C9" #FMC sig: LA09_P, FMC PIN: D14, Fpga Pad: L34P_GCLK19_0
		SEL4     	    : inout STD_LOGIC; 	-- LOC="A9" #FMC sig: LA09_N, FMC PIN: D15, Fpga Pad: L34N_GCLK18_0
		MODE     		: out STD_LOGIC; 		-- LOC="F7" #FMC sig: LA13_P, FMC PIN: D17, Fpga Pad: L5P_0
-----------------------------
-- FMC Interface: ADC(AD7982)
-----------------------------
		SDO_DATA_IN 	: in  STD_LOGIC; 		-- LOC="A6" #FMC sig: LA14_N, FMC PIN: C19, Fpga Pad: L4N_0
		CNV_CONVERT_OUT : out STD_LOGIC; 		-- LOC="K3" #FMC sig: LA18_P_CC, FMC PIN: C22, Fpga Pad: L42P_GCLK25_3
		SCLK_CLOCK_OUT  : out STD_LOGIC  		-- LOC="J4" #FMC sig: LA18_N_CC, FMC PIN: C23, Fpga Pad: L42N_GCLK24_3
      );	
end intan_RHA_ADC_v0;

architecture Behavioral of intan_RHA_ADC_v0 is

COMPONENT FIFO_64k_16bit_v0

  PORT (
		rst 			 : IN STD_LOGIC;
		wr_clk 			 : IN STD_LOGIC;
		rd_clk 			 : IN STD_LOGIC;
		din 			 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		wr_en 			 : IN STD_LOGIC;
		rd_en 			 : IN STD_LOGIC;
		dout 			 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		full 			 : OUT STD_LOGIC;
		empty 			 : OUT STD_LOGIC
  );
END COMPONENT;

-- Common Signals

signal CONFIG_RES_TEMP   	: STD_LOGIC_VECTOR(10 downto 0);

---------------------------------------------------------
-- Internal signals (same as ports but with prefix "sig_")
-- Signals for the INTEN CHIP
---------------------------------------------------------
signal sig_SDO_data_in		: STD_LOGIC;	--for debuging channel by channel only !
signal sig_CNV_convert_out	: STD_LOGIC;			
signal sig_SCLK_clock_out	: STD_LOGIC;

-----------------------------------------------------------

signal sel_out					: STD_LOGIC_VECTOR(4 DOWNTO 0);	--for debuging channel by channel only !

-- for the new process to read ADC
  constant tconv: Integer := 72 ; -- 500 ns < TcnvH < 710 ns
-- larger than the 710ns ADC max conversion time
-- acording to the application note
    constant TcnvH  : std_logic_vector(6 downto 0):="1000110";   -- 10 ns < TcnvH 
    constant TacqL  : Integer := 72 ; -- 290 ns < TacqL
    constant TstepH : Integer := 30 ; 
    constant Tcyc   : std_logic_vector(6 downto 0) := "1101110"; -- 1000 ns

------------------------------
--for new state machine
------------------------------
  type state_type is (st_reset, st_cnv, st_wcnv, st_L17_1, st_H17_1, st_L0, st_H0, st_step_new_high, st_step_new_low, st_CYCwait, st_CYCend, st_FIFO_write); 
  signal state, next_state : state_type; 
  signal count_cnv    : std_logic_vector(6 downto 0); --to count 2 (up to 3) clock cycles (10ns < "Tcnvh" < 500ns)
  signal count_wcnv   : std_logic_vector(6 downto 0); --to count 72 (up to 127) clock cycles (500ns < Tconv < 710ns)
  signal count_data   : std_logic_vector(4 downto 0); --to count 17 (up to 31) clock cycles (the 18 bits of serial data)	
  signal counter_out  : std_logic_vector(15 downto 0);  
  signal counter_cyc  : std_logic_vector(6 downto 0);
  
  signal FIFO_FULL    : STD_LOGIC;

  signal fifo_wr_en, fifo_wr_en_new : std_logic;

  signal data_adc: std_logic_vector (17 downto 0);

--------------------------------
-- Auto read Mode
--------------------------------
signal settle_intan, reset_intan, step_intan, sync_intan, mode_INTAN : STD_LOGIC;
signal CLK_SWITCH_INT      : STD_LOGIC; 

begin
-- Common Signals

	CONFIG_RES_TEMP <= CONFIG_RES_IN;

----------------------------------------------------------------------------
-- Intan Digital Input COnfiguration for Manual OR Auto(Sequential) Reading 
---------------------------------------------------------------------------- 
--(Reserve Bits & SETTLE & SEL4 & SEL3 & SEL2 & SEL1 & SEL0 & TEST_ENB & CONN_ALL & DAQ_Start_Stop & READ_MODE & VIRTUAL MODE)	

	MODE_INTAN	   	<= CONFIG_RES_TEMP(1);        -- Selection of Read Mode(Manual('0')/Auto_Sequential('1'))

	settle      		<= CONFIG_RES_TEMP(10) when MODE_INTAN = '0' else
	                       (sys_reset or CONFIG_RES_TEMP(10));	
	sel4     	 		<= CONFIG_RES_TEMP(9) when MODE_INTAN = '0' else
                           'Z';
    sel3 			   	<= CONFIG_RES_TEMP(8) when MODE_INTAN = '0' else
	                       'Z';  
	sel2_sync   		<= CONFIG_RES_TEMP(7) when MODE_INTAN = '0' else
	                       'Z';
	sel1_step   		<= CONFIG_RES_TEMP(6) when MODE_INTAN = '0' else
	                       CLK_SWITCH_INT;	                     	                                    
	sel0_reset  		<= CONFIG_RES_TEMP(5) when MODE_INTAN = '0' else -- Active LOW RESET
	                       (not sys_reset and CONFIG_RES_TEMP(5));          -- modified on 22/07/2018; old = not sys_reset; now you can reset intan through register also
	test_en     		<= '0';                                              -- modified on 14/08/2018; old = "test_en <= CONFIG_RES_TEMP(4) when MODE_INTAN = '0' else '0'";
	conn_all    		<= '0';                                              -- modified on 14/08/2018; old = "test_en <= CONFIG_RES_TEMP(3) when MODE_INTAN = '0' else '0'";

	
---------------------------------------------
--ADC Interface signals
	sig_SDO_data_in 	<= SDO_data_in;		
	CNV_convert_out 	<= sig_CNV_convert_out;			
	SCLK_clock_out		<= sig_SCLK_clock_out;	
	CLK_SWITCH          <= CLK_SWITCH_INT;
---------------------------------------------

-------------------------------
-- FIFO Generation (8K_16Bits)
-------------------------------

ZYNQ_Reads_FIFO : FIFO_64k_16bit_v0

  PORT MAP  (
		      rst 		    => sys_reset,                   -- fifo reset is active high
		      wr_clk 	    => sys_clk,                     -- to be checked
		      rd_clk 	    => FIFO_clk,
		      din 		    => data_adc(16 downto 1), 		-- because we expect only positive values !!!
		      wr_en 	    => fifo_wr_en_new,               -- modified 22/07/2018, old = fifo_wr_en
		      rd_en 	    => FIFO_READ_ENB,  				-- same as with DPM --could be ("not empty" and "pipeO_read")
		      dout 		    => FIFO_DATA_OUT,				-- OUT DATA tobe read from PC
		      full 		    => FIFO_FULL, --open,    		-- we are not using these flags
		      empty 	    => FIFO_empty
            );

    fifo_wr_en_new <= FIFO_WRITE_ENB and fifo_wr_en;            --new line added 22/07/2018
-------------------------------------------------
-- New Code (To increment the Sequential Counting)
-------------------------------------------------

LED_TEST_2 <= FIFO_FULL;         -- TEST LEDs
LED_TEST_1 <= sel2_sync;   -- TEST LEDs

------------------------------------------------------------------
-- Insert the following in the architecture after the begin keyword
-- State Machine 
-- For Reading ADC and Generating Parallel DATA
-- 
------------------------------------------------------------------
 
SYNC_PROC: process (sys_reset, DAQ_start, sys_clk, FIFO_FULL, state)
begin
if (sys_reset = '1' OR DAQ_start = '0') then
		  state <= st_reset;		  
elsif (sys_clk'event and sys_clk = '1') then
			state <= next_state;

	 case (state) is
		when st_reset =>
				count_cnv <= "0000000";
				count_wcnv <=  "0000000";
				count_data <= "00000";	
--				counter_out <= x"0000";
				counter_cyc <= "0000000";
			    data_adc <= "000000000000000000";
		when st_cnv =>
				count_cnv <= count_cnv + "1";
				count_wcnv <= count_wcnv + "1";
				counter_cyc <= counter_cyc + "1";
				data_adc <= "000000000000000000";
        when st_L17_1 =>
                counter_cyc <= counter_cyc + "1";
		when st_H17_1 =>
		        counter_cyc <= counter_cyc + "1";
				count_data <= count_data + "1";
				data_adc <= data_adc(16 downto 0) & sig_SDO_data_in;  --shift left and concatenate with SDO input bit;		
		when st_L0 =>
		      counter_cyc <= counter_cyc + "1";
		when st_H0 =>
                counter_cyc <= counter_cyc + "1";
                count_cnv <= "0000000";
                count_wcnv <=  "0000000";				
                count_data <= "00000";
                data_adc <= data_adc(16 downto 0) & sig_SDO_data_in;  --shift left and concatenate with SDO input bit;	
		when st_FIFO_write =>
              counter_cyc <= counter_cyc + "1";
		when st_CYCwait =>
		      counter_cyc <= counter_cyc + "1";
		when st_CYCend =>
		      counter_cyc <= "0000000";
		when others => 
				counter_cyc <= counter_cyc + "0";
				count_cnv <= count_cnv + "0";
				count_wcnv <= count_wcnv + "0";
				count_data <= count_data + "0";
		end case;  
end if;
end process;

---------------------------------------------------------
-- MOORE State-Machine - Outputs based on state only
---------------------------------------------------------
OUTPUT_DECODE: process (state, counter_out, FIFO_FULL)
  begin
      --insert statements to decode internal output signals
	 case (state) is
		when st_reset =>
				sig_SCLK_clock_out  <= '0';
				sig_CNV_convert_out <= '0';
				fifo_wr_en 			<= '0'; 
	            CLK_SWITCH_INT      <= '0';   -- Added Code
		when st_cnv =>
				sig_SCLK_clock_out  <= '0';
				sig_CNV_convert_out <= '1';
				fifo_wr_en           <= '0'; 
				CLK_SWITCH_INT       <= '0';

		when st_L17_1 =>
				sig_SCLK_clock_out   <= '0'; 
				sig_CNV_convert_out  <= '0';
				fifo_wr_en           <= '0'; 		
				CLK_SWITCH_INT       <= '1';
		when st_H17_1 =>
				sig_SCLK_clock_out   <= '1'; 
				sig_CNV_convert_out  <= '0';
				fifo_wr_en           <= '0'; 
				CLK_SWITCH_INT       <= '1';
		when st_L0 =>
				sig_SCLK_clock_out   <= '0'; 
				sig_CNV_convert_out  <= '0';
				fifo_wr_en           <= '0'; 
				CLK_SWITCH_INT       <= '0';

		when st_H0 =>
				sig_SCLK_clock_out   <= '1'; 
				sig_CNV_convert_out  <= '0';
				fifo_wr_en           <= '0';
				CLK_SWITCH_INT       <= '0';

		when st_FIFO_write =>
            sig_SCLK_clock_out   <= '0'; 
            sig_CNV_convert_out  <= '0';
            CLK_SWITCH_INT       <= '0';
                if FIFO_FULL='1' then -- if counter_out = x"2000" then -- Reading 8K FIFO   
                    fifo_wr_en <= '0';             -- new modification !!!!!!!!!!!!!!
                else
                    fifo_wr_en <= '1';             -- write enable of the FIFO  --new modification !!!!!!!!!!!!!!
                end if;  
                     
		when st_CYCwait =>
		      sig_SCLK_clock_out   <= '0'; 
              sig_CNV_convert_out  <= '0';
              CLK_SWITCH_INT       <= '0';
              fifo_wr_en 		   <= '0';
        
        when st_CYCend =>
            sig_SCLK_clock_out   <= '0'; 
            sig_CNV_convert_out  <= '0';
            CLK_SWITCH_INT       <= '0';
            fifo_wr_en           <= '0';
        
        when others =>
            sig_SCLK_clock_out   <= '0'; 
            sig_CNV_convert_out  <= '0';
            CLK_SWITCH_INT       <= '0';
            fifo_wr_en           <= '0';     
		end case;
end process;

NEXT_STATE_DECODE: process (state, count_cnv, count_wcnv, count_data, counter_cyc, FIFO_FULL)
begin
	--declare default state for next_state to avoid latches
	next_state <= state;  --default is to stay in current state
	--insert statements to decode next_state
	case (state) is

	when st_reset =>
		next_state <= st_cnv;

	when st_cnv =>
		if (count_cnv > TcnvH)  then  --to stay 50 clock cycles(500 ns --modified on 04/08/2018, old=count_cnv > 1
		  next_state <= st_L17_1;
		else
		  next_state <= st_cnv;
		end if;  

	when st_L17_1 =>
		next_state <= st_H17_1;
		
	when st_H17_1 =>
		if count_data > 15  then 			-- to be carefully checked !!! --to acquire 17 bits
		  next_state <= st_L0;
		else
		  next_state <= st_L17_1;
		end if;  

	when st_L0 =>
		next_state <= st_H0;   				-- to acquire the last bit
		
	when st_H0 =>      					   --We should remain in this state after FIFO_FULL='1'   
		next_state <= st_FIFO_write;  
    
    when st_FIFO_write =>
        next_state <= st_CYCwait;
    
    when st_CYCwait =>
        if(counter_cyc > Tcyc) then
            next_state <= st_CYCend;
        else
            next_state <= st_CYCwait;
        end if;
	
    when st_CYCend =>
        if FIFO_FULL='1' then
            next_state <= st_CYCend;
        else
            next_state <= st_cnv;
        end if;
        
	when others =>
		next_state <= st_reset;
	end case;      
end process;

FIFO_READ_ACK  <= FIFO_FULL;

end Behavioral;