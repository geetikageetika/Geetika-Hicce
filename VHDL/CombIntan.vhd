----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2022 03:14:40 AM
-- Design Name: 
-- Module Name: CombIntan - Behavioral
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

entity CombIntan is
    Port ( DinA : in STD_LOGIC_VECTOR (15 downto 0);
           DinB : in STD_LOGIC_VECTOR (15 downto 0);
           DinC : in STD_LOGIC_VECTOR (15 downto 0);
           DinD : in STD_LOGIC_VECTOR (15 downto 0);
           DataIn_valid : in STD_LOGIC_VECTOR (3 downto 0);
           Data_Rd_En : out STD_LOGIC_VECTOR (3 downto 0);
           
           DoutAB : out STD_LOGIC_VECTOR (31 downto 0);
           DoutAB_nReady : in STD_LOGIC;
           DoutAB_valid : out STD_LOGIC;
           
           DoutCD : out STD_LOGIC_VECTOR (31 downto 0);
           DoutCD_nReady : in STD_LOGIC;
           DoutCD_valid : out STD_LOGIC
           
           );
end CombIntan;

architecture Behavioral of CombIntan is

begin
DoutAB <= DinA & DinB;
DoutAB_valid <= (DataIn_valid(3) OR DataIn_valid(2));

DoutCD <= DinC & DinD;
DoutCD_valid <= (DataIn_valid(1) OR DataIn_valid(0));


Data_Rd_En <= (not DoutAB_nReady) & (not DoutAB_nReady) & (not DoutCD_nReady) & (not DoutCD_nReady);

end Behavioral;
