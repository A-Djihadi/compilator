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
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

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

signal TKN : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

--CTRL_ALU "001" ADD | "011" MUL | "010" SUB | "111" DIV
--FLAG N -> Valeur négative | O -> Overflow | Z -> Sortie égale zéro | C -> Carry Addition
--TKN Variable temporaire epour le stockage du résultat

begin
    
    process(OP1,OP2,CTRL_ALU,TKN)
    begin
    
    if CTRL_ALU = "001" then
    
        TKN(8 downto 0)<= std_logic_vector(resize(unsigned(OP1),9) + resize(unsigned(OP2),9));
        C<='0';
        Z<='0';
        N<='0';

        if TKN (8) = '0' then
            O<='0';
        else 
            O<='1';
            C<='1';
        end if;
        
    elsif CTRL_ALU = "011" then
    
        TKN(8 downto 0)<= std_logic_vector(resize(unsigned(OP1),9) - resize(unsigned(OP2),9));
        C<='0';
        Z <= '0';
        N <= '0';

        if TKN (8) = '0' then
            O<='0';
        else 
            O<='1';
        end if;
        
    elsif CTRL_ALU = "010" then
    
        TKN <=std_logic_vector(unsigned(OP1) * unsigned(OP2)); 
        
        C<='0';    
        if TKN(15 downto 8) = X"00" then
            O<='0';
        else
            O<='1';
        end if;
        
        if TKN(7 downto 0) = X"00" then
            Z <= '1';
            N <= '0';
        elsif TKN(7 downto 0) < X"00" then
            -- Carry porter par le vecteur  TKN on check pour envoyer les flags
            Z <= '0';
            N <= '1';   
        else
            Z <= '0';
            N <= '0';
        end if;
        
    elsif CTRL_ALU = "100" then
       O<='0';
       C<='0';
       Z<='0';
       N<='0';
       
       if OP2 = X"00" then
           O<='1';
           TKN(7 downto 0) <= X"FF";
       else
           TKN(7 downto 0) <= std_logic_vector(unsigned(OP1) / unsigned(OP2)); 
            
            if TKN(7 downto 0) = X"00" then
                Z<='1';
            end if;

      end if;
       
    end if;

    
    end process; 
    ALU_OUT <= TKN(7 downto 0);



end Behavioral;