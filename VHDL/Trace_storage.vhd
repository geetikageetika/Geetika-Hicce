----------------------------------------------------------------------------------
--! @file trc_storage.vhd
--! @brief 
-- Company: ICTP
-- Engineer: L. G. Garcia  
-- 
-- Create Date: 21.10.2019 11:56:00
-- Design Name: trace_str.vhd
-- Module Name: Trace Store - Behavioral
-- Project Name: INFN_PAMP
-- Target Devices: CIAA_ACC, ZEDBOARD ZYNQ 7020
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - max_count set combinational TODO: increase count when TRIG = 1;
-- Revision 1.00 - Fix Issue with EOT missing.
-- Version 2 Rev 1 -Modified to be used in the context of the HICCE project.
-- Additional Comments:
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity trace_str is
    Generic(DWidth : integer :=32;
            REG_WIDTH : integer :=32;
            TSRES : integer :=64;
            FIFO_SIZE : integer := 1024);
    Port (
    --NATIVE PORTS
    --! CLK AND RESET SIGNALS
    CLK         : IN STD_LOGIC;
    RSTN        : IN STD_LOGIC;
    --! DATA INPUT 
    DIN         : IN STD_LOGIC_VECTOR (DWidth-1 DOWNTO 0);
    DVALID      : IN STD_LOGIC;
    READY       : IN STD_LOGIC;

    --! Timestamp Info
    TIME_IN   : IN STD_LOGIC_VECTOR(64 -1 downto 0);
    TS_CORRECTION : IN STD_LOGIC;

    --! DATA OUTPUT SIGNALS AXIS MASTER BUS
    maxis_tdata  : out STD_LOGIC_VECTOR(DWidth -1 downto 0);
    maxis_tvalid : out STD_LOGIC;
    maxis_tkeep  : out STD_LOGIC_VECTOR(DWidth/8 - 1 downto 0);
    maxis_tready : in STD_LOGIC;
    maxis_tlast  : out STD_LOGIC;

    --! FIFO Signals
    FIFO_CLEAR : out STD_LOGIC;
    FIFO_AFULL : IN STD_LOGIC;

    --! Registers
    SBE         : IN STD_LOGIC_VECTOR  (REG_WIDTH-1 DOWNTO 0); --! Samples Before Event
    SAE         : IN STD_LOGIC_VECTOR  (REG_WIDTH-1 DOWNTO 0); --! Samples After Event

    --! Debug signals, TODO: Remove this debug signals
    debug_count : out STD_LOGIC_VECTOR(31 DOWNTO 0);
    debug_max_count : out STD_LOGIC_VECTOR(31 DOWNTO 0);
    debug_state : out std_logic_vector (2 downto 0);

    TRIG        : IN STD_LOGIC --! Trigger Signal
   );
end trace_str;

