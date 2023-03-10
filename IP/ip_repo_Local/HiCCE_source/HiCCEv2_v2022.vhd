---------------------------------------------------------------------------
-- Company              : RRCAT Indore & M-LAB, ICTP, TRIESTE 
-- Engineer             : K. M. KHARE, Kasun S. Mannatunga, M. L. CRESPO, A. Cicuttin and M. MAGNASCO
-- Create Date          : June 16, 2016 at 10:00 Hrs 
-- Design Name          : Data Acquisition using Intan Chips for 128 channels, DAQ_HiCCE_128_v0
-- Module Name          : Main_DAQ_HiCCE_128_Version1 
-- Project Name         : Data Acquisition using HiCCE Board  
-- Target Devices       : ZYNQ 7 series, XC7S-Z7020-1clg484
-- Tool versions        : Vivado 2016.1 
-- Description          : All the 4 intan chips are acquiring the data simultaneously
--                      : Data read is sequential through PC, mode 1, sequential access of channel data
-- 				        : Tested with Dr. Liz Software and successfully acquired the data.
--                      : Mode of acquisition is GUI Selectable
--                      : By selecting the ADC_VIRTUAL mode, data from virtual could be acquired
--                      : Virtual ADC data is Sine Wave, phase shifted for different channels
--                      : Configurable Digital potentiometers from GUI/PC selecatble Band Width. 
-- Revision             : ZYNQ Board Version 2, Revision: 01 
-- Additional Comments  :   
-- Last Modified on     : June 20, 2016, at 18:00 Hrs 
---------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.all;
use IEEE.std_logic_MISC.all;
use IEEE.std_logic_UNSIGNED.all;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;
--use work.FRONTPANEL.all;


