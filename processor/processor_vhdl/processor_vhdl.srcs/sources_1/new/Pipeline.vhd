----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.05.2022 13:58:12
-- Design Name: 
-- Module Name: Pipeline - Behavioral
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

entity Pipeline is
    Port ( A_in : in STD_LOGIC_VECTOR (7 downto 0);
           B_in : in STD_LOGIC_VECTOR (7 downto 0);
           OP_in : in STD_LOGIC_VECTOR (7 downto 0);
           C_in : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           A_out : out STD_LOGIC_VECTOR (7 downto 0);
           B_out : out STD_LOGIC_VECTOR (7 downto 0);
           OP_out : out STD_LOGIC_VECTOR (7 downto 0);
           C_out : out STD_LOGIC_VECTOR (7 downto 0));
end Pipeline;

architecture Behavioral of Pipeline is
    
    signal T_A : std_logic_vector (7 downto 0):= (others => '0');
    signal T_B : std_logic_vector (7 downto 0):= (others => '0');
    signal T_OP: std_logic_vector (7 downto 0):= (others => '0');
    signal T_C : std_logic_vector (7 downto 0):= (others => '0');

begin
    process (CLK)
    begin
        if(CLK'Event and CLK = '1')then
            T_A <= A_in;
            T_B <= B_in;
            T_OP <= OP_in;
            T_C <= C_in;
            
            A_out <= T_A;
            B_out <= T_B;
            OP_out<= T_OP;
            C_out <= T_C;
               
        end if;

    
    end process;


end Behavioral;
