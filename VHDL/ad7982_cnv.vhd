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
    spi_sclk   : in std_logic;
    spi_busy   : in std_logic;
    
    busy       : out std_logic;
    cnv        : out std_logic;
    sclk       : out std_logic;
    enable_spi : out std_logic
    );
end AD7982_CNV;

architecture Behavioral of AD7982_CNV is

type state is (idle, tconv, start_acq, tacq);
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
            if cstate = tconv then 
                count<=count+1;
            else
                count<=0;
            end if;
        end if;
    end process;

    process(cstate, clk, count)
    begin
        case cstate is
            when idle =>
                cnv<='0';
                enable_spi<='0';
                busy <='0';
                sclk<='0';
            when tconv =>
                if count >= tcnv/3 and count< (tcnv/3)+5 then
                    cnv<='0';
                else
                    cnv<='1';
                end if;
                -- cnv<='1';
                enable_spi<='0';
                busy <='1';
                sclk <='0';
            when start_acq =>
                cnv<=spi_cs;
                sclk <='0';
                enable_spi<='1';
                busy <='1';                    
            when tacq =>
                cnv<='0';
                sclk <=spi_sclk;
                enable_spi<='0';
                busy <='1';                
        end case;      
    end process;

    process(cstate, enable_tx, spi_busy)
    begin
        case cstate is
            when idle =>
                if enable_tx = '1' then
                    nstate<=tconv;
                else 
                    nstate<=idle;
                end if;
            when tconv =>
                if count >= tcnv - 5 then --5 clock cycles of the spi driver to execute the task
                    nstate<=start_acq;
                else 
                    nstate<=tconv;
                end if;
            when start_acq =>
                if spi_busy ='1' then
                    nstate<=tacq;
                else
                    nstate<=start_acq;
                end if;
            when tacq =>
                if spi_busy = '0' then
                    nstate<=idle;
                else
                    nstate<=tacq;
                end if;
        end case;
    end process;

end Behavioral;


