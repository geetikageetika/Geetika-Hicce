library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity AD4002_CNV is
    generic(tquiet1 : integer :=50);
    Port(
    rst_n     : in std_logic;
    clk       : in std_logic;

    addr       : in std_logic_vector(31 downto 0);
    enable_tx  : in std_logic;
    spi_cs     : in std_logic_vector(1 downto 0);
    spi_mosi   : in std_logic;
    
    cnv        : out std_logic_vector(1 downto 0);
    sdi        : out std_logic;
    enable_spi : out std_logic
    );
end AD4002_CNV;

architecture Behavioral of AD4002_CNV is

type state is (idle, tquiet, spi_tx);
signal cstate, nstate : state;
signal addr_sig : integer;

signal count : integer;

begin
addr_sig<=to_integer(unsigned(addr(1 downto 0)));

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
                cnv<=(others=>'0');
                sdi<='1';
                enable_spi<='0';
            when tquiet =>
                cnv(addr_sig)<='1';
                sdi<='1';
                enable_spi<='0';
            when spi_tx =>
                cnv(addr_sig)<='1';
                sdi<=spi_mosi;
                enable_spi<='1';
        end case;      
    end process;

    process(cstate, enable_tx, spi_cs)
    begin
        case cstate is
            when idle =>
                if enable_tx = '1' and addr_sig<2 then
                    nstate<=tquiet;
                else 
                    nstate<=idle;
                end if;
            when tquiet =>
                if count >= 2*tquiet1 then
                    nstate<=spi_tx;
                else 
                    nstate<=tquiet;
                end if;
            when spi_tx =>
                if spi_cs(addr_sig) = '1' then
                    nstate<=idle;
                else
                    nstate<=spi_tx;
                end if;
        end case;
    end process;

end Behavioral;


