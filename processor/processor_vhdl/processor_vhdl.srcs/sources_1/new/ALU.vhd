----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 09:15:01
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( OP1: in STD_LOGIC_VECTOR (7 downto 0);
           OP2: in STD_LOGIC_VECTOR (7 downto 0);
           
           CTRL_ALU: in STD_LOGIC_VECTOR (2 downto 0);
           
           N : out STD_LOGIC;
           O : out STD_LOGIC;
           Z : out STD_LOGIC;
           C : out STD_LOGIC;
           
           ALU_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end ALU;


architecture Behavioral of ALU is 

signal TKN : STD_LOGIC_VECTOR (16 downto 0) := (others => '0');

begin
    
    process(CTRL_ALU)
    begin
        if CTRL_ALU = "001" then
        TKN <= OP1 + OP2;
        
    elsif CTRL_ALU = "011" then
        TKN <= OP1 - OP2;
        
    elsif CTRL_ALU = "001" then
        TKN <= OP1 * OP2; 
        
    end if;
    
    if TKN = 0 then
        N <= '1' ;
    elsif TKN <0 then
        -- Carry porter par le vecteur  TKN on check pour envoyer les flags
    
    elsif 
    
    end process;
       


    
    
end Behavioral;