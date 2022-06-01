----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.05.2022 14:51:03
-- Design Name: 
-- Module Name: RAM_SIMU - Behavioral
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

entity RAM_SIMU is
--  Port ( );
end RAM_SIMU;

architecture Behavioral of RAM_SIMU is
component DataMem is
Port(ADR,R_IN: in STD_LOGIC_VECTOR (7 downto 0);
    RST,CLK,RW: in STD_LOGIC;
    R_OUT: out STD_LOGIC_VECTOR (7 downto 0));
end component;


signal T_addr: std_logic_vector (7 downto 0):= (others => '0');
signal T_R_in: std_logic_vector (7 downto 0):= (others => '0');
signal T_CLK,T_RST,T_RW: std_logic := '1';
signal T_R: std_logic_vector (7 downto 0):= (others => '0');


constant Clock_period : time := 2 ns;  

begin

--Instantiate the Unit Under Test (UUT)
Mem_donne_simu: DataMem PORT MAP (
    ADR=> T_addr,
    R_IN=> T_R_in,
    RST => T_RST,
    RW => T_RW,
    CLK => T_CLK,
    R_OUT => T_R
);


Clock_process : process
begin
    T_CLK <= not(T_CLK);
    wait for Clock_period/2;
end process;

T_RST <= '1', '0' after 2ns;
T_RW  <= '0', '1' after 100ns;

T_R_in <= X"01", X"02" after 50 ns;
T_addr <= X"00",X"01" after 50ns,X"00" after 100ns, X"01" after 150ns;



end Behavioral;
