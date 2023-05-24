----------------------------------------------------------------------------------
-- Company       	: M-Lab, ICTP, TRIESTE  
-- Engineer      	: L. GARCIA, K M KHARE, A. CICUTTIN, M. L. CRESPO, M. MAGNASCO
-- 
-- Create Date   	: May 11 2023 at 10:00 Hrs 
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

entity intan_RHA_ADC_v1 is
 GENERIC(SYS_CLK_T_ns : INTEGER :=250);
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
end intan_RHA_ADC_v1;

architecture Behavioral of intan_RHA_ADC_v1 is

signal sys_resetn : std_logic;

-----------------------------------------------------------------------------------------------
-------------- FIFO Primitive component ---------------------------------------------
-----------------------------------------------------------------------------------------------


-- COMPONENT FIFO_64k_16bit_v0

--   PORT (
-- 		rst 			 : IN STD_LOGIC;
-- 		wr_clk 			 : IN STD_LOGIC;
-- 		rd_clk 			 : IN STD_LOGIC;
-- 		din 			 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
-- 		wr_en 			 : IN STD_LOGIC;
-- 		rd_en 			 : IN STD_LOGIC;
-- 		dout 			 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
-- 		full 			 : OUT STD_LOGIC;
-- 		empty 			 : OUT STD_LOGIC
--   );
-- END COMPONENT;


-----------------------------------------------------------------------------------------------
-------------- SYNCHRONOUS COUNTER FOR SYNTETIC GENERATED SIGNAL ---------------------------------------------
-----------------------------------------------------------------------------------------------

COMPONENT synchronous_counter is
	port (
	  clk         : in std_logic;
	  reset       : in std_logic;
	  count       : out std_logic_vector(15 downto 0)
	);
  end COMPONENT;

  signal virtual_count : std_logic_vector(15 downto 0);
-----------------------------------------------------------------------------------------------
-------------- SPI CONTROL SIGNALS AND COMPONENTS ---------------------------------------------
-----------------------------------------------------------------------------------------------

COMPONENT spi_master IS
GENERIC(
  slaves  : INTEGER := 1;  --number of spi slaves
  d_width : INTEGER := 24); --data bus width
PORT(
  clock   : IN     STD_LOGIC;                             --system clock
  reset_n : IN     STD_LOGIC;                             --asynchronous reset
  enable  : IN     STD_LOGIC;                             --initiate transaction
  cpol    : IN     STD_LOGIC;                             --spi clock polarity
  cpha    : IN     STD_LOGIC;                             --spi clock phase
  cont    : IN     STD_LOGIC;                             --continuous mode command
  clk_div_i : IN   STD_LOGIC_VECTOR(31 DOWNTO 0);         --system clock cycles per 1/2 period of sclk
  addr_i    : IN   STD_LOGIC_VECTOR(31 DOWNTO 0);         --address of slave
  tx_data : IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
  miso    : IN     STD_LOGIC;                             --master in, slave out
  sclk    : BUFFER STD_LOGIC;                             --spi clock
  ss_n    : BUFFER STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);   --slave select
  mosi    : OUT    STD_LOGIC;                             --master out, slave in
  busy    : OUT    STD_LOGIC;                             --busy / data ready signal
  rx_data : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0)); --data received
END COMPONENT spi_master;

COMPONENT AD7982_CNV is
    generic(tcnv : integer :=50);
    Port(
    rst_n     : in std_logic;
    clk       : in std_logic;

    enable_tx  : in std_logic;
    spi_cs     : in std_logic;
    spi_sclk   : in std_logic;
    spi_busy   : in std_logic;
    
    busy       : out std_logic;
	cnv        : out std_logic;
	sclk       : out std_logic;
    enable_spi : out std_logic
    );
end COMPONENT;

signal spi_clk_div : std_logic_vector(31 downto 0);
signal spi_data : std_logic_vector(17 downto 0);
signal spi_sclk : std_logic;
signal adc_sclk : std_logic;

signal ss_n : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal cnv_enable : std_logic;
signal adc_read : std_logic;
signal spi_busy : std_logic;
signal adc_busy : std_logic;

-- Common Signals

signal CONFIG_RES_TEMP   	: STD_LOGIC_VECTOR(10 downto 0);


------------------------------
--for new state machine
------------------------------
  type state_type is (st_reset, st_idle, st_read_ADC, st_next_ch); 
  signal cstate, nstate : state_type; 