architecture Behavioral of trace_str is

    --! State machine, states declaration
    --! RST_STATE: Reset condition
    --! WAIT_STATE: Wait for trigger state
    --! COUNT_STATE: Coung for the number of samples before and after is reached.

    type state is (RST_STATE, WAIT_STATE, COUNT_STATE,WRITE_HEAD, WRITE_TSMSB, WRITE_TSLSB, WRITE_EOH);
    signal c_state, n_state : state; --Defining current state and next state.

    signal tlast : std_logic; --! Defining AXI aux signals.
    signal count, max_count : integer; --! Counter signals
    signal trans : std_logic; --! Keep transfer if trigger happens before 

    --! Header record definition

    signal event_number : unsigned(7 downto 0);

    constant SOH : std_logic_vector(7 downto 0) := x"01"; --! Start of Header
    constant SOT : std_logic_vector(7 downto 0) := x"02"; --! Start of Header
    constant EOTXT : std_logic_vector(7 downto 0) := x"03"; --! End of Text
    constant EOT : std_logic_vector(7 downto 0) := x"04"; --! End of Transmission

    type pack_structure is record
        CEN : std_logic_vector(7 downto 0); --! Correlative Event Number
        SBT : std_logic_vector(7 downto 0); --! Samples Before Trigger
        SAT : std_logic_vector(7 downto 0); --! Samples After Trigger
        TSMSB : std_logic_vector(31 downto 0); --! Timestamp MSB
        TSLSB : std_logic_vector(31 downto 0); --! Timestamp LSB
        TC : std_logic; --! Timestamp correction
        ERR : STD_LOGIC; --! Error or incomplete message
    end record;

    signal cpack, hpack : pack_structure; --! Current pacakge and Hold package 

    --timestamp declaration

    type TS_RECORD is record
        ts : std_logic_vector(TSRES -1 DOWNTO 0);
        trig : std_logic;
        clear : std_logic;
        isUp : std_logic;
    end record TS_RECORD;

    signal iTimeStamp : TS_RECORD;

    component timestamp is
        generic(CLK_RES : INTEGER :=TSRES);
        port (
        CLK  : IN STD_LOGIC;
        RSTN : IN STD_LOGIC;
    
        C_COUNT : IN STD_LOGIC_VECTOR(CLK_RES-1 DOWNTO 0);
        TS : OUT STD_LOGIC_VECTOR(CLK_RES - 1 DOWNTO 0);
        
        
        STAMPED : OUT STD_LOGIC; --STAMPED flag high until CLEAR is received. 
        CLEAR : IN STD_LOGIC; --CLEAR timestamp 
        STAMP : IN STD_LOGIC --STAMP signal
        ) ;
    end component timestamp ; 


    begin 



    iTimeStamp.trig<=TRIG;

    TS_GEN : timestamp
    generic map(CLK_RES => TSRES)
    port map(
    CLK     => CLK, 
    RSTN    => RSTN, 
    C_COUNT => TIME_IN, 
    TS      => iTimeStamp.ts, 
    STAMPED => iTimeStamp.isUp, 
    CLEAR   => iTimeStamp.clear, 
    STAMP   => iTimeStamp.trig
    ) ;


    --!DEBUG SIGNALS TODO: REMOVE THIS SIGNALS
    debug_count<=std_logic_vector(to_unsigned(count, 32));
    debug_max_count<=std_logic_vector(to_unsigned(max_count, 32));


    --! Package preparation logic.
    cpack.CEN<=std_logic_vector(event_number);
    cpack.SBT<=SBE(7 downto 0);
    cpack.SAT<=SAE(7 downto 0);
    cpack.TSMSB<=iTimeStamp.ts(63 downto 32);
    cpack.TSLSB<=iTimeStamp.ts(31 downto 0);
    cpack.TC<=TS_CORRECTION;
    cpack.ERR<='0';

    --! COUNTER process
    process(CLK, RSTN, DVALID, max_count, c_state)
    begin
        if RSTN ='0' then 
            count<=0;
        elsif rising_edge(CLK) then
            if c_state= COUNT_STATE then
                if count>=max_count - 1 and DVALID = '1' then
                    count<=0;
                elsif  DVALID = '1' then
                    count<=count+1;
                end if;
            else 
                count<=0;
            end if;
        end if;
    end process;

    tlast<='1' when count >= (max_count - 1) else '0'; --! Tlast generator

    --! STATE MACHINE PROCESSES
    --! Change State process;
    process(CLK, RSTN)
    begin
        if RSTN='0' then
        c_state<=RST_STATE;
        elsif rising_edge(CLK) then
        c_state<=n_state;
        end if;
    end process;


    max_count<= FIFO_SIZE when to_integer(unsigned(SBE))+to_integer(unsigned(SAE))+1 > FIFO_SIZE else
                to_integer(unsigned(SBE))+to_integer(unsigned(SAE))+1; --!max_count=SBE+SAE+1


    FIFO_CLEAR<= '1' when c_state = RST_STATE else '0'; 

    -- Current state process
    process(c_state, DVALID, maxis_tready, SBE, SAE, TRIG)
    begin
        case (c_state) is
            when RST_STATE =>
                maxis_tdata   <= (others=>'0');  
                maxis_tvalid <='0';
                maxis_tkeep  <=(others=>'0');
                maxis_tlast  <='0';
                iTimeStamp.clear<='1';
                debug_state<="000";

            when WAIT_STATE =>
                maxis_tdata  <=DIN;  
                maxis_tvalid <='0';
                maxis_tkeep  <=(others=>'1');
                maxis_tlast  <='0';
                iTimeStamp.clear<='0';
                debug_state<="001";

            when WRITE_HEAD =>
                maxis_tdata  <=SOH & hpack.CEN & SOT & SOT;  
                maxis_tvalid <=maxis_tready;
                maxis_tkeep  <=(others=>'1');
                maxis_tlast  <=tlast;
                iTimeStamp.clear<='0';
                debug_state<="010";

            when WRITE_TSMSB =>
                maxis_tdata  <=hpack.TSMSB;  
                maxis_tvalid <=maxis_tready;
                maxis_tkeep  <=(others=>'1');
                maxis_tlast  <=tlast;
                iTimeStamp.clear<='0';
                debug_state<="011";

            when WRITE_TSLSB =>
                maxis_tdata  <=hpack.TSLSB;  
                maxis_tvalid <=maxis_tready;
                maxis_tkeep  <=(others=>'1');
                maxis_tlast  <=tlast;
                iTimeStamp.clear<='0';
                debug_state<="100";

            when COUNT_STATE =>
                maxis_tdata  <=DIN;  
                maxis_tvalid <=DVALID and maxis_tready;
                maxis_tkeep  <=(others=>'1');
                maxis_tlast  <=tlast;
                iTimeStamp.clear<='0';
                debug_state<="101";

            when WRITE_EOH =>
                maxis_tdata  <=EOT & hpack.CEN & hpack.TC & "00000000000000" & hpack.ERR;  
                maxis_tvalid <=maxis_tready;
                maxis_tkeep  <=(others=>'1');
                maxis_tlast  <=tlast;
                iTimeStamp.clear<='1';
                debug_state<="110";
                
        end case;
    end process;


    --! Next state process
    process(c_state, TRIG, maxis_tready, count, max_count, FIFO_AFULL)
    begin
        case (c_state) is
            when RST_STATE =>
                n_state<=WAIT_STATE;
                event_number<=x"00";
            when WAIT_STATE =>
                if TRIG = '1' and maxis_tready='1' and FIFO_AFULL='0' then
                    hpack<=cpack;
                    n_state<=WRITE_HEAD;
                else
                    n_state<=WAIT_STATE;
                end if;
            when WRITE_HEAD =>
                if FIFO_AFULL = '1' then
                    hpack.ERR<='1';
                    n_state<=WRITE_EOH;
                else
                    n_state<=WRITE_TSMSB;
                end if;
            when WRITE_TSMSB =>
                if FIFO_AFULL = '1' then
                    hpack.ERR<='1';
                    n_state<=WRITE_EOH;
                else
                    n_state<=WRITE_TSLSB;
                end if;
            when WRITE_TSLSB =>
                if FIFO_AFULL = '1' then
                    hpack.ERR<='1';
                    n_state<=WRITE_EOH;
                else
                    n_state<=COUNT_STATE;
                end if;
            when COUNT_STATE =>
                if FIFO_AFULL = '1' then
                    hpack.ERR<='1';
                    n_state<=WRITE_EOH;
                elsif (count>=max_count - 1) or (maxis_tready = '0') then
                    n_state<=WRITE_EOH;
                else
                    n_state<=COUNT_STATE;
                end if;    
            when WRITE_EOH =>
                n_state<=WAIT_STATE;
                if event_number = x"ff" then
                    event_number<=x"00";
                else
                    event_number<=event_number+1;
                end if;
        end case;    
    end process;


    
end;