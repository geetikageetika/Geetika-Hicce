library ieee;
use ieee.std_logic_1164.all;

entity rising_edge_detector is
port (
  clk                       : in  std_logic;
  rstn                      : in  std_logic;
  s                         : in  std_logic;
  pulse                     : out std_logic);
end rising_edge_detector;

architecture rtl of rising_edge_detector is
signal s0                           : std_logic;
signal s1                           : std_logic;
begin
p_rising_edge_detector : process(clk,rstn)
begin
  if(rstn='0') then
    s0           <= '0';
    s1           <= '0';
  elsif(rising_edge(clk)) then
    s0           <= s;
    s1           <= s0;
  end if;
end process p_rising_edge_detector;
pulse            <= not s1 and s0;
end rtl;