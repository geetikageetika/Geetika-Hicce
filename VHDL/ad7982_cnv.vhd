library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity AD7982_CNV is
    generic(tcnv : integer :=50);
    Port(
    rst_n     : in std_logic;
    clk       : in std_logic;

    enable_tx  : in std_logic;
    spi_cs     : in std_logic;
    spi_mosi   : in std_logic;
    
    cnv        : out std_logic;
    sdi        : out std_logic;
    enable_spi : out std_logic
    );
end AD7982_CNV;

architecture Behavioral of AD7982_CNV is

type state is (idle, tquiet, spi_tx);
signal cstate, nstate : state;

signal count : integer;

begin

    --Current state logic.
    process(clk, rst_n)
    begin
        if rst_n='0' then 
            cstate<=idle;
        elsif rising_edge(clk) then
            cstate<=nstate;
        end if;
    end process;

    process(clk,rst_n)
    begin
        if rst_n='0' then
            count<=0;
        elsif rising_edge(clk) then
            if cstate = tquiet then
                count<=count+1;
            else
                count<=0;
            end if;
        end if;
    end process;

    process(cstate, clk)
    begin
        case cstate is
            when idle =>
                cnv<='0';
                sdi<='1';
                enable_spi<='0';
            when tquiet =>
                cnv<='1';
                sdi<='1';
                enable_spi<='0';
            when spi_tx =>
                cnv<=spi_cs;
                sdi<=spi_mosi;
                enable_spi<='1';
        end case;      
    end process;

    process(cstate, enable_tx, spi_cs)
    begin
        case cstate is
            when idle =>
                if enable_tx = '1' then
                    nstate<=tquiet;
                else 
                    nstate<=idle;
                end if;
            when tquiet =>
                if count >= tcnv then
                    nstate<=spi_tx;
                else 
                    nstate<=tquiet;
                end if;
            when spi_tx =>
                if spi_cs = '1' then
                    nstate<=idle;
                else
                    nstate<=spi_tx;
                end if;
        end case;
    end process;

end Behavioral;


