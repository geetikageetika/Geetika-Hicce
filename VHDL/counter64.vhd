library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter64 is
    Port ( clk   : in  STD_LOGIC;
           rstn : in  STD_LOGIC;
           q     : out STD_LOGIC_VECTOR (63 downto 0));
end counter64;

architecture Behavioral of counter64 is
    signal count : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rstn = '0' then
                count <= (others => '0');
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    q <= count;
end Behavioral;
