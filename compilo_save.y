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
      tOPEN_BRKT Expr tCLOSE_BRKT
        { print_list(&notre_list);
          fclose(fichier);
        }
      ;

Expr : tCONST DeclConst
    | tINT DeclInt  
    | tVARIABLE tEQL ExprArit tSEMICOLON
    | tPRINTF tOPEN_PAR tVARIABLE tCLOSE_PAR tSEMICOLON
    | Expr Expr
    |
    ;

DeclConst : tVARIABLE tEQL tNUM tCOMMA 
            { //TEST SI VARIABLE DEJA DECLARE
              int adress;
              if(inlist(notre_list,$1,&adress)==0){      
                insert(&notre_list,$1,2);
                printf("%s\n",$1); 
              }else{
                printf("déja déclarée \n");
              }
                              /* CODE ASM:
                fprintf(fichier,"variable ajoutée %s",$1);

                */

            } 
            DeclConst 

          | tVARIABLE tEQL tNUM tSEMICOLON
            { //TEST SI VARIABLE DEJA DECLARE
              int adress;
              if(inlist(notre_list,$1,&adress)==0){
                insert(&notre_list,$1,2);
                printf("%s\n",$1); 
                //CODE ASM
                fprintf(fichier,"variable ajoutée %s",$1);
              }else{
                printf("déja déclarée \n");
              }
            } 
          ; 

DeclInt   : tVARIABLE tEQL tNUM tCOMMA 
              {   //TEST SI VARIABLE DEJA DECLARE
                  int adress;
                  if(inlist(notre_list,$1,&adress)==0){
                    insert(&notre_list,$1,1);
                    printf("%s\n",$1); 
                    //CODE ASM
                    fprintf(fichier,"variable ajoutée %s",$1);
                  }else{
                    printf("déja déclarée \n");}}

            DeclInt 

          | tVARIABLE tEQL tNUM tSEMICOLON
            { //TEST SI VARIABLE DEJA DECLARE
              int adress;
              if(inlist(notre_list,$1,&adress)==0){
                insert(&notre_list,$1,1);
                printf("%s\n",$1); 
                //CODE ASM
                fprintf(fichier,"variable ajoutée %s",$1);
              }else{
                printf("déja déclarée \n");
              }
            } 

          | tVARIABLE tCOMMA 
            { //TEST SI VARIABLE DEJA DECLARE
              int adress;
              if(inlist(notre_list,$1,&adress)==0){
                insert(&notre_list,$1,1);
                printf("%s\n",$1); 
                //CODE ASM
                fprintf(fichier,"variable ajoutée %s",$1);
              }else{
                printf("déja déclarée \n");
              }
            } 
            DeclInt 

          | tVARIABLE tSEMICOLON
            {//TEST SI VARIABLE DEJA DECLARE
              int adress;
              if(inlist(notre_list,$1,&adress)==0){
                insert(&notre_list,$1,1);
                printf("%s\n",$1); 
                //CODE ASM
                fprintf(fichier,"variable ajoutée %s",$1);
              }else{
                printf("déja déclarée \n");
              }
            } 
          ; 

operateur : tADD 
          |tSUB 
          | tMUL 
          | tDIV
          ;

ExprArit  : tVARIABLE 
          | tNUM 
          | tOPEN_PAR ExprArit tCLOSE_PAR 
          | ExprArit operateur ExprArit
          ;

%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); }
int main(void) {
  printf("COMPILATEUUUUUUR\n"); // yydebug=1;

  yyparse();
  return 0;
}