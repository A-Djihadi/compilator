----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 09:15:01
-- Design Name: 
-- Module Name: BANC_REGISTRE - Behavioral
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
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BANC_REGISTRE is
    Port ( addr_A : in STD_LOGIC_VECTOR (3 downto 0);
           addr_B : in STD_LOGIC_VECTOR (3 downto 0);
           addr_W : in STD_LOGIC_VECTOR (3 downto 0);
           DATA : in STD_LOGIC_VECTOR (7 downto 0);
           W : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           QA : out STD_LOGIC_VECTOR (7 downto 0);
           QB : out STD_LOGIC_VECTOR (7 downto 0));
end BANC_REGISTRE;


architecture Behavioral of BANC_REGISTRE is
    type Registers is array (0 to 15) of STD_LOGIC_VECTOR (7 downto 0);
    signal REG : Registers;
    
    
begin 
    process (CLK)
    
    begin
        if(CLK'Event and CLK = '1')then
            if RST = '1' then      --RST Banc de Registre
                REG <= (others => X"00");
            else
                if W = '1' then    --Permission Write
                    REG(to_integer(unsigned(addr_W))) <= DATA; --On écrit la DATA dans l'adresse de W
                end if;
            end if;
            
        end if;


    end process;
    QA <= REG(to_integer(unsigned(addr_A)))    when (W='0' or addr_A /= addr_W)  else DATA; 
    QB <= REG(to_integer(unsigned(addr_B)))    when (W='0' or addr_B /= addr_W)  else DATA;    
    
end Behavioral;
