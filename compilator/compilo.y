%{
#include "compilo_to_asm.h"
#include "list.h"

void yyerror(char *s);
struct double_int{
    int first;
    int second;
};

%}

%union { int nb ; char *name; struct double_int *two;}
%token tMAIN tOPEN_BRKT tCLOSE_BRKT tCONST tADD tSUB tMUL tDIV tEQL tOPEN_PAR tCLOSE_PAR tCOMMA tSEMICOLON tPRINTF tINT tELSE tINF tSUP tRETURN
%token <nb> tNUM 
%token <two> tIF tWHILE
%token <name> tNAME
%type <name> ExprArit VarOrNum Condition 
%type <nb> NextIf 
%left tSUB tADD
%left tMUL tDIV
%start Program
%%

Program:  Functions tINT tMAIN {init();} tOPEN_BRKT Declare Body tCLOSE_BRKT{patch("code_assembleur"); close();}
        |  tINT tMAIN {init();} tOPEN_BRKT Declare Body tCLOSE_BRKT{ patch("code_assembleur"); close();};

Functions: Functions A_function 
        |  A_function
        ;

A_function : tINT tNAME {init_fct($2);} tOPEN_PAR Parameters tCLOSE_PAR tOPEN_BRKT Declare Body Return  tCLOSE_BRKT {patch($2);close_fct();};

Return : tRETURN ExprArit tSEMICOLON {print_return($2);};

Parameters: tINT tNAME tCOMMA Parameters {addIntParam($2);}
        | tINT tNAME {addIntParam($2);}
        | tCONST tNAME tCOMMA Parameters {addConstParam($2);}
        | tCONST tNAME {addConstParam($2);}
        ;

Declare : Ligne_Decl Declare
        |
        ;

Ligne_Decl : tCONST DeclConst
           | tINT DeclInt
           ;

DeclConst: DeclConstUniq tCOMMA DeclConst
         | DeclConstUniq tSEMICOLON
         ;

DeclConstUniq:  tNAME tEQL ExprArit {DeclConst($1,$3);};

DeclInt:   DeclEtDefInt tCOMMA DeclInt
         | DeclEtDefInt tSEMICOLON
         | tNAME tCOMMA DeclInt {checkDefInt($1);}
         | tNAME tSEMICOLON{checkDefInt($1);}
         ;


DeclEtDefInt:  tNAME tEQL ExprArit {DeclInt($1,$3);};


Body: Ligne Body
    |;


Ligne: tIF tOPEN_PAR Condition tCLOSE_PAR {$1 = malloc(sizeof(int)*2); $1->first=print_JMF($3);} tOPEN_BRKT Body tCLOSE_BRKT {$1->second = if_toPatch($1->first);} NextIf {else_toPatch($1->first,$1->second,$10);}
     | tWHILE {$1 = malloc(sizeof(int)*2); $1->second=save_while();} tOPEN_PAR Condition tCLOSE_PAR {$1->first= print_while($4);} tOPEN_BRKT Body tCLOSE_BRKT {while_toPatch($1->first, $1->second);}
     | DefInt
     | Print
     ;

NextIf: tELSE tOPEN_BRKT Body tCLOSE_BRKT {$$=1;}
        |{$$ = 0;}
        ;

Condition: ExprArit tINF ExprArit {$$ = printInf($1,$3);}
         | ExprArit tSUP ExprArit{$$ = printSup($1,$3);}
         | ExprArit tEQL ExprArit{$$ = printEql($1,$3);}
         ;

Print: tPRINTF tOPEN_PAR tNAME tCLOSE_PAR tSEMICOLON{printIt($3);}
      ;

DefInt:  tNAME tEQL ExprArit tSEMICOLON {DefInt($1,$3);};

ExprArit: VarOrNum {$$ = strdup($1); }
        | ExprArit tMUL ExprArit {$$ = strdup(multiply($1,$3));}
        | ExprArit tDIV ExprArit {$$ = strdup(divide($1,$3));}
        | ExprArit tSUB ExprArit {$$ = strdup(soustract($1,$3));}
        | ExprArit tADD ExprArit {$$ = strdup(add($1,$3));}
        | tOPEN_PAR ExprArit tCLOSE_PAR {$$ = $2;}
        ;


VarOrNum: tNAME {testVar($1);$$=$1;}
        | tNUM {$$ = affectation($1);}
        | tNAME tOPEN_PAR {init_call_fct();} Parameters_call tCLOSE_PAR {$$ = check_fct_call($1);}   
        ; 

Parameters_call:  tNAME { param_fct($1);} tCOMMA Parameters_call
                | tNAME { param_fct($1);}
                ;

%%
void yyerror(char *s) {fprintf(stderr, "%s\n", s); }
int main(void) {
  printf("========== Start compiling ==========\n");

  yyparse();
  return 0;
}