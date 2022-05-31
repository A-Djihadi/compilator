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
    RST,CLK_P : in STD_LOGIC);  -- RST and CLK_P will be share with all the other components
end processor;

architecture Behavioral of processor is

-------------------------------Import Component------------------------------------
component DataMem is 
    Port(ADR,R_IN : in STD_LOGIC_VECTOR (7 downto 0);
    RW,RST,CLK : in STD_LOGIC;
    R_OUT: out STD_LOGIC_VECTOR (7 downto 0));
end component;

component InstructionMem is
Port(ADR_IN: in STD_LOGIC_VECTOR (7 downto 0);
    CLK : in STD_LOGIC;
    R_OUT: out STD_LOGIC_VECTOR (31 downto 0));
end component;

component ALU is
Port ( OP1,OP2: in STD_LOGIC_VECTOR (7 downto 0);
       CTRL_ALU: in STD_LOGIC_VECTOR (2 downto 0);
       N,O,Z,C : out STD_LOGIC;
       ALU_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component BANC_REGISTRE is
Port ( addr_A,addr_B,addr_W : in STD_LOGIC_VECTOR (3 downto 0);
       DATA: in STD_LOGIC_VECTOR (7 downto 0);
       W,RST,CLK : in STD_LOGIC;
       QA,QB : out STD_LOGIC_VECTOR (7 downto 0));
end component;


component Pipeline is
Port( A_in,B_in,Op_in,C_in : in STD_LOGIC_VECTOR (7 downto 0);
      CLK: in STD_LOGIC;
      A_out,B_out,OP_out,C_out : out STD_LOGIC_VECTOR (7 downto 0));
end component;

------------------------END COMPONENTS------------------------


--------------Pipeline Outputs---------------

signal LiDiOutA,LiDiOutB,LiDiOutOP,LiDiOutC : std_logic_vector (7 downto 0) := (others => '0');
signal DiExOutA,DiExOutB,DiExOutOP,DiExOutC : std_logic_vector (7 downto 0) := (others => '0');
signal ExMemOutA,ExMemOutB,ExMemOutOP,ExMemOutC : std_logic_vector (7 downto 0) := (others => '0');
signal MemReOutA,MemReOutB,MemReOutOP : std_logic_vector (7 downto 0) := (others => '0');

----------Signal between components---------- 

--------BANC DE REGISTRE--------
signal T_W: STD_LOGIC := '0';
signal T_QA: std_logic_vector(7 downto 0);
signal T_QB: std_logic_vector(7 downto 0);

--------------InstructionMem-------------
signal T_R_OUT: STD_LOGIC_VECTOR (31 downto 0):=(others => '0'); 

-------------ALU------------------
signal T_AluOut:std_logic_vector(7 downto 0);
signal T_AluCtrl: std_logic_vector(2 downto 0);

---------Mémoire des données-------
signal T_RwRAM :std_logic;
signal T_RamOut :std_logic_vector(7 downto 0);

---------------MUX-------------------
signal MuxOutBR: std_logic_vector(7 downto 0); 
signal MuxOutALU: std_logic_vector(7 downto 0); 
signal MuxOutRAM: std_logic_vector(7 downto 0); 
signal MuxInRAM: std_logic_vector(7 downto 0); 


---------------------------PORT MAP COMPOENENTS---------------------- 

begin

Mem_innstruction:InstructionMem 
PORT MAP (
    ADR_IN=>IP,
    CLK=>CLK_P,
    R_OUT=>T_R_OUT); 

Banc_Reg:BANC_REGISTRE 
PORT MAP(
    addr_A => LiDiOutB(3 downto 0),
    addr_B => LiDiOutC(3 downto 0),
    addr_W => MemReOutA(3 downto 0),
    DATA => MemReOutB,
    W => T_W,
    RST => RST,
    CLK => CLK_P,
    QA => T_QA,
    QB => T_QB
);

Ual:ALU
PORT MAP(
    OP1 => DiExOutB,
    OP2 => DiExOutC,
    CTRL_ALU => T_AluCtrl,    
    ALU_OUT => T_AluOut
); 

Mem_donnees:DataMem 
PORT MAP (
    ADR=>MuxInRAM,
    R_IN=>ExMemOutB,
    RW=>T_RwRAM,
    RST=>RST,
    CLK=>CLK_P,
    R_OUT=>T_RamOut); 



------------------------------------- Module LC ----------------------------------------------------------------
T_W <= '0' when (MemReOutOP=X"08") else '1';
T_AluCtrl <= DiExOutOP(2 downto 0) when (DiExOutOP=X"01" or DiExOutOP=X"02" or DiExOutOP=X"03" or DiExOutOP=X"04");
T_RwRAM <= '0' when ExMemOutOP=X"08" else '1';
-----------------------------------------MUX-------------------------------------------------------------------- 
MuxOutBR  <= LiDiOutB when (LiDiOutOP=X"06" or LiDiOutOP=X"07") else T_QA;
MuxOutALU <= T_AluOut when (DiExOutOP=X"01" or DiExOutOP=X"02" or DiExOutOP=X"03" or DiExOutOP=X"04") else DiExOutB;
MuxOutRAM <= T_RamOut when ExMemOutOP=X"07" else ExMemOutB ;
MuxInRAM  <= ExMemOutA when ExMemOutOP=X"08" else ExMemOutB ;

---------------------------------PORT MAP Pipeline-------------------------------------
LI_DI: Pipeline 
PORT MAP(
    A_in=>T_R_OUT(31 downto 24),
    OP_in=>T_R_OUT(23 downto 16), 
    B_in=>T_R_OUT(15 downto 8),
    C_in=>T_R_OUT(7 downto 0),
    CLK=>CLK_P,
    A_out=>LiDiOutA,
    OP_out=>LiDiOutOP,
    B_out=>LiDiOutB,
    C_out=>LiDiOutC);

DI_EX: Pipeline 
PORT MAP(
    A_in=>LiDiOutA,
    OP_in=>LiDiOutOP, 
    B_in=>MuxOutBR,
    C_in=>T_QB,
    CLK=>CLK_P,
    A_out=>DiExOutA,
    OP_out=>DiExOutOP,
    B_out=>DiExOutB,
    C_out=>DiExOutC);
  
EX_Mem: Pipeline 
PORT MAP(
    A_in=>DiExOutA,
    OP_in=>DiExOutOP, 
    B_in=>MuxOutALU,
    C_in=>DiExOutC,
    CLK=>CLK_P,
    A_out=>ExMemOutA,
    OP_out=>ExMemOutOP,
    B_out=>ExMemOutB);
        
Mem_RE: Pipeline 
PORT MAP(
    A_in=>ExMemOutA,
    OP_in=>ExMemOutOP, 
    B_in=>MuxOutRAM,
    C_in=>ExMemOutC,
    CLK=>CLK_P,
    A_out=>MemReOutA,
    OP_out=>MemReOutOP,
    B_out=>MemReOutB);
    
        

end Behavioral;
