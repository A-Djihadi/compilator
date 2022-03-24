#include "list.h"

void supprlast(struct List* list){
  struct node * tmp = list->start; 
  if(list->start == NULL){ //List Vide
    return;
  }else if(list->start != NULL && list->start == list->end){ // List d'un element 
    free(list->start);
    list->start = NULL;
    list->end = NULL;
    list->addr_max--;
  }else{ // Sinon supprimer le dernier element
    while(tmp->next != list->end){ // Place le token au dernier element puis suppression
      tmp = tmp->next;
    }
    free(list->end);
    list->end = tmp;
    tmp->next = NULL;
    list->addr_max--;
  }
} 

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


void print_list(struct List *list){
  struct node * tmp = list->start;
  while(tmp != NULL){
      printf(" | %s %d %d | ->",tmp->nom,tmp->type,tmp->adresse);
      tmp=tmp->next;
	}
  printf("\n");
}

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
void insert(struct List* list, char * nom, int type){
	if(list->start==NULL){
		list->start = malloc(sizeof(struct node));
    list->start->nom = strdup(nom);
    list->start->type = type;
    list->start->adresse = list->addr_max++;
    list->start->next = NULL;
		list->end = list->start;
	}else{
    list->end->next = malloc(sizeof(struct node));
    list->end->next->nom= strdup(nom);
    list->end->next->type = type;
    list->end->next->adresse = list->addr_max++;
    list->end->next->next = NULL;
		list->end = list->end->next;
	}
}
