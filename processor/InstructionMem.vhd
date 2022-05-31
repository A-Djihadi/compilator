----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 09:49:42
-- Design Name: 
-- Module Name: InstructionMem - Behavioral
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

entity InstructionMem is
    Port ( ADR_IN : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           R_OUT : out STD_LOGIC_VECTOR (31 downto 0));
end InstructionMem;

architecture Behavioral of InstructionMem is
    type Mem is array (0 to 255) of STD_LOGIC_VECTOR (31 downto 0);
    signal REG : Mem;
    

    begin


--------------Initialize instruction---------------------    
    REG <= (
    --AFC XX06XXXX
        0 => X"00060100",   -- AFC 01 au registre r0
        1 => X"01060200",   -- AFC 02 au registre r1
        2 => X"02060300",   -- AFC 03 au registre r2
        3 => X"03060400",   -- AFC 04 au registre r3
    --COP XX05XXXX  
        4 => X"00050100",   -- COP r1 au registre r0
        5 => X"00050200",   -- COP r2 au registre r0
        6 => X"01050200",   -- COP r2 au registre r1
        7 => X"01050300",   -- COP r3 au registre r1
    --ALU XX0YXXXX
        8 => X"00010102",   -- ADD r1 + r2 => r0
        9 => X"00020203",   -- MUL r2 * r3 => r0
        10=> X"06030301",   -- SUB r3 - r1 => r6
        11=> X"07040301",   -- DIV r3 / r1 => r6
    -- LOAD AND STORE
        12 => X"04080100",   -- STORE r1 in a4
        13 => X"05080200",   -- STORE r2 in a5
        14 => X"08070400",   -- LOAD  a4 in r8
        15 => X"09070500",   -- LOAD  a5 in r9
                
     ---------------Instruction pour testes avec des valeurs differents---------------
     --AFC XX06XXXX
        16 => X"00060500",   -- AFC 05 au registre r0
        17 => X"01065000",   -- AFC 80 au registre r1
        18 => X"0206AA00",   -- AFC 170 au registre r2
        19 => X"0306FF00",   -- AFC 255 au registre r3  
    --COP XX05XXXX  
        20 => X"01050000",   -- COP r0 au registre r1
        21 => X"02050000",   -- COP r0 au registre r2
        22 => X"01050600",   -- COP r6 au registre r1
        23 => X"02050600",   -- COP r6 au registre r2 
     
        others => X"00000000"
    
    );
    
        process(CLK)
        
            begin
                if(CLK'Event and CLK = '1')then
                    R_OUT <= REG(to_integer(unsigned(ADR_IN)));
                end if;
        
        end process;
    
    end Behavioral;