entity HiCCEv2_v2022 is
    Port ( 
-------------------------
-- Global Signals
-------------------------
    Sys_Clock              :    in std_logic;                        -- System Clock, 100 Mhz, onboard
    Sys_Reset              :    in std_logic;                        -- System Reset, Active low  
    FIFO_clk               :    in std_logic;
-------------------------
-- AXI Interface Signals
-------------------------   
    Read_intan            :    in std_logic_vector(3 downto 0);    -- Read Enable of intan data 
    Ack_intan             : out std_logic_vector(3 downto 0);

    Config_Res_intan_A    : in std_logic_vector(15 downto 0);  -- configuration of Intan chips A and digital resistors
    Config_Res_intan_B    : in std_logic_vector(15 downto 0);  -- configuration of Intan chips B and digital resistors
    Config_Res_intan_C    : in std_logic_vector(15 downto 0);  -- configuration of Intan chips C and digital resistors
    Config_Res_intan_D    : in std_logic_vector(15 downto 0);  -- configuration of Intan chips D and digital resistors                
    
    Data_intan_A          : out std_logic_vector(15 downto 0); -- Data out from FIFOs of respective intan ( data_A & data_B & data_C & data_D )        
    Data_intan_B          : out std_logic_vector(15 downto 0); 
    Data_intan_C          : out std_logic_vector(15 downto 0); 
    Data_intan_D          : out std_logic_vector(15 downto 0); 
    
    Data_valid            : out std_logic_vector(3 downto 0);   -- addeed new line of code, 29/07/2018
   
-----------------------------------
-- FMC Interface: HiCEE Board LEDs 
-----------------------------------     
    LED_HiCCE_AB           : out std_logic_vector(1 downto 0);   --LOC="H5" #FMC sig: LA17_N_CC, FMC PIN: D21, Fpga Pad: L43N_GCLK22_3  --LOC="J6" #FMC sig: LA17_P_CC, FMC PIN: D20, Fpga Pad: L43P_GCLK23_3    
------------------------------------------------------
-- FMC Interface: -- ADC_AD7982 Interface A, B, C, D
------------------------------------------------------        
    ADC_SDO               : in std_logic_vector(3 downto 0);   --LOC="A6" #FMC sig: LA14_N, FMC PIN: C19, Fpga Pad: L4N_0
    ADC_CNV               : out std_logic_vector(3 downto 0);   --LOC="K3" #FMC sig: LA18_P_CC, FMC PIN: C22, Fpga Pad: L42P_GCLK25_3
    ADC_SCLK              : out std_logic_vector(3 downto 0);   --LOC="J4" #FMC sig: LA18_N_CC, FMC PIN: C23, Fpga Pad: L42N_GCLK24_3    
------------------------------------------------------
-- FMC Interface: INTAN CHIP_A, B, C, D
------------------------------------------------------
-- INTAN Chips, Digital Control Signals
    Elec_Test             : out std_logic_vector(3 downto 0);
    Elec_Test_en          : out std_logic_vector(3 downto 0);   --LOC="B2" #FMC sig: LA27_P, FMC PIN: C26, Fpga Pad: L52P_3
    Conn_All              : out std_logic_vector(3 downto 0);   --LOC="A2" #FMC sig: LA27_N, FMC PIN: C27, Fpga Pad: L52N_3
    Settle                : out std_logic_vector(3 downto 0);   --LOC="E7" #FMC sig: LA01_P_CC, FMC PIN: D8, Fpga Pad: L36P_GCLK15_0
    Sel0_Reset            : out std_logic_vector(3 downto 0);   --LOC="E8" #FMC sig: LA01_N_CC, FMC PIN: D9, Fpga Pad: L36N_GCLK14_0
    Sel1_Step             : out std_logic_vector(3 downto 0);   --LOC="C13"#FMC sig: LA05_P, FMC PIN: D11, Fpga Pad: L63P_0
    Sel2_Sync             : inout std_logic_vector(3 downto 0); --LOC="A13"#FMC sig: LA05_N, FMC PIN: D12, Fpga Pad: L63N_0
    Sel3                  : inout std_logic_vector(3 downto 0); --LOC="C9" #FMC sig: LA09_P, FMC PIN: D14, Fpga Pad: L34P_GCLK19_0
    Sel4                  : inout std_logic_vector(3 downto 0); --LOC="A9" #FMC sig: LA09_N, FMC PIN: D15, Fpga Pad: L34N_GCLK18_0
    Mode                  : out std_logic_vector(3 downto 0);   --LOC="F7" #FMC sig: LA13_P, FMC PIN: D17, Fpga Pad: L5P_0
-- Clock Swithing signals
    CLK_SWITCH_INT_A      : out std_logic;
    CLK_SWITCH_INT_B      : out std_logic;
    CLK_SWITCH_INT_C      : out std_logic;
    CLK_SWITCH_INT_D      : out std_logic;
-- Virtual ADC interface
    ADC_SDO_VIRTUAL_A     : in std_logic;
    
    FIFO_READ_ENB         : in  std_logic_vector(3 downto 0);    
    FIFO_empty            : out std_logic_vector(3 downto 0)
);
end HiCCEv2_v2022;

