%{
#include "list.h"

#define TAILLE_MAX_INT 10
void yyerror(char *s);
int cmptVariableTmp=0;

// table des signes
struct List notre_list;
// fichier de sortie en assembleur
FILE* fichier = NULL;


%}
%union { int nb ; char *var;}
%token tMAIN tOPEN_BRKT tCLOSE_BRKT tCONST tADD tSUB tMUL tDIV tEQL tOPEN_PAR tCLOSE_PAR tCOMMA tSEMICOLON tPRINTF tINT tIF tELSE tWHILE
%token <nb> tNUM
%token <var> tVARIABLE
%type <var> ExprArit VarOrNum
%left tSUB tADD
%left tMUL tDIV
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
Ligne: tIF tOPEN_PAR Condition tCLOSE_PAR tOPEN_BRKT Body tCLOSE_BRKT  
     | tIF tOPEN_PAR Condition tCLOSE_PAR tOPEN_BRKT Body tCLOSE_BRKT tELSE tOPEN_BRKT Body tCLOSE_BRKT
     | tCONST DeclConst
     | tINT DeclInt
     | DefInt
     | Print
     ;

Condition:;

Print: tPRINTF tOPEN_PAR tVARIABLE tCLOSE_PAR tSEMICOLON{
        int test,adress;
        if((test = inlist(notre_list,$3,&adress)) == 0){      
          printf("Variable does not exist\n");
        }
        fprintf(fichier,"PRI %d\n", adress);
      }
      ;


DeclConst:   DeclConstUniq tCOMMA DeclConst
         | DeclConstUniq tSEMICOLON
         ;

DeclConstUniq:  tVARIABLE {
                int test,adress;
                if((test = inlist(notre_list,$1,&adress)) == 0){      
                insert(&notre_list,$1,2);
                // insert in the list with adress being the max adress

                }else{
                printf("Aleardy declared const\n");
                //throw
                }   
              } tEQL ExprArit 
            { //TEST SI VARIABLE DECLAREE
              int test,adress, adressoperand;
              //recuperer adress
              inlist(notre_list,$1,&adress);
              if((test = inlist(notre_list,$4,&adressoperand)) == 0){   
                printf("Not supposed to happen\n");
              }else if(test == 3){
                //remove tmp from list
                supprlast(&notre_list);
                cmptVariableTmp--;
              }

              fprintf(fichier,"COP %d %d\n", adress, adressoperand);
              
            }
          ;

DeclInt:   DeclEtDefInt tCOMMA DeclInt
         | DeclEtDefInt tSEMICOLON
         | tVARIABLE tCOMMA DeclInt
           { //TEST SI VARIABLE DECLAREE
              int adress;
              if(inlist(notre_list,$1,&adress) == 0){      
                insert(&notre_list,$1,4);
              }else{
                printf("already declared\n");
              }
            };
         | tVARIABLE tSEMICOLON
           { //TEST SI VARIABLE DECLAREE
              int adress;
              if(inlist(notre_list,$1,&adress) == 0){      
                insert(&notre_list,$1,4);
              }else{
                printf("already declared\n");
              }
            };
         ;


DeclEtDefInt:  tVARIABLE {
                int test,adress;
                if((test = inlist(notre_list,$1,&adress)) == 0){      
                  insert(&notre_list,$1,1);
                  // insert in the list with adress being the max adress
                  adress = notre_list.addr_max - 1;
                }
              } 
            tEQL ExprArit 
            { //TEST SI VARIABLE DECLAREE
              int adressoperand,test,adress;
              inlist(notre_list,$1,&adress);

              if((test = inlist(notre_list,$4,&adressoperand)) == 0){      
                printf("Not supposed to happen\n");
              }else if(test == 3){
                //remove tmp from list
                supprlast(&notre_list);
                cmptVariableTmp--;
              }
              fprintf(fichier,"COP %d %d\n", adress, adressoperand);
            }
          ;

DefInt:  tVARIABLE tEQL ExprArit tSEMICOLON
          { //TEST SI VARIABLE DECLAREE

            int adressoperand,test,adress;
            if((test = inlist(notre_list,$3,&adressoperand)) == 0){      
              printf("Not supposed to happen\n");
            }else if(test == 3){
              //remove tmp from list
              supprlast(&notre_list);
             cmptVariableTmp--;
            }

            if((test = inlist(notre_list,$1,&adress)) == 0){      
              // errore not supposed to happen
              printf("Not declared int\n");
            }else if(test == 2){
              // errore not supposed to happen
              printf("Variable declared as const, cannot be changed\n");
            }
          fprintf(fichier,"COP %d %d\n", adress, adressoperand);
          }
      ;

