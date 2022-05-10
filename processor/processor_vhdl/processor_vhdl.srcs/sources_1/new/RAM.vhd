----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 09:49:42
-- Design Name: 
-- Module Name: RAM - Behavioral
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

entity RAM is
    Port ( ADR : in STD_LOGIC_VECTOR (7 downto 0);
           R_IN : in STD_LOGIC_VECTOR (7 downto 0);
           
           RW : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           
           R_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end RAM;

architecture Behavioral of RAM is
    type Mem is array (0 to 255) of STD_LOGIC_VECTOR (7 downto 0);
    signal REG : Mem;


begin

    process(CLK)
    
        begin
            if(CLK'Event and CLK = '1')then
                if(RST='0') then -- RST DE LA MEMOIRE A ZERO
                    Mem <= (others => X"00");
                else
                    if(RW = '0') then -- CAS D'UNE ECRITURE               
                    else -- CAS D'UNE LECTURE
                    end if;
                
                end if
            
               

        
            end if;
    
    end process


end Behavioral;
