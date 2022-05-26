----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.05.2022 14:58:37
-- Design Name: 
-- Module Name: Proc_SIMU - Behavioral
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

entity Proc_SIMU is
end Proc_SIMU;

architecture Behavioral of Proc_SIMU is

--COMPONENT TEST
COMPONENT processor
  Port (IP : in STD_LOGIC_VECTOR (7 downto 0);
        RST,CLK_P : in STD_LOGIC);
END COMPONENT;

--Inputs
signal T_IP: std_logic_vector (7 downto 0):= (others => '0');
signal T_RST,T_CLK: std_logic := '0';



constant Clock_period : time := 2 ns;  
begin

Proc_simu : processor 
PORT MAP (
    IP  => T_IP,
    RST => T_RST,
    CLK_P => T_CLK
);

Clock_process : process
begin
    T_CLK <= not(T_CLK);
    wait for Clock_period/2;
end process;


T_IP   <= X"00" after 1 ns,X"01" after 50 ns,X"02" after 100 ns, X"FF" after 150 ns;
T_RST   <= '1' after 1 ns,'0' after 3 ns;

end Behavioral;
