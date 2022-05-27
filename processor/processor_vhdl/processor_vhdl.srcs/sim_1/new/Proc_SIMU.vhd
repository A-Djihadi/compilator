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


-- TEST AFC
--T_IP   <= --X"00", X"01" after 50 ns, X"02" after 100 ns,X"03" after 130 ns;
-- TEST COP
--T_IP   <= X"00",X"04" after 100 ns ;
-- TEST AFC COP
--T_IP   <= X"00",X"04" after 50 ns, X"02" after 100 ns,X"03" after 150 ns,X"05" after 180 ns;
-- TEST ALU
--T_IP   <= X"00", X"01" after 50 ns, X"02" after 100 ns,X"03" after 130 ns,X"06" after 150 ns, X"07" after 180 ns,X"08" after 200 ns,X"09" after 230 ns;
-- TEST LOAD STORE
T_IP   <= X"00",X"01" after 20 ns,X"02" after 40 ns, X"0A" after 100 ns, X"0B" after 150 ns,X"0C" after 200 ns,X"0D" after 250 ns;
T_RST   <= '1','0' after 2 ns;

end Behavioral;
