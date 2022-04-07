----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 09:15:01
-- Design Name: 
-- Module Name: BANC_REGISTRE - Behavioral
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

entity FETCH is
    Port ( DATA : in STD_LOGIC_VECTOR (7 downto 0);
           X : out STD_LOGIC_VECTOR (7 downto 0);
           F_OUT: out STD_LOGIC_VECTOR (7 downto 0));
end FETCH;

architecture Behavioral of FETCH is

begin


end Behavioral;