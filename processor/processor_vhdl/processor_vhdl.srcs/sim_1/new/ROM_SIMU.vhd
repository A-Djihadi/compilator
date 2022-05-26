----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.05.2022 14:51:03
-- Design Name: 
-- Module Name: ROM_SIMU - Behavioral
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

entity ROM_SIMU is
--  Port ( );
end ROM_SIMU;

architecture Behavioral of ROM_SIMU is


component ROM is
Port(ADR_IN: in STD_LOGIC_VECTOR (7 downto 0);
    CLK: in STD_LOGIC;
    R_OUT: out STD_LOGIC_VECTOR (31 downto 0));
end component;


signal T_addr_IN: std_logic_vector (7 downto 0):= (others => '0');
signal T_CLK: std_logic := '1';
signal T_addr_R: std_logic_vector (31 downto 0):= (others => '0');


constant Clock_period : time := 2 ns;  

begin

--Instantiate the Unit Under Test (UUT)
Mem_instruction_simu: ROM PORT MAP (
    ADR_IN=> T_addr_IN,
    CLK => T_CLK,
    R_OUT => T_addr_R
);


Clock_process : process
begin
    T_CLK <= not(T_CLK);
    wait for Clock_period/2;
end process;

T_addr_IN <= X"00" after 1ns,X"01" after 60ns;



end Behavioral;