architecture Behavioral of HiCCEv2_v2022 is

    COMPONENT intan_RHA_ADC_v0
      PORT (
    --------------------------------
    -- FMC Interface: COMMON SIGNALS
    --------------------------------			  
            SYS_CLK           : in  std_logic; 				-- Input SYS_CLK
            FIFO_clk          : in  std_logic; 				-- TI, Internal Clock
            SYS_RESET         : in  std_logic; 				-- Input SYSTEM RESET 
            DAQ_Start         : in  std_logic; 				-- Input to start data acquisition  
            CONFIG_RES_IN     : in  std_logic_vector(10 downto 0); 
            FIFO_WRITE_ENB    : in STD_LOGIC;
            FIFO_READ_ENB     : in  std_logic;				-- FIFO READ ENABLE	
            FIFO_DATA_OUT     : out std_logic_vector(15 downto 0); -- FIFO 16 BIT DATA OUT  	
            FIFO_READ_ACK     : out std_logic; 				-- FIFO ready to be read
            FIFO_empty        : out STD_LOGIC;
            LED_TEST_1		  : out std_logic; 				-- For Test Signal
            LED_TEST_2		  : out std_logic; 				-- For Test Signal	
            CLK_SWITCH        : out std_logic; 				-- CLock for internal data switching 
    -----------------------------------------------------
    -- FMC Interface: INTAN CHIP(Digital Control signals)
    -----------------------------------------------------
            TEST_EN  		    : out std_logic;
            CONN_ALL		    : out std_logic;
            SETTLE       	    : out std_logic;
            SEL0_RESET   	    : out std_logic;
            SEL1_STEP    	    : out std_logic;
            SEL2_SYNC           : inout std_logic;
            SEL3     	        : inout std_logic;
            SEL4     	        : inout std_logic;
            MODE     		    : out std_logic;
    -----------------------------
    -- FMC Interface: ADC(AD7982)
    -----------------------------
            SDO_DATA_IN 	    : in  std_logic;
            CNV_CONVERT_OUT     : out std_logic;
            SCLK_CLOCK_OUT	    : out std_logic 
          );
    END COMPONENT;

	
	signal reset_active_high : std_logic;
	
	---------------------------------
    -- Intan Chip Interface
    ---------------------------------
	signal DAQ_Start_Stop_A, DAQ_Start_Stop_B, DAQ_Start_Stop_C, DAQ_Start_Stop_D   : std_logic;
    signal Config_Reg_A     : std_logic_vector(10 downto 0):="00000000000";                         -- configuration register for inten block A
    signal Config_Reg_B     : std_logic_vector(10 downto 0):="00000000000";                         -- configuration register for inten block B
    signal Config_Reg_C     : std_logic_vector(10 downto 0):="00000000000";                         -- configuration register for inten block C
    signal Config_Reg_D     : std_logic_vector(10 downto 0):="00000000000";                         -- configuration register for inten block D
    signal FIFO_read_A_int, FIFO_read_B_int, FIFO_read_C_int, FIFO_read_D_int       : std_logic;
    signal data_FIFO_A, data_FIFO_B, data_FIFO_C, data_FIFO_D                       : std_logic_vector(15 downto 0);
    signal fifo_ack_A, fifo_ack_B, fifo_ack_C, fifo_ack_D                           : std_logic;
    
    -----------------------------------
    -- LED TEST and Reset Signals in HiCCE board
    ------------------------------------
    signal LED_TEST_1A, LED_TEST_2A, LED_TEST_1B, LED_TEST_2B, LED_TEST_1C, LED_TEST_2C, LED_TEST_1D, LED_TEST_2D : std_logic;
    
    ---------------------------------
    -- ADC Interface
    ---------------------------------
    signal ADC_SDO_A_int, ADC_SDO_B_int, ADC_SDO_C_int, ADC_SDO_D_int   : std_logic; 
    
    signal Virtual_Mode_A, Virtual_Mode_B, Virtual_Mode_C, Virtual_Mode_D               : std_logic;
    
    signal FIFO_empty_A, FIFO_empty_B, FIFO_empty_C, FIFO_empty_D : std_logic;
    signal Mode_A, Mode_B, Mode_C, Mode_D : std_logic;
    signal Mode_ABCD, mode_intan_ABCD : std_logic_vector(3 downto 0);
    signal FIFO_write_A_int, FIFO_write_B_int, FIFO_write_C_int, FIFO_write_D_int : std_logic;
begin

    reset_active_high <= not Sys_Reset;         -- Sys_Reset(axi reset, which is active low) converted to active high
    
    Elec_Test <= "0000";                -- only ued in the HiCCE version 2
    
-- for enable the appropriate block for store data in fifo
    FIFO_write_A_int <= Read_intan(3);
    FIFO_write_B_int <= Read_intan(2);
    FIFO_write_C_int <= Read_intan(1);
    FIFO_write_D_int <= Read_intan(0);

-- for start appropriate block                      
    DAQ_Start_Stop_A    <=  Config_Res_intan_A(2); 
    DAQ_Start_Stop_B    <=  Config_Res_intan_B(2); 
    DAQ_Start_Stop_C    <=  Config_Res_intan_C(2); 
    DAQ_Start_Stop_D    <=  Config_Res_intan_D(2); 

