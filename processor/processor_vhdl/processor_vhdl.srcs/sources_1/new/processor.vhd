----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 09:10:38
-- Design Name: 
-- Module Name: processor - Behavioral
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

entity processor is
  Port (
    ADR_IST: in STD_LOGIC_VECTOR (7 downto 0);
    CLK : in STD_LOGIC);
end processor;

architecture Behavioral of processor is

-------------------------------Import Componant------------------------------------
component RAM is 
    Port(ADR_IN_RAM,R_IN_RAM : in STD_LOGIC_VECTOR (7 downto 0);
    RW_RAM,RST_RAM : in STD_LOGIC;
    R_OUT_RAM: out STD_LOGIC_VECTOR (7 downto 0));
end component;

component ROM is
Port(ADR_IN_ROM: in STD_LOGIC_VECTOR (7 downto 0);
    R_OUT_ROM: out STD_LOGIC_VECTOR (31 downto 0));
end component;

component ALU is
Port ( OP1_Alu,OP2_Alu: in STD_LOGIC_VECTOR (7 downto 0);
       CTRL_Alu: in STD_LOGIC_VECTOR (2 downto 0);
       N_Alu,O_Alu,Z_Alu,C_Alu : out STD_LOGIC;
       ALU_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component BANC_REGISTRE is
Port ( addr_A_Reg,addr_B_Reg,addr_W_Reg : in STD_LOGIC_VECTOR (3 downto 0);
       DATA_Reg : in STD_LOGIC_VECTOR (7 downto 0);
       W_Reg,RST_Reg,CLK_Reg : in STD_LOGIC;
       QA_Reg,QB_reg : out STD_LOGIC_VECTOR (7 downto 0));
end component;


component pipe1 is
Port( A_p1,B_p1,C_p1 : in STD_LOGIC_VECTOR (7 downto 0);
    OP_p1 :in STD_LOGIC_VECTOR (3 downto 0));
end component;

component pipe2 is
Port( A_p2,B_p2,C_p2 : in STD_LOGIC_VECTOR (7 downto 0);
    OP_p2 :in STD_LOGIC_VECTOR (3 downto 0));
end component;


--------------------------------END----------------------------------
--Inputs
--ROM
signal T_addr_A: std_logic_vector (3 downto 0):= (others => '0');
signal T_addr_B: std_logic_vector (3 downto 0):= (others => '0');
signal T_addr_W: std_logic_vector (3 downto 0):= (others => '0');
signal T_DATA: std_logic_vector (7 downto 0):= (others => '0');
signal T_W: STD_LOGIC := '0';
signal T_RST: STD_LOGIC := '0';
signal T_CLK: STD_LOGIC := '1';
--RAM
--ALU

--BANC REGISTRE
--PIPE
--











--Outputs
signal T_QA: std_logic_vector(7 downto 0);
signal T_QB: std_logic_vector(7 downto 0);

--------------------------CREATION DES PIPE---------------------



begin

LI_DI : pipe1 
PORT MAP(
    R_OUT_ROM(7 downto 0) => OP_p1,
    R_OUT_ROM(15 downto 8)  => A_p1, 
    R_OUT_ROM(23 downto 16) => B_p1,
    R_OUT_ROM(31 downto 17) => C_p1
    );









end Behavioral;
