%{
#include "list.h"
#include "compilo_to_asm.h"

void yyerror(char *s);

%}
%union { int nb ; char *name;}
%token tMAIN tOPEN_BRKT tCLOSE_BRKT tCONST tADD tSUB tMUL tDIV tEQL tOPEN_PAR tCLOSE_PAR tCOMMA tSEMICOLON tPRINTF tINT tELSE tWHILE tINF tSUP
%token <nb> tNUM tIF
%token <name> tVARIABLE
%type <name> ExprArit VarOrNum Condition 
%left tSUB tADD
%left tMUL tDIV
%start prgm
%%

prgm: tINT tMAIN {init();} tOPEN_BRKT Body tCLOSE_BRKT{/*TODO: remove print*/  patch(); patch(); close();};

Body: Ligne Body
    |;

Ligne: tIF tOPEN_PAR Condition tCLOSE_PAR tOPEN_BRKT Body tCLOSE_BRKT tELSE tOPEN_BRKT Body tCLOSE_BRKT {printf("ifelse\n");}

     | tIF tOPEN_PAR Condition tCLOSE_PAR {$1=print_JMF($3);} tOPEN_BRKT Body tCLOSE_BRKT{to_patch($1,1);}
     | tCONST DeclConst
     | tINT DeclInt
     | DefInt
     | Print
     ;

Condition: ExprArit tINF ExprArit {$$ = printInf($1,$3);}
         | ExprArit tSUP ExprArit{$$ = printSup($1,$3);}
         | ExprArit tEQL ExprArit{$$ = printEql($1,$3);}
         ;

Print: tPRINTF tOPEN_PAR tVARIABLE tCLOSE_PAR tSEMICOLON{printIt($3);}
      ;


DeclConst: DeclConstUniq tCOMMA DeclConst
         | DeclConstUniq tSEMICOLON
         ;

DeclConstUniq:  tVARIABLE tEQL ExprArit {DeclConst($1,$3);};

DeclInt:   DeclEtDefInt tCOMMA DeclInt
         | DeclEtDefInt tSEMICOLON
         | tVARIABLE tCOMMA DeclInt {checkDefInt($1);}
         | tVARIABLE tSEMICOLON{checkDefInt($1);}
         ;


DeclEtDefInt:  tVARIABLE tEQL ExprArit {DeclInt($1,$3);};

//TODO

DefInt:  tVARIABLE tEQL ExprArit tSEMICOLON {DefInt($1,$3);};

ExprArit: VarOrNum {$$ = strdup($1);}
        | ExprArit tMUL ExprArit {$$ = strdup(multiply($1,$3));}
        | ExprArit tDIV ExprArit {$$ = strdup(divide($1,$3));}
        | ExprArit tSUB ExprArit {$$ = strdup(soustract($1,$3));}
        | ExprArit tADD ExprArit {$$ = strdup(add($1,$3));}
        | tOPEN_PAR ExprArit tCLOSE_PAR {$$ = $2;}
        ;

VarOrNum: tVARIABLE {testVar($1);$$=$1;}
        | tNUM {$$ = affectation($1);}
        ; 


%%
void yyerror(char *s) {fprintf(stderr, "%s\n", s); }
int main(void) {
  printf("COMPILATEUUUUUUR\n"); // yydebug=1;

  yyparse();
  return 0;
}