-- for Config_Reg_X configuration for Intan                 
    Config_Reg_A    <= Config_Res_intan_A(10 downto 0); 
    Config_Reg_B    <= Config_Res_intan_B(10 downto 0); 
    Config_Reg_C    <= Config_Res_intan_C(10 downto 0); 
    Config_Reg_D    <= Config_Res_intan_D(10 downto 0); 
   
------------------------------------------------------------
-- READ INTAN_A/B/C/D acquired data in respective FIFO's
-- Used to select INTAN CHIP_X FIFO DATA, to transmit to PC
------------------------------------------------------------
    FIFO_read_A_int <= FIFO_READ_ENB(3);        
    FIFO_read_B_int <= FIFO_READ_ENB(2);      
    FIFO_read_C_int <= FIFO_READ_ENB(1);       
    FIFO_read_D_int <= FIFO_READ_ENB(0);  

--------------------------------------------------------------------
--                Asigning for the data registers           --
--------------------------------------------------------------------
    Data_intan_A <= data_FIFO_A;
    Data_intan_B <= data_FIFO_B;
    Data_intan_C <= data_FIFO_C;
    Data_intan_D <= data_FIFO_D;
    
--------------------------------------------------------------------
--                Asigning data valid sgnals           --
--------------------------------------------------------------------    
    Data_valid <= (not FIFO_empty_A) & (not FIFO_empty_B) & (not FIFO_empty_C) & (not FIFO_empty_D);
       
------------------------------------------------------------------------
--                  Connect ack_intan Register                        --
------------------------------------------------------------------------
    ack_intan   <= fifo_ack_A & fifo_ack_B & fifo_ack_C & fifo_ack_D; 

   
-- for virtual mode selection                    
    Virtual_Mode_A      <= Config_Res_intan_A(0);
    Virtual_Mode_B      <= Config_Res_intan_B(0);
    Virtual_Mode_C      <= Config_Res_intan_C(0);
    Virtual_Mode_D      <= Config_Res_intan_D(0);

----------------------------------
-- ADC OR Virtual ADC data select
----------------------------------
    ADC_SDO_A_INT  <= ADC_SDO(3) when Virtual_Mode_A ='0' else          -- if (Config_Res_intan_A bit 0) is 0 actual ADC select
                      ADC_SDO_VIRTUAL_A;
    ADC_SDO_B_INT  <= ADC_SDO(2) when Virtual_Mode_B ='0' else
                      ADC_SDO_VIRTUAL_A;
    ADC_SDO_C_INT  <= ADC_SDO(1) when Virtual_Mode_C ='0' else
                      ADC_SDO_VIRTUAL_A;						
    ADC_SDO_D_INT  <= ADC_SDO(0) when Virtual_Mode_D ='0' else
                      ADC_SDO_VIRTUAL_A;


--------------------------
-- INTAN A CHIP PORT MAP
--------------------------
INTAN_CHIP_A: intan_RHA_ADC_v0
	port map (
-- FMC Interface: COMMON SIGNALS  
				SYS_CLK         => Sys_Clock,
				FIFO_clk  	    => FIFO_clk,
				SYS_RESET       => reset_active_high,       -- SYS_RESET is active high
				DAQ_Start       => DAQ_Start_Stop_A,        -- Input to start data acquisition 
				CONFIG_RES_IN   => Config_Reg_A,          -- Confoguration Register 
				FIFO_WRITE_ENB  => FIFO_write_A_int,        -- new line 22/07/2018
				FIFO_READ_ENB   => FIFO_read_A_int,       -- FIFO READ ENABLE (INTAN_ADC_A)	
				FIFO_DATA_OUT   => data_FIFO_A,           -- FIFO 16 BIT DATA OUT (INTAN_ADC_A) 				
				FIFO_READ_ACK   => fifo_ack_A,       -- FIFO READ ACKNOLEDGE(DONE) 
				FIFO_empty      => FIFO_empty_A,
				LED_TEST_1      => LED_TEST_1A, 
				LED_TEST_2      => LED_TEST_2A,
				CLK_SWITCH      => CLK_SWITCH_INT_A,
-- FMC Interface: INTAN CHIP(Chip Digital Control signals)
				TEST_EN  		=> Elec_Test_en(3),
				CONN_ALL		=> Conn_All(3), 
				SETTLE       	=> Settle(3), 
				SEL0_RESET   	=> Sel0_Reset(3), 
				SEL1_STEP    	=> Sel1_Step(3),
				SEL2_SYNC    	=> Sel2_Sync(3),
				SEL3     		=> Sel3(3), 
				SEL4     		=> Sel4(3),     
				MODE     		=> Mode_A,  
-- FMC Interface: ADC(AD7982)
				SDO_DATA_IN		=> ADC_SDO_A_INT, 
				CNV_CONVERT_OUT => ADC_CNV(3),
				SCLK_CLOCK_OUT	=> ADC_SCLK(3)      -- Serial Clock for ADC & Virtual ADC
				); 
		
