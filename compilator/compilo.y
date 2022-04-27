%{
#include "compilo_to_asm.h"
#include "list.h"

void yyerror(char *s);
struct fak{
    int first;
    int second;
};

%}

%union { int nb ; char *name; struct fak *two;}
%token tMAIN tOPEN_BRKT tCLOSE_BRKT tCONST tADD tSUB tMUL tDIV tEQL tOPEN_PAR tCLOSE_PAR tCOMMA tSEMICOLON tPRINTF tINT tELSE tINF tSUP
%token <nb> tNUM 
%token <two> tIF tWHILE
%token <name> tVARIABLE
%type <name> ExprArit VarOrNum Condition 
%type <nb> NextIf 
%left tSUB tADD
%left tMUL tDIV
%start prgm
%%

prgm: tINT tMAIN {init();} tOPEN_BRKT Declare Body tCLOSE_BRKT{/*TODO: remove print*/  patch(); close();};

Declare : Ligne_Decl Declare
        |
        ;

Ligne_Decl : tCONST DeclConst
           | tINT DeclInt
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

Print: tPRINTF tOPEN_PAR tVARIABLE tCLOSE_PAR tSEMICOLON{printIt($3);}
      ;

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