ExprArit: VarOrNum {$$ = strdup($1);}
        | ExprArit tMUL ExprArit {
          int adressoperand1,adressoperand2,adress_result,test;
          if((test = inlist(notre_list,$3,&adressoperand2)) == 0){      
            printf("Not supposed to happen\n");
          }else if(test == 3){
            //remove tmp from list
            supprlast(&notre_list);
            cmptVariableTmp--;
          }

          if((test = inlist(notre_list,$1,&adressoperand1)) == 0){      
            printf("Not supposed to happen\n");
          }else if(test == 3){
            //remove tmp from list
            supprlast(&notre_list);
            cmptVariableTmp--;
          }
          //add tmp to list
          char nom[TAILLE_MAX_INT+4]; 
          cmptVariableTmp++; 
          sprintf(nom, "%dTemp", cmptVariableTmp);

          insert(&notre_list,nom,3);
          adress_result = notre_list.addr_max - 1;
          fprintf(fichier,"MUL %d %d %d\n",adress_result, adressoperand1, adressoperand2);
          $$ = strdup(nom);
        }

        | ExprArit tDIV ExprArit {
          int adressoperand1,adressoperand2,adress_result,test;
          if((test = inlist(notre_list,$3,&adressoperand2)) == 0){      
            printf("Not supposed to happen\n");
          }else if(test == 3){
            //remove tmp from list
            supprlast(&notre_list);
            cmptVariableTmp--;
          }

          if((test = inlist(notre_list,$1,&adressoperand1)) == 0){      
            printf("Not supposed to happen\n");
          }else if(test == 3){
            //remove tmp from list
            supprlast(&notre_list);
            cmptVariableTmp--;
          }
          //add tmp to list
          char nom[TAILLE_MAX_INT+4]; 
          cmptVariableTmp++; 
          sprintf(nom, "%dTemp", cmptVariableTmp);
          insert(&notre_list,nom,3);
          adress_result = notre_list.addr_max - 1;
          fprintf(fichier,"DIV %d %d %d\n",adress_result, adressoperand1, adressoperand2);
          $$ = strdup(nom);
        }

        | ExprArit tSUB ExprArit {
          int adressoperand1,adressoperand2,adress_result,test;
          if((test = inlist(notre_list,$3,&adressoperand2)) == 0){      
            printf("Not supposed to happen\n");
          }else if(test == 3){
            //remove tmp from list
            supprlast(&notre_list);
            cmptVariableTmp--;
          }

          if((test = inlist(notre_list,$1,&adressoperand1)) == 0){      
            printf("Not supposed to happen\n");
          }else if(test == 3){
            //remove tmp from list
            supprlast(&notre_list);
            cmptVariableTmp--;
          }
          //add tmp to list
          char nom[TAILLE_MAX_INT+4]; 
          cmptVariableTmp++; 
          sprintf(nom, "%dTemp", cmptVariableTmp);
          insert(&notre_list,nom,3);
          adress_result = notre_list.addr_max - 1;
          fprintf(fichier,"SOU %d %d %d\n",adress_result, adressoperand1, adressoperand2);
          $$ = strdup(nom);
        }

        | ExprArit tADD ExprArit {
          int adressoperand1,adressoperand2,adress_result,test;
          if((test = inlist(notre_list,$3,&adressoperand2)) == 0){      
            printf("Not supposed to happen\n");
          }else if(test == 3){
            //remove tmp from list
            supprlast(&notre_list);
            cmptVariableTmp--;
          }

          if((test = inlist(notre_list,$1,&adressoperand1)) == 0){      
            printf("Not supposed to happen\n");
          }else if(test == 3){
            //remove tmp from list
            supprlast(&notre_list);
            cmptVariableTmp--;
          }
          //add tmp to list
          char nom[TAILLE_MAX_INT+4];
          cmptVariableTmp++; 
          sprintf(nom, "%dTemp", cmptVariableTmp);
          insert(&notre_list,nom,3);
          adress_result = notre_list.addr_max - 1;
          fprintf(fichier,"ADD %d %d %d\n",adress_result, adressoperand1, adressoperand2);
          $$ = strdup(nom);
        }
        | tOPEN_PAR ExprArit tCLOSE_PAR 
        {$$ = $2;}
        ;

VarOrNum: tVARIABLE {
          int adress,test; 
          if((test = inlist(notre_list,$1,&adress)) == 0){      
            printf("Not declared variable\n");
          }else if(test == 4){
            printf("Integer not instanciated\n");
          }
            //TODO: verif malloc?
            $$=$1;
          }
        | tNUM { 
            char nom[TAILLE_MAX_INT+4]; 
            int adress;
            cmptVariableTmp++; 
            sprintf(nom, "%dTemp", cmptVariableTmp);
            insert(&notre_list,nom,3);
            adress = notre_list.addr_max - 1;
            fprintf(fichier,"AFC %d %d\n",adress, $1);
            $$ = nom;
          }
        ; 


%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); }
int main(void) {
  printf("COMPILATEUUUUUUR\n"); // yydebug=1;

  yyparse();
  return 0;
}