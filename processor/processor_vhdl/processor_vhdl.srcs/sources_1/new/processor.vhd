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
  Port (IP : in STD_LOGIC_VECTOR (7 downto 0);
    RST,CLK : in STD_LOGIC);
end processor;

architecture Behavioral of processor is

-------------------------------Import Componant------------------------------------
component RAM is 
    Port(ADR_IN_RAM,R_IN_RAM : in STD_LOGIC_VECTOR (7 downto 0);
    RW_RAM,RST_RAM : in STD_LOGIC;
    R_OUT_RAM: out STD_LOGIC_VECTOR (7 downto 0));
end component;

component ROM is
Port(ADR_IN: in STD_LOGIC_VECTOR (7 downto 0);
    CLK : in STD_LOGIC;
    R_OUT: out STD_LOGIC_VECTOR (31 downto 0));
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


component Pipeline is
Port( A_in,B_in,Op_in,C_in : in STD_LOGIC_VECTOR (7 downto 0);
      CLK: in STD_LOGIC;
      A_out,B_out,OP_out,C_out : out STD_LOGIC_VECTOR (7 downto 0));
end component;

------------------------END COMPONENTS------------------------


--------------Inputs----------------

--signal T_A : std_logic_vector (7 downto 0)     := (others => '0');
--signal T_B : std_logic_vector (15 downto 8)    := (others => '0');
--signal T_OP: std_logic_vector (23 downto 16)   := (others => '0');
--signal T_C : std_logic_vector (31 downto 24)   := (others => '0');


signal T_A : std_logic_vector (7 downto 0):= (others => '0');
signal T_B : std_logic_vector (7 downto 0):= (others => '0');
signal T_OP: std_logic_vector (7 downto 0):= (others => '0');
signal T_C : std_logic_vector (7 downto 0):= (others => '0');


-----------Common inputs-----------
signal T_RST: STD_LOGIC := '0';
signal T_CLK: STD_LOGIC := '1';
--BANC DE REGISTRE
signal T_addr_A: std_logic_vector (3 downto 0):= (others => '0');
signal T_addr_B: std_logic_vector (3 downto 0):= (others => '0');
signal T_addr_W: std_logic_vector (3 downto 0):= (others => '0');
signal T_DATA: std_logic_vector (7 downto 0):= (others => '0');
signal T_W: STD_LOGIC := '0';
--ROM
signal IP_IN: STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
signal T_R_OUT: STD_LOGIC_VECTOR (31 downto 0):=(others => '0'); 

--------------Outputs---------------
signal T_QA: std_logic_vector(7 downto 0);
signal T_QB: std_logic_vector(7 downto 0);
---------------------------------------------------------------------
begin

Mem_innstruction:ROM 
PORT MAP (
    ADR_IN=>IP,
    CLK=>CLK,
    R_OUT=>T_R_OUT); 

--Banc_Reg:BANC_REGISTRE PORT MAP();

LI_DI: Pipeline 
PORT MAP(
    A_in=>T_R_OUT(7 downto 0),
    B_in=>T_R_OUT(15 downto 8), 
    OP_in=>T_R_OUT(23 downto 16),
    C_in=>T_R_OUT(31 downto 24),
    CLK=>CLK,
    A_out=>T_A,
    B_out=>T_B,
    OP_out=>T_OP,
    C_out=>T_C);

DI_EX: Pipeline 
PORT MAP(
    A_in=>T_A,
    B_in=>T_B, 
    OP_in=>T_OP,
    C_in=>T_C,
    CLK=>CLK,
    A_out=>T_A,
    B_out=>T_B,
    OP_out=>T_OP,
    C_out=>T_C);
    
EX_Mem: Pipeline 
PORT MAP(
    A_in=>T_A,
    B_in=>T_B, 
    OP_in=>T_OP,
    C_in=>T_C,
    CLK=>CLK,
    A_out=>T_A,
    B_out=>T_B,
    OP_out=>T_OP,
    C_out=>T_C);
        
Mem_RE: Pipeline 
PORT MAP(
    A_in=>T_A,
    B_in=>T_B, 
    OP_in=>T_OP,
    C_in=>T_C,
    CLK=>CLK,
    A_out=>T_A,
    B_out=>T_B,
    OP_out=>T_OP,
    C_out=>T_C);
    
    
    
    
    

end Behavioral;
