%{
#include "list.h"

void yyerror(char *s);

// table des signes
struct List notre_list;
// fichier de sortie en assembleur
FILE* fichier = NULL;


%}
%union { int nb ; char *var;}
%token tMAIN tOPEN_BRKT tCLOSE_BRKT tCONST tADD tSUB tMUL tDIV tEQL tOPEN_PAR tCLOSE_PAR tCOMMA tSEMICOLON tPRINTF tINT
%token <nb> tNUM
%token <var> tVARIABLE
%start prgm
%%

prgm: tINT tMAIN 
        { fichier = fopen("compilateur_asm.txt", "w");
          notre_list.addr_max= 0;
        } 
      tOPEN_BRKT Body tCLOSE_BRKT
        { print_list(&notre_list);
          fclose(fichier);
        }
    ;

Body: Ligne Body
    |
    ;
Ligne: tCONST DeclConst
     | tINT DeclInt
     | DefInt
     | Print
     ;

Print: tPRINTF tOPEN_PAR tVARIABLE tCLOSE_PAR tSEMICOLON;


DeclConst:   DeclConstUniq tCOMMA DeclConst
         | DeclConstUniq tSEMICOLON
         ;

DeclConstUniq:  tVARIABLE tEQL ExprArit 
            { //TEST SI VARIABLE DECLAREE
              int adress,test;
              if((test = inlist(notre_list,$1,&adress)) == 0){      
                insert(&notre_list,$1,2);
                // insert in the list with adress being the max adress
                adress = notre_list.addr_max - 1;
                 /* Assembleur: 
                recuperer la val de ExprArit,
                la mettre à l'adresse "adress"
                */
              }else{
                printf("Aleardy declared const\n");
              }
             
            }
          ;

DeclInt:   DeclEtDefInt tCOMMA DeclInt
         | DeclEtDefInt tSEMICOLON
         | tVARIABLE tCOMMA DeclInt
           { //TEST SI VARIABLE DECLAREE
              int adress;
              if(inlist(notre_list,$1,&adress) == 0){      
                insert(&notre_list,$1,1);
              }
            };
         | tVARIABLE tSEMICOLON
           { //TEST SI VARIABLE DECLAREE
              int adress;
              if(inlist(notre_list,$1,&adress) == 0){      
                insert(&notre_list,$1,1);
              }
            };
         ;


DeclEtDefInt:  tVARIABLE tEQL ExprArit 
            { //TEST SI VARIABLE DECLAREE
              int adress,test;
              if((test = inlist(notre_list,$1,&adress)) == 0){      
                insert(&notre_list,$1,1);
                // insert in the list with adress being the max adress
                adress = notre_list.addr_max - 1;
              }
              /* Assembleur: 
                recuperer la val de ExprArit,
                la mettre à l'adresse "adress"
              */
            }
          ;

DefInt:  tVARIABLE tEQL ExprArit tSEMICOLON
          { //TEST SI VARIABLE DECLAREE
            int adress,test;
            if((test = inlist(notre_list,$1,&adress)) == 0){      
              // errore not supposed to happen
              printf("Not declared int\n");
            }else if(test == 2){
              // errore not supposed to happen
              printf("Variable declared as const, cannot be changed\n");
            }else{
              /* Assembleur: 
              recuperer la val de ExprArit,
              la mettre à l'adresse "adress"
              */
            }
            
          }
      ;

ExprArit: VarOrNum;
        | VarOrNum tMUL ExprArit
        | VarOrNum tDIV ExprArit
        | VarOrNum tSUB ExprArit
        | VarOrNum tADD ExprArit
        | tOPEN_PAR ExprArit tCLOSE_PAR 
        ;
VarOrNum: tVARIABLE 
        | tNUM
        ; 


%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); }
int main(void) {
  printf("COMPILATEUUUUUUR\n"); // yydebug=1;

  yyparse();
  return 0;
}