--------------------------
-- INTAN B CHIP PORT MAP
--------------------------
INTAN_CHIP_B: intan_RHA_ADC_v0
	port map (
-- FMC Interface: COMMON SIGNALS  
				SYS_CLK         => Sys_Clock,
				FIFO_clk  	    => FIFO_clk,
				SYS_RESET       => reset_active_high,       -- SYS_RESET is active high
				DAQ_Start       => DAQ_Start_Stop_B,        -- Input to start data acquisition 
				CONFIG_RES_IN   => Config_Reg_B,          -- Confoguration Register 
				FIFO_WRITE_ENB  => FIFO_write_B_int,        -- new line 22/07/2018
				FIFO_READ_ENB   => FIFO_read_B_int,       -- FIFO READ ENABLE (INTAN_ADC_A)	
				FIFO_DATA_OUT   => data_FIFO_B,           -- FIFO 16 BIT DATA OUT (INTAN_ADC_A) 				
				FIFO_READ_ACK   => fifo_ack_B,       -- FIFO READ ACKNOLEDGE(DONE) 
				FIFO_empty      => FIFO_empty_B,
				LED_TEST_1      => LED_TEST_1B, 
				LED_TEST_2      => LED_TEST_2B,
				CLK_SWITCH      => CLK_SWITCH_INT_B,
-- FMC Interface: INTAN CHIP(Chip Digital Control signals)
				TEST_EN  		=> Elec_Test_en(2),
				CONN_ALL		=> Conn_All(2), 
				SETTLE       	=> Settle(2), 
				SEL0_RESET   	=> Sel0_Reset(2), 
				SEL1_STEP    	=> Sel1_Step(2),
				SEL2_SYNC    	=> Sel2_Sync(2),
				SEL3     		=> Sel3(2), 
				SEL4     		=> Sel4(2),     
				MODE     		=> Mode_B,  
-- FMC Interface: ADC(AD7982)
				SDO_DATA_IN		=> ADC_SDO_B_INT, 
				CNV_CONVERT_OUT => ADC_CNV(2),
				SCLK_CLOCK_OUT	=> ADC_SCLK(2) -- Serial Clock for ADC & Virtual ADC
				); 

-------------------------
-- INTAN C CHIP PORT MAP
-------------------------
INTAN_CHIP_C: intan_RHA_ADC_v0
	port map (
-- FMC Interface: COMMON SIGNALS  
				SYS_CLK         => Sys_Clock,
				FIFO_clk  	    => FIFO_clk,
				SYS_RESET       => reset_active_high,       -- SYS_RESET is active high
				DAQ_Start       => DAQ_Start_Stop_C,        -- Input to start data acquisition 
				CONFIG_RES_IN   => Config_Reg_C,          -- Confoguration Register 
				FIFO_WRITE_ENB  => FIFO_write_C_int,        -- new line 22/07/2018
				FIFO_READ_ENB   => FIFO_read_C_int,       -- FIFO READ ENABLE (INTAN_ADC_A)	
				FIFO_DATA_OUT   => data_FIFO_C,           -- FIFO 16 BIT DATA OUT (INTAN_ADC_A) 				
				FIFO_READ_ACK   => fifo_ack_C,       -- FIFO READ ACKNOLEDGE(DONE) 
				FIFO_empty      => FIFO_empty_C,
				LED_TEST_1      => LED_TEST_1C, 
				LED_TEST_2      => LED_TEST_2C,
				CLK_SWITCH      => CLK_SWITCH_INT_C,
-- FMC Interface: INTAN CHIP(Chip Digital Control signals)
				TEST_EN  		=> Elec_Test_en(1),
				CONN_ALL		=> Conn_All(1), 
				SETTLE       	=> Settle(1), 
				SEL0_RESET   	=> Sel0_Reset(1), 
				SEL1_STEP    	=> Sel1_Step(1),
				SEL2_SYNC    	=> Sel2_Sync(1),
				SEL3     		=> Sel3(1), 
				SEL4     		=> Sel4(1),     
				MODE     		=> Mode_C,  
-- FMC Interface: ADC(AD7982)
				SDO_DATA_IN		=> ADC_SDO_C_INT, 
				CNV_CONVERT_OUT => ADC_CNV(1),
				SCLK_CLOCK_OUT	=> ADC_SCLK(1)      -- Serial Clock for ADC & Virtual ADC
				); 
			
--------------------------
-- INTAN D CHIP PORT MAP
--------------------------
INTAN_CHIP_D: intan_RHA_ADC_v0
	port map (
-- FMC Interface: COMMON SIGNALS  
				SYS_CLK         => Sys_Clock,
				FIFO_clk  	    => FIFO_clk,
				SYS_RESET       => reset_active_high,       -- SYS_RESET is active high
				DAQ_Start       => DAQ_Start_Stop_D,        -- Input to start data acquisition 
				CONFIG_RES_IN   => Config_Reg_D,          -- Confoguration Register 
				FIFO_WRITE_ENB  => FIFO_write_D_int,        -- new line 22/07/2018
				FIFO_READ_ENB   => FIFO_read_D_int,       -- FIFO READ ENABLE (INTAN_ADC_A)	
				FIFO_DATA_OUT   => data_FIFO_D,           -- FIFO 16 BIT DATA OUT (INTAN_ADC_A) 				
				FIFO_READ_ACK   => fifo_ack_D,       -- FIFO READ ACKNOLEDGE(DONE) 
				FIFO_empty      => FIFO_empty_D,
				LED_TEST_1      => LED_TEST_1D, 
				LED_TEST_2      => LED_TEST_2D,
				CLK_SWITCH      => CLK_SWITCH_INT_D,
-- FMC Interface: INTAN CHIP(Chip Digital Control signals)
				TEST_EN  		=> Elec_Test_en(0),
				CONN_ALL		=> Conn_All(0), 
				SETTLE       	=> Settle(0), 
				SEL0_RESET   	=> Sel0_Reset(0), 
				SEL1_STEP    	=> Sel1_Step(0),
				SEL2_SYNC    	=> Sel2_Sync(0),
				SEL3     		=> Sel3(0), 
				SEL4     		=> Sel4(0),     
				MODE     		=> Mode_D,  
-- FMC Interface: ADC(AD7982)
				SDO_DATA_IN		=> ADC_SDO_D_INT, 
				CNV_CONVERT_OUT => ADC_CNV(0),
				SCLK_CLOCK_OUT	=> ADC_SCLK(0)      -- Serial Clock for ADC & Virtual ADC
				); 

    FIFO_empty <= FIFO_empty_A & FIFO_empty_B & FIFO_empty_C & FIFO_empty_D;
    Mode_ABCD <= Mode_A & Mode_B & Mode_C & Mode_D;
    mode_intan_ABCD <= Config_Res_intan_A(1) & Config_Res_intan_B(1) & Config_Res_intan_C(1) & Config_Res_intan_D(1);
    
    Mode <= Mode_ABCD or mode_intan_ABCD;
-----------------------------------------						
-- TEST LED 1 & 2 (INTAN and Shuttle LX1)
-----------------------------------------
                               
    LED_HiCCE_AB  <= (LED_TEST_1A OR LED_TEST_1B OR LED_TEST_1C OR LED_TEST_1D) & (LED_TEST_2A OR LED_TEST_2B OR LED_TEST_2C OR LED_TEST_2D);

end Behavioral;