------------------------------
--FIFO Signals
------------------------------

  signal FIFO_FULL    : STD_LOGIC;

  signal fifo_wr_en, fifo_wr_en_new : std_logic;

  signal data_adc: std_logic_vector (15 downto 0);

--------------------------------
-- Auto read Mode
--------------------------------
signal settle_intan, resetn_intan, step_intan, sync_intan, mode_INTAN : STD_LOGIC;
signal CLK_SWITCH_INT      : STD_LOGIC; 

signal virtual_mode : std_logic;

begin

----------------------------------------------------------------------------
-- Intan Digital Input COnfiguration for Manual OR Auto(Sequential) Reading 
---------------------------------------------------------------------------- 
--(Reserve Bits & SETTLE & SEL4 & SEL3 & SEL2 & SEL1 & SEL0 & TEST_ENB & CONN_ALL & DAQ_Start_Stop & READ_MODE & VIRTUAL MODE)	

	sys_resetn 			<= not SYS_RESET;

	CONFIG_RES_TEMP 	<= CONFIG_RES_IN;

	virtual_mode		<= CONFIG_RES_TEMP(0);   	
	
	MODE_INTAN	   		<= CONFIG_RES_TEMP(1);        -- Selection of Read Mode(Manual('0')/Auto_Sequential('1'))
	
	CONN_ALL			<= CONFIG_RES_TEMP(3);
	
	test_en     		<= CONFIG_RES_TEMP(4);
    
	SEL0_reset  		<= CONFIG_RES_TEMP(5) when MODE_INTAN = '0' else -- Active LOW RESET
							(resetn_intan and CONFIG_RES_TEMP(5));          -- modified on 22/07/2018; old = not sys_resetn; now you can reset intan through register also
							
	SEL1_step   		<= CONFIG_RES_TEMP(6) when MODE_INTAN = '0' else
							step_intan;	      
	
	SEL2_SYNC  			<= CONFIG_RES_TEMP(7) when MODE_INTAN = '0' else
							'Z';
							sync_intan  <= SEL2_SYNC;

	SEL3 				<= CONFIG_RES_TEMP(8) when MODE_INTAN = '0' else
							'Z';

	SEL4 				<= CONFIG_RES_TEMP(9) when MODE_INTAN = '0' else
							'Z';          
																		
	settle      		<= CONFIG_RES_TEMP(10) when MODE_INTAN = '0' else
	                       (SYS_RESET or CONFIG_RES_TEMP(10));	
		                       	
	MODE <= MODE_INTAN;


	
----------------------------------------------------------------------------
-- LEDs Logic 
---------------------------------------------------------------------------- 
	
	LED_TEST_2 <= FIFO_FULL;   -- TEST LEDs
	LED_TEST_1 <= sel2_sync;   -- TEST LEDs

----------------------------------------------------------------------------
-- Ramp generator
---------------------------------------------------------------------------- 
-- Instantiate the synchronous_counter component

		virtual_counter: synchronous_counter
		port map (
		  clk         => SYS_CLK,
		  reset       => virtual_mode,
		  count       => virtual_count
		);
	
----------------------------------------------------------------------------
-- ADC7982 SPI logic 
---------------------------------------------------------------------------- 

	--To achieve 500-710 ns of conversion time and 290 ns of acquisition time
	--Using a 100 MHz clk and an SPI clk division of 1 ( ns/bit)
	--SPI_CLK_T= 2*SYS_CLK_T_ns*SPI_CLK_DIV=2*(10ns)*(1)=20 ns
	--Acquisition time = 20ns * 18 = 360 ns.
	--Conversion time= 1000ns - 360 ns = 640 ns
	--Conversion time= Conversion Time/SYS_CLK Period=640ns/10ns=64
	--removing one for state machine latency 

	spi_clk_div<=std_logic_vector(to_unsigned(1,32));

    AD7982_CTRL: AD7982_CNV
    generic map(
      tcnv => 64-1
      )
    Port map(
    rst_n      =>sys_resetn,
    clk        =>SYS_CLK,
    enable_tx  => adc_read, --Start ADC read capture
    spi_cs     => ss_n(0),
	spi_sclk   => spi_sclk,
    spi_busy   => spi_busy,
	busy 	   => adc_busy,
    cnv        => CNV_CONVERT_OUT,
	sclk	   => adc_sclk,
    enable_spi => cnv_enable
    );


    AD7982_spi: spi_master
    GENERIC MAP(
      slaves  => 1, 
      d_width => 18
    )
    PORT MAP(
      clock   => SYS_CLK,
      reset_n => sys_resetn,
      enable  => cnv_enable,
      cpol    => '0',
      cpha    => '1',
      cont    => '0',
      clk_div_i => SPI_CLK_DIV, 
      addr_i    => (others=>'0'), --SPI.addr -1
      tx_data => (others=>'0'), 
      miso    => SDO_DATA_IN,
      sclk    => spi_sclk,
      ss_n    =>ss_n, 
      mosi    => open,
      busy    =>spi_busy,
      rx_data =>spi_data
    );


	SCLK_CLOCK_OUT<=adc_sclk;
	data_adc <= spi_data(17 downto 2) when virtual_mode = '0' else
	virtual_count;

