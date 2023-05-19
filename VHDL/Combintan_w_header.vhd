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
    Generic(DWidth : integer :=32;
            ts_resolution : integer :=64; 
            FIFO_SIZE : integer :=32768);
    Port ( ab_maxis_clk  : in STD_LOGIC;
           cd_maxis_clk  : in std_logic;
           sys_rstn : in STD_LOGIC;
           sys_en   : in STD_LOGIC;
           nsasmples : in std_logic_vector(Dwidth -1 downto 0);
        
           DataIn_A     : in STD_LOGIC_VECTOR (15 downto 0);
           DataIn_B     : in STD_LOGIC_VECTOR (15 downto 0);
           DataIn_C     : in STD_LOGIC_VECTOR (15 downto 0);
           DataIn_D     : in STD_LOGIC_VECTOR (15 downto 0);
           DataIn_valid : in STD_LOGIC_VECTOR (3 downto 0);
           DataIn_ack   : in STD_LOGIC_VECTOR (3 downto 0);
           DataIn_ready : out STD_LOGIC_VECTOR (3 downto 0);
         
           timestamp_i : in STD_LOGIC_VECTOR(ts_resolution -1 downto 0);

            --! FIFO Signals
           FIFO_CLEAR_AB : out STD_LOGIC;
           FIFO_AFULL_AB : IN STD_LOGIC;
           FIFO_CLEAR_CD : out STD_LOGIC;
           FIFO_AFULL_CD : IN STD_LOGIC;

           --! DATA OUTPUT SIGNALS AXIS MASTER BUS
           ab_maxis_tdata  : out STD_LOGIC_VECTOR(DWidth -1 downto 0);
           ab_maxis_tvalid : out STD_LOGIC;
           ab_maxis_tkeep  : out STD_LOGIC_VECTOR(DWidth/8 - 1 downto 0);
           ab_maxis_tready : in STD_LOGIC;
           ab_maxis_tlast  : out STD_LOGIC;

           cd_maxis_tdata  : out STD_LOGIC_VECTOR(DWidth -1 downto 0);
           cd_maxis_tvalid : out STD_LOGIC;
           cd_maxis_tkeep  : out STD_LOGIC_VECTOR(DWidth/8 - 1 downto 0);
           cd_maxis_tready : in STD_LOGIC;
           cd_maxis_tlast  : out STD_LOGIC;
          
           --Debug signals
           DBG_COUNT_AB : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           DBG_MAX_COUNT_AB : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           DBG_COUNT_CD : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           DBG_MAX_COUNT_CD : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           DBG_STATE_AB : out STD_LOGIC_VECTOR(2 DOWNTO 0);
           DBG_STATE_CD : out STD_LOGIC_VECTOR(2 DOWNTO 0)                    
           );
end CombIntan_w_header;

architecture Behavioral of CombIntan_w_header is
    
    --Declaring components and signals
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
        debug_state : out std_logic_vector (2 downto 0);
    
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
        DWidth => DWidth,
        REG_WIDTH => DWidth,
        TSRES => ts_resolution,
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
        debug_state => DBG_STATE_AB,
        TRIG => dpack_ab.TRIG
    );

    --Component instantiation
    DPACK_CD_COMP : trace_str
    generic map (
        DWidth => DWidth,
        REG_WIDTH => DWidth,
        TSRES => ts_resolution,
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
        debug_state => DBG_STATE_CD,
        TRIG => dpack_cd.TRIG
    );

    --Constants and configuration
    dpack_ab.TS_CORRECTION<='0';
    dpack_ab.SBE<=(others=>'0');
    dpack_ab.SAE<=nsasmples;
    dpack_ab.TRIG<=DataIn_ack(3) or DataIn_ack(2);

    dpack_cd.TS_CORRECTION<='0';
    dpack_cd.SBE<=(others=>'0');
    dpack_cd.SAE<=nsasmples;
    dpack_cd.TRIG<=DataIn_ack(1) or DataIn_ack(0);

    --Data Input
    dpack_ab.CLK<=ab_maxis_clk;
    dpack_ab.RSTN<=sys_rstn;
    dpack_ab.TIME_IN<=timestamp_i;
    dpack_ab.READY<=ab_maxis_tready and sys_en;
    dpack_ab.maxis_tready<=ab_maxis_tready and sys_en;
    dpack_ab.FIFO_AFULL<=FIFO_AFULL_AB;

    dpack_cd.CLK<=cd_maxis_clk;
    dpack_cd.RSTN<=sys_rstn;
    dpack_cd.TIME_IN<=timestamp_i;
    dpack_cd.READY<=cd_maxis_tready and sys_en;
    dpack_cd.maxis_tready<=cd_maxis_tready and sys_en;
    dpack_cd.FIFO_AFULL<=FIFO_AFULL_CD;

    --HICCE Data   
    dpack_ab.DIN<=DataIn_A & DataIn_B;
    dpack_ab.DVALID<=(DataIn_valid(3) OR DataIn_valid(2));

    dpack_cd.DIN<=DataIn_C & DataIn_D;
    dpack_cd.DVALID<=(DataIn_valid(1) OR DataIn_valid(0));
    

    ab_maxis_tdata <= dpack_ab.maxis_tdata;
    ab_maxis_tvalid <= dpack_ab.maxis_tvalid;
    FIFO_CLEAR_AB<= dpack_ab.FIFO_CLEAR;

    cd_maxis_tdata <=  dpack_cd.maxis_tdata;
    cd_maxis_tvalid <= dpack_cd.maxis_tvalid;
    FIFO_CLEAR_CD<= dpack_cd.FIFO_CLEAR;

    --Debug data
    DBG_COUNT_AB<=dpack_ab.debug_count;
    DBG_COUNT_CD<=dpack_cd.debug_count;

    DBG_MAX_COUNT_AB<=dpack_ab.debug_max_count;
    DBG_MAX_COUNT_CD<=dpack_cd.debug_max_count;

    ab_maxis_tkeep<=dpack_ab.maxis_tkeep;
    ab_maxis_tlast<=dpack_ab.maxis_tlast;

    cd_maxis_tkeep<=dpack_cd.maxis_tkeep;
    cd_maxis_tlast<=dpack_cd.maxis_tlast;

    DataIn_ready <= (dpack_ab.maxis_tready) & (dpack_ab.maxis_tready) & (dpack_cd.maxis_tready) & (dpack_cd.maxis_tready);

end Behavioral;
