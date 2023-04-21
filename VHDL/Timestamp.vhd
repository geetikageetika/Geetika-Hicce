library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity timestamp is
  generic(CLK_RES : INTEGER :=32);
  port (
    CLK  : IN STD_LOGIC;
    RSTN : IN STD_LOGIC;

    C_COUNT : IN STD_LOGIC_VECTOR(CLK_RES-1 DOWNTO 0);
    TS : OUT STD_LOGIC_VECTOR(CLK_RES - 1 DOWNTO 0);
    
    
    STAMPED : OUT STD_LOGIC; --STAMPED flag high until CLEAR is received. 
    CLEAR : IN STD_LOGIC; --CLEAR timestamp 
    STAMP : IN STD_LOGIC --STAMP signal

  ) ;
end timestamp ; 

architecture arch of timestamp is

    signal hold : std_logic;
    signal ts_signal : STD_LOGIC_VECTOR(CLK_RES-1 DOWNTO 0);

begin

    process(CLK, RSTN)
    begin
        if RSTN = '0' then 
            ts_signal<=(others =>'0');
            hold<='0';
        elsif rising_edge(CLK) then 
            if CLEAR = '1' then 
                hold<='0';
                ts_signal<=(others=>'0');
            elsif hold='1' then
                hold<='1';
                ts_signal<=ts_signal;
            elsif STAMP = '1' then 
                hold<='1';
                ts_signal<=C_COUNT;
            else
                ts_signal<=(others =>'0');
                hold<='0';
            end if;            
        end if;
    end process;

    STAMPED<=hold;
    TS<=ts_signal;


end architecture ;