-------------------------------
-- FIFO Generation (8K_16Bits) --Left for legacy, removed to be used with comblock fifo instead
-------------------------------

-- ZYNQ_Reads_FIFO : FIFO_64k_16bit_v0

--   PORT MAP  (
-- 		      rst 		    => SYS_RESET,                   -- fifo reset is active high
-- 		      wr_clk 	    => SYS_CLK,                     -- to be checked
-- 		      rd_clk 	    => FIFO_clk,
-- 		      din 		    => data_adc, 		-- because we expect only positive values !!!
-- 		      wr_en 	    => fifo_wr_en_new,               -- modified 22/07/2018, old = fifo_wr_en
-- 		      rd_en 	    => FIFO_READ_ENB,  				-- same as with DPM --could be ("not empty" and "pipeO_read")
-- 		      dout 		    => FIFO_DATA_OUT,				-- OUT DATA tobe read from PC
-- 		      full 		    => FIFO_FULL, --open,    		-- we are not using these flags
-- 		      empty 	    => FIFO_empty
--             );

    fifo_wr_en_new <= FIFO_WRITE_ENB and fifo_wr_en;

	--Signals remaped to keep port names.

	FIFO_DATA_OUT	<= data_adc when FIFO_READ_ENB = '1' else (others=>'0');
	FIFO_FULL		<= '0';
	FIFO_empty		<= not fifo_wr_en_new;

----------------------------------------------------------------------------
-- State machine for sequential counting
---------------------------------------------------------------------------- 

	--FSM for intan readout

	--sync process
	process (SYS_CLK, sys_resetn)
	begin
		if sys_resetn = '0' then
			cstate<=st_reset;
		elsif rising_edge(SYS_CLK) then
			cstate<=nstate;
		end if;	
	end process;

	--next state process
	process (cstate, adc_busy, DAQ_start, FIFO_FULL)
	begin
		case cstate is
			when st_reset =>
				if DAQ_start = '1' then
					nstate<=st_read_ADC;
				else
					nstate<=st_reset;
				end if;
			when st_idle =>
				if DAQ_start = '0' then
					nstate<=st_reset;
				else
					nstate<=st_read_ADC;
				end if;
			when st_read_ADC =>
				if FIFO_FULL = '1' then 
					nstate<=st_reset;
				elsif adc_busy = '1' then
					nstate<=st_read_ADC;
				elsif FIFO_FULL = '0' then
					nstate<=st_next_ch;
				else
					nstate<=st_idle;
				end if;			
			when st_next_ch =>
				if DAQ_start = '1' and adc_busy = '0' then
					nstate<=st_read_ADC;
				else
					nstate<=st_idle;
				end if;
			when others =>
				nstate<=st_reset;
		end case;
	end process;

	--Current state process
	process (cstate)
	begin
		case cstate is
			when st_reset =>
				adc_read 	<='0';
				fifo_wr_en 	<='0';
				resetn_intan<='0';
				step_intan 	<='0';
			when st_idle =>
				adc_read 	<='0';
				fifo_wr_en 	<='0';
				resetn_intan<='1';
				step_intan 	<='0';
			when st_read_ADC =>
				adc_read	<='1';
				fifo_wr_en	<='0';
				resetn_intan <='1';
				step_intan 	<='0';			
			when st_next_ch =>
				adc_read	<='0';
				fifo_wr_en	<='1';
				resetn_intan <='1';
				step_intan 	<='1';	
			when others =>
				adc_read 	<='0';
				fifo_wr_en 	<='0';
				resetn_intan <='0';
				step_intan 	<='0';
		end case;
	end process;

	FIFO_READ_ACK  <= sel2_sync;
	CLK_SWITCH <= step_intan;
end Behavioral;