----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.05.2022 14:26:39
-- Design Name: 
-- Module Name: PIPE_SIMU - Behavioral
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

entity PIPE_SIMU is
--  Port ( );
end PIPE_SIMU;

architecture Behavioral of PIPE_SIMU is

--COMPONENT TEST
COMPONENT Pipeline 
PORT( A_in,B_in,Op_in,C_in : in STD_LOGIC_VECTOR (7 downto 0);
      CLK: in STD_LOGIC;
      A_out,B_out,OP_out,C_out : out STD_LOGIC_VECTOR (7 downto 0));
END COMPONENT;

signal T_A : std_logic_vector (7 downto 0):= (others => '0');
signal T_B : std_logic_vector (7 downto 0):= (others => '0');
signal T_OP: std_logic_vector (7 downto 0):= (others => '0');
signal T_C : std_logic_vector (7 downto 0):= (others => '0');
signal T_CLK: STD_LOGIC := '1';


constant Clock_period : time := 2 ns;  
begin

--Instantiate the Unit Under Test (UUT)
Pipe_simu: Pipeline PORT MAP (
    A_in=>T_A,
    B_in=>T_B, 
    OP_in=>T_OP,
    C_in=>T_C,
    CLK=>T_CLK);


Clock_process : process
begin
    T_CLK <= not(T_CLK);
    wait for Clock_period/2;
end process;



-- TEST D'UN PIPE
T_A <= X"FF" after 1 ns,X"20" after 50ns,X"A1" after 100ns,X"02" after 110ns; 
T_B <= X"AA" after 1 ns,X"30" after 50ns,X"B2" after 100ns,X"04" after 130ns;
T_OP<= X"BB" after 1 ns,X"40" after 50ns,X"C3" after 100ns,X"06" after 150ns;
T_C <= X"EE" after 1 ns,X"50" after 50ns,X"D4" after 100ns,X"08" after 170ns;

end Behavioral;
