----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/16/2018 02:48:46 PM
-- Design Name: 
-- Module Name: mux16bit4to1 - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux16bit4to1 is
    Port ( dinA : in STD_LOGIC_VECTOR (15 downto 0);
           dinB : in STD_LOGIC_VECTOR (15 downto 0);
           dinC : in STD_LOGIC_VECTOR (15 downto 0);
           dinD : in STD_LOGIC_VECTOR (15 downto 0);
           
           FIFO_rd_en_ABCD : out STD_LOGIC_VECTOR (3 downto 0);
           FIFO_empty_ABCD : in STD_LOGIC_VECTOR (3 downto 0);
 
           sel  : in STD_LOGIC_VECTOR (3 downto 0);
           
           dout : out STD_LOGIC_VECTOR (15 downto 0);
           dout_tready : in STD_LOGIC;
           dout_tvalid : out STD_LOGIC
           );
end mux16bit4to1;

architecture Behavioral of mux16bit4to1 is
    signal  FIFO_empty_A, FIFO_empty_B, FIFO_empty_C, FIFO_empty_D, FIFO_rd_en_A, FIFO_rd_en_B, FIFO_rd_en_C, FIFO_rd_en_D : STD_LOGIC;   
begin
    process(sel, dinA, dinB, dinC, dinD, FIFO_empty_A, FIFO_empty_B, FIFO_empty_C, FIFO_empty_D, dout_tready)
    begin
        case sel is
          when "1000" => 
                        dout <= dinA;
                        dout_tvalid <= FIFO_empty_ABCD(3);
                        FIFO_rd_en_ABCD(3) <= dout_tready;
                        FIFO_rd_en_ABCD(2) <= '0';
                        FIFO_rd_en_ABCD(1) <= '0';
                        FIFO_rd_en_ABCD(0) <= '0';
          when "0100" => 
                        dout <= dinB;
                        dout_tvalid <= FIFO_empty_ABCD(2);
                        FIFO_rd_en_ABCD(3) <= '0';
                        FIFO_rd_en_ABCD(2) <= dout_tready;
                        FIFO_rd_en_ABCD(1) <= '0';
                        FIFO_rd_en_ABCD(0) <= '0';                        
          when "0010" => 
                        dout <= dinC;
                        dout_tvalid <= FIFO_empty_ABCD(1);
                        FIFO_rd_en_ABCD(3) <= '0';
                        FIFO_rd_en_ABCD(2) <= '0';
                        FIFO_rd_en_ABCD(1) <= dout_tready;
                        FIFO_rd_en_ABCD(0) <= '0';                      
          when "0001" => 
                        dout <= dinD;
                        dout_tvalid <= FIFO_empty_ABCD(0);
                        FIFO_rd_en_ABCD(3) <= '0';
                        FIFO_rd_en_ABCD(2) <= '0';
                        FIFO_rd_en_ABCD(1) <= '0';
                        FIFO_rd_en_ABCD(0) <= dout_tready;
          when others => 
                        dout <= dinA;
                        dout_tvalid <= FIFO_empty_ABCD(3);
                        FIFO_rd_en_ABCD(3) <= dout_tready;
                        FIFO_rd_en_ABCD(2) <= '0';
                        FIFO_rd_en_ABCD(1) <= '0';
                        FIFO_rd_en_ABCD(0) <= '0';
        end case;
    end process;

end Behavioral;
