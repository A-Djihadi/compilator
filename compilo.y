%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void yyerror(char *s);

struct node{
	char  * nom; //nom variable OU valeur variable tmp
	int type; // 1 int, 2 const 
	int adresse; //stockage en mem
	struct node* next; /* taille des tableaux, nb de param des fct */
};

struct List {
	struct node* start;
	struct node* end;
  int addr_max;

} ;


//fonction : inserer liste inliste supprimerliste 
//VERIFIER AVANT QUE PAS DANS LA LISTE SINON MECHANT MONSIEUR
void supprlast(struct List* list,char* nom){
  struct node * tmp = list->start; 
  if(list->start == NULL){
    return;
  }else if(list->start != NULL && list->start == list->end){
    free(list->start);
    list->start = NULL;
    list->end = NULL;
  }else{
    while(tmp->next != list->end){
      tmp = tmp->next;
    }
    free(list->end);
    list->end = tmp;
    tmp->next = NULL;
  }
}
//CLEAR LIST
void clearlist(struct List* list){
  struct node * tmp = list->start;
  if(tmp != NULL){
    while(tmp->next != list->end){
      tmp = tmp->next;
      free(list->start);
      list->start=tmp;
    }
    free(list->end);
    list->start = NULL;
    list->end = NULL;
  }
  
}

//Show list

void print_list(struct List *list){
  struct node * tmp = list->start;
  while(tmp != NULL){
      printf(" | %s %d %d | ->",tmp->nom,tmp->type,tmp->adresse);
      tmp=tmp->next;
	}
  printf("\n");
}

//0 not found, 1 it's an int, 2 it's a const
int inlist(struct List list,char * nom,int* adress){
	struct node * tmp = list.start;
	while(tmp != NULL){
		if(strcmp(tmp->nom,nom)==0){
      *adress = tmp->adresse;
			return tmp->type;
		}else{
			tmp= tmp->next;
		}
	}
	return 0;
}


//VERIFIER AVANT QUE PAS DANS LA LISTE SINON MECHANT MONSIEUR
void insert(struct List* list, char * nom, int type, int adresse){
	if(list->start==NULL){
		list->start = malloc(sizeof(struct node));
    list->start->nom = strdup(nom);
    list->start->type = type;
    list->start->adresse = adresse;
    list->start->next = NULL;
		list->end = list->start;
	}else{
    list->end->next = malloc(sizeof(struct node));
    list->end->next->nom= strdup(nom);
    list->end->next->type = type;
    list->end->next->adresse = adresse;
    list->end->next->next = NULL;
		list->end = list->end->next;
	}
}

struct List notre_list;


%}
%union { int nb ; char *var;}
%token tMAIN tOPEN_BRKT tCLOSE_BRKT tCONST tADD tSUB tMUL tDIV tEQL tOPEN_PAR tCLOSE_PAR tCOMMA tSEMICOLON tPRINTF tINT
%token <nb> tNUM
%token <var> tVARIABLE
%start prgm
%%

prgm: tINT tMAIN {notre_list.addr_max= 0;} tOPEN_BRKT Expr tCLOSE_BRKT {print_list(&notre_list);};

Expr : tCONST DeclConst
    | tINT DeclInt  
    | tVARIABLE tEQL ExprArit tSEMICOLON
    | tPRINTF tOPEN_PAR tVARIABLE tCLOSE_PAR tSEMICOLON
    | Expr Expr
    |
    ;

DeclConst : tVARIABLE tEQL tNUM tCOMMA 
{   //TEST SI VARIABLE DEJA DECLARE
    int adress;
    if(inlist(notre_list,$1,&adress)==0){      
      insert(&notre_list,$1,2,notre_list.addr_max);
      notre_list.addr_max++;
      printf("%s\n",$1); 
      //CODE ASM

    }else{
      printf("déja déclarée \n");}} 
  DeclConst 

          | tVARIABLE tEQL tNUM tSEMICOLON
{   //TEST SI VARIABLE DEJA DECLARE
    int adress;
    if(inlist(notre_list,$1,&adress)==0){
      insert(&notre_list,$1,2,notre_list.addr_max);
      notre_list.addr_max++;
      printf("%s\n",$1); 
      //CODE ASM
    }else{
      printf("déja déclarée \n");}} 
          ; 

DeclInt   : tVARIABLE tEQL tNUM tCOMMA DeclInt 
          | tVARIABLE tEQL tNUM tSEMICOLON
          | tVARIABLE tCOMMA DeclInt 
          | tVARIABLE tSEMICOLON
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