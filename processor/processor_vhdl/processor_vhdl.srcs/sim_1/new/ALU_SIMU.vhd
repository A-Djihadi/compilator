----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.04.2022 10:07:17
-- Design Name: 
-- Module Name: ALU_SIMU - Behavioral
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

entity ALU_SIMU is
--  Port ( );
end ALU_SIMU;

architecture Behavioral of ALU_SIMU is

--COMPONENT TEST

COMPONENT ALU
PORT(
           OP1: in STD_LOGIC_VECTOR (7 downto 0);
           OP2: in STD_LOGIC_VECTOR (7 downto 0);
           
           CTRL_ALU: in STD_LOGIC_VECTOR (2 downto 0);
           
           N : out STD_LOGIC;
           O : out STD_LOGIC;
           Z : out STD_LOGIC;
           C : out STD_LOGIC;
           
           ALU_OUT : out STD_LOGIC_VECTOR (7 downto 0)
           );
END COMPONENT;

-- END 

--Inputs
signal T_OP1: std_logic_vector (7 downto 0):= (others => '1');
signal T_OP2: std_logic_vector (7 downto 0):= (others => '0');

signal OPERATOR: std_logic_vector (2 downto 0):= (others => '0');


--Outputs
signal TEST_DOUT: std_logic_vector(7 downto 0);
           
signal T_N : STD_LOGIC := '0';
signal T_O : STD_LOGIC := '0';
signal T_Z : STD_LOGIC := '0';
signal T_C : STD_LOGIC := '0';

begin

    --Instantiate the Unit Under Test (UUT)
Label_uut: ALU PORT MAP (
    OP1 => T_OP1,
    OP2 => T_OP2,
    CTRL_ALU => OPERATOR,
    N => T_N,
    O => T_O,
    Z => T_Z,
    C => T_C,

    ALU_OUT => TEST_DOUT
);


-- Simu process

-- TEST OPERATOR ADD MULL AND SUB CHECK FLAGS AND RESULTS
 
--T_OP1   <= X"04" after 150 ns,X"02" after 175 ns,X"04" after 200 ns, X"FF" after 500 ns,X"25" after 800 ns,X"12" after 850 ns;
--T_OP2   <= X"08" after 170 ns,X"01" after 200 ns, X"04" after 500 ns,X"64" after 800 ns,X"02" after 850 ns;
--OPERATOR <= "001" after 1 ns,"010" after 120 ns,"011" after 250 ns,"010" after 300 ns,"001" after 650 ns,"011" after 750 ns;

-- TEST OPERATOR DIV CHECK FLAGS AND DIV BY ZERO

T_OP1   <= X"02" after 1 ns,X"08" after 200 ns,X"00" after 275 ns, X"FF" after 500 ns;
T_OP2   <= X"04" after 1 ns,X"10" after 250 ns, X"00" after 400 ns;
OPERATOR <= "100" after 1 ns;



end Behavioral;
