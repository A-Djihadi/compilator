----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.05.2022 09:59:24
-- Design Name: 
-- Module Name: REGISTRE_SIMU - Behavioral
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

entity REGISTRE_SIMU is
--  Port ( );
end REGISTRE_SIMU;

architecture Behavioral of REGISTRE_SIMU is

--COMPONENT TEST
COMPONENT BANC_REGISTRE 
    PORT(  addr_A : in STD_LOGIC_VECTOR (3 downto 0);
           addr_B : in STD_LOGIC_VECTOR (3 downto 0);
           addr_W : in STD_LOGIC_VECTOR (3 downto 0);
           DATA : in STD_LOGIC_VECTOR (7 downto 0);
           W : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           QA : out STD_LOGIC_VECTOR (7 downto 0);
           QB : out STD_LOGIC_VECTOR (7 downto 0)
           );
END COMPONENT;

-- END 

--Inputs

signal T_addr_A: std_logic_vector (3 downto 0):= (others => '1');
signal T_addr_B: std_logic_vector (3 downto 0):= (others => '1');
signal T_addr_W: std_logic_vector (3 downto 0):= (others => '1');
signal T_DATA: std_logic_vector (7 downto 0):= (others => '1');
signal T_W: STD_LOGIC := '0';
signal T_RST: STD_LOGIC := '0';
signal T_CLK: STD_LOGIC := '1';

--Outputs
signal T_QA: std_logic_vector(7 downto 0);
signal T_QB: std_logic_vector(7 downto 0);

constant Clock_period : time := 2 ns;  
         
begin
    --Instantiate the Unit Under Test (UUT)
Banc_Reg_simu: BANC_REGISTRE PORT MAP (
    addr_A => T_addr_A,
    addr_B => T_addr_B,
    addr_W => T_addr_W,
    DATA => T_DATA,
    W => T_W,
    RST => T_RST,
    CLK => T_CLK,
    
    QA => T_QA,
    QB => T_QB
);


Clock_process : process
begin
    T_CLK <= not(T_CLK);
    wait for Clock_period/2;
end process;

-- Simu process

-- TEST DU BANC DE REGISTRE
T_addr_A <= X"1" after 1ns,X"3" after 60ns; 
T_addr_B <= X"4" after 1 ns,X"2" after 80ns;
T_addr_W <= X"1" after 1 ns,X"2" after 50ns,X"3" after 90ns,X"4" after 120ns,X"5" after 150ns;
T_DATA <=   X"E1" after 1 ns,X"A2" after 60ns,X"E5" after 100ns,X"A3" after 150ns;
T_W <=      '0' after 1 ns,'1' after 50 ns,'0' after 130 ns,'1' after 140 ns;
T_RST <=    '1' after 1 ns,'0' after 2 ns,'0' after 150 ns;



end Behavioral;
