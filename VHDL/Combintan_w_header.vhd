----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2022 03:14:40 AM
-- Design Name: 
-- Module Name: CombIntan_w_header - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CombIntan_w_header is
    Generic(ts_resolution : integer :=64; 
            FIFO_SIZE : integer :=32768);
    Port ( sys_clk : in STD_LOGIC;
           sys_rstn : in STD_LOGIC;
        
           DinA : in STD_LOGIC_VECTOR (15 downto 0);
           DinB : in STD_LOGIC_VECTOR (15 downto 0);
           DinC : in STD_LOGIC_VECTOR (15 downto 0);
           DinD : in STD_LOGIC_VECTOR (15 downto 0);
           DataIn_valid : in STD_LOGIC_VECTOR (3 downto 0);
           Data_Rd_En : out STD_LOGIC_VECTOR (3 downto 0);

           HICCE_ACK_i : in STD_LOGIC;           
           timestamp_i : in STD_LOGIC_VECTOR(ts_resolution -1 downto 0);

            --! FIFO Signals
           FIFO_CLEAR_AB : out STD_LOGIC;
           FIFO_AFULL_AB : IN STD_LOGIC;
           FIFO_CLEAR_CD : out STD_LOGIC;
           FIFO_AFULL_CD : IN STD_LOGIC;

           DoutAB : out STD_LOGIC_VECTOR (31 downto 0);
           DoutAB_nReady : in STD_LOGIC;
           DoutAB_valid : out STD_LOGIC;
           
           DoutCD : out STD_LOGIC_VECTOR (31 downto 0);
           DoutCD_nReady : in STD_LOGIC;
           DoutCD_valid : out STD_LOGIC;
           
           --Debug signals
           DBG_COUNT_AB : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           DBG_MAX_COUNT_AB : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           DBG_COUNT_CD : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           DBG_MAX_COUNT_CD : out STD_LOGIC_VECTOR(31 DOWNTO 0)                    
           );
end CombIntan_w_header;

architecture Behavioral of CombIntan_w_header is
    
    --Decalring component and signals
    component trace_str is
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
    
        TRIG        : IN STD_LOGIC --! Trigger Signal
       );
    end component trace_str;
    

    type dpack_type is record
        CLK          : STD_LOGIC;
        RSTN         : STD_LOGIC;
        DIN          : STD_LOGIC_VECTOR(32-1 DOWNTO 0);
        DVALID       : STD_LOGIC;
        READY        : STD_LOGIC;
        TIME_IN      : STD_LOGIC_VECTOR(64 -1 downto 0);
        TS_CORRECTION : STD_LOGIC;
        maxis_tdata  : STD_LOGIC_VECTOR(32 -1 downto 0);
        maxis_tvalid : STD_LOGIC;
        maxis_tkeep  : STD_LOGIC_VECTOR(32/8 - 1 downto 0);
        maxis_tready : STD_LOGIC;
        maxis_tlast  : STD_LOGIC;
        FIFO_CLEAR   : STD_LOGIC;
        FIFO_AFULL   : STD_LOGIC;
        SBE          : STD_LOGIC_VECTOR(32-1 DOWNTO 0);
        SAE          : STD_LOGIC_VECTOR(32-1 DOWNTO 0);
        debug_count  : STD_LOGIC_VECTOR(31 DOWNTO 0);
        debug_max_count : STD_LOGIC_VECTOR(31 DOWNTO 0);
        TRIG         : STD_LOGIC;
    end record;

    signal dpack_ab, dpack_cd: dpack_type;
begin


    --Component instantiation
    DPACK_AB_COMP : trace_str
    generic map (
        DWidth => 32,
        REG_WIDTH => 32,
        TSRES => 64,
        FIFO_SIZE => FIFO_SIZE
    )
    port map (
        CLK => dpack_ab.CLK,
        RSTN => dpack_ab.RSTN,
        DIN => dpack_ab.DIN,
        DVALID => dpack_ab.DVALID,
        READY => dpack_ab.READY,
        TIME_IN => dpack_ab.TIME_IN,
        TS_CORRECTION => dpack_ab.TS_CORRECTION,
        maxis_tdata => dpack_ab.maxis_tdata,
        maxis_tvalid => dpack_ab.maxis_tvalid,
        maxis_tkeep => dpack_ab.maxis_tkeep,
        maxis_tready => dpack_ab.maxis_tready,
        maxis_tlast => dpack_ab.maxis_tlast,
        FIFO_CLEAR => dpack_ab.FIFO_CLEAR,
        FIFO_AFULL => dpack_ab.FIFO_AFULL,
        SBE => dpack_ab.SBE,
        SAE => dpack_ab.SAE,
        debug_count => dpack_ab.debug_count,
        debug_max_count => dpack_ab.debug_max_count,
        TRIG => dpack_ab.TRIG
    );

    --Component instantiation
    DPACK_CD_COMP : trace_str
    generic map (
        DWidth => 32,
        REG_WIDTH => 32,
        TSRES => 64,
        FIFO_SIZE => FIFO_SIZE
    )
    port map (
        CLK => dpack_cd.CLK,
        RSTN => dpack_cd.RSTN,
        DIN => dpack_cd.DIN,
        DVALID => dpack_cd.DVALID,
        READY => dpack_cd.READY,
        TIME_IN => dpack_cd.TIME_IN,
        TS_CORRECTION => dpack_cd.TS_CORRECTION,
        maxis_tdata => dpack_cd.maxis_tdata,
        maxis_tvalid => dpack_cd.maxis_tvalid,
        maxis_tkeep => dpack_cd.maxis_tkeep,
        maxis_tready => dpack_cd.maxis_tready,
        maxis_tlast => dpack_cd.maxis_tlast,
        FIFO_CLEAR => dpack_cd.FIFO_CLEAR,
        FIFO_AFULL => dpack_cd.FIFO_AFULL,
        SBE => dpack_cd.SBE,
        SAE => dpack_cd.SAE,
        debug_count => dpack_cd.debug_count,
        debug_max_count => dpack_cd.debug_max_count,
        TRIG => dpack_cd.TRIG
    );

    --Constants and configuration
    dpack_ab.TS_CORRECTION<='0';
    dpack_ab.SBE<=(others=>'0');
    dpack_ab.SAE<=std_logic_vector(to_unsigned(32,32));
    dpack_ab.TRIG<='1';

    --Data Input
    dpack_ab.CLK<=sys_clk;
    dpack_ab.RSTN<=sys_rstn;
    dpack_ab.TIME_IN<=timestamp_i;
    dpack_ab.READY<=HICCE_ACK_i;
    dpack_ab.maxis_tready<=not DoutAB_nReady;
    dpack_ab.FIFO_AFULL<=FIFO_AFULL_AB;

    --HICCE Data   
    dpack_ab.DIN<=DinA & DinB;
    dpack_ab.DVALID<=(DataIn_valid(0) OR DataIn_valid(1));
    

    DoutAB <= dpack_ab.maxis_tdata;
    DoutAB_valid <= dpack_ab.maxis_tvalid;
    FIFO_CLEAR_AB<= dpack_ab.FIFO_CLEAR;

    --Constants and configuration
    dpack_cd.TS_CORRECTION<='0';
    dpack_cd.SBE<=(others=>'0');
    dpack_cd.SAE<=std_logic_vector(to_unsigned(32,32));
    dpack_cd.TRIG<='1';

    --Data Input
    dpack_cd.CLK<=sys_clk;
    dpack_cd.RSTN<=sys_rstn;
    dpack_cd.TIME_IN<=timestamp_i;
    dpack_cd.READY<=HICCE_ACK_i;
    dpack_cd.maxis_tready<=not DoutAB_nReady;
    dpack_cd.FIFO_AFULL<=FIFO_AFULL_AB;

    --HICCE Data   
    dpack_cd.DIN<=DinC & DinD;
    dpack_cd.DVALID<=(DataIn_valid(3) OR DataIn_valid(2));
    

    DoutCD <= dpack_cd.maxis_tdata;
    DoutCD_valid <= dpack_cd.maxis_tvalid;
    FIFO_CLEAR_CD<= dpack_cd.FIFO_CLEAR;

    --Debug data
    DBG_COUNT_AB<=dpack_ab.debug_count;
    DBG_COUNT_CD<=dpack_cd.debug_count;

    DBG_MAX_COUNT_AB<=dpack_ab.debug_max_count;
    DBG_MAX_COUNT_CD<=dpack_cd.debug_max_count;


    Data_Rd_En <= (not DoutAB_nReady) & (not DoutAB_nReady) & (not DoutCD_nReady) & (not DoutCD_nReady);

end Behavioral;
