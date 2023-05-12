library IEEE;
use IEEE.std_logic_1164.all;

entity synchronous_counter is
  port (
    clk         : in std_logic;
    reset       : in std_logic;
    data_valid  : in std_logic;
    count       : out std_logic_vector(15 downto 0)
  );
end entity synchronous_counter;

architecture behavioral of synchronous_counter is
  signal internal_count : std_logic_vector(15 downto 0);
begin

  -- Sequential logic for updating count
  process (clk, reset)
  begin
    if (reset = '0') then
      internal_count <= (others => '0');
    elsif (rising_edge(clk)) then
      if (data_valid = '1') then
        internal_count <= internal_count + 1;
      end if;
    end if;
  end process;

  -- Combinational logic for output
  count <= internal_count;

end architecture behavioral;
