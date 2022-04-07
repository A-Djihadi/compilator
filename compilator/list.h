#ifndef LIST_H
#define LIST_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

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

/*removes the last element of the list  
  /!\ should not be called on an empty list*/
void supprlast(struct List* list);

// clears the list and empties the memory
void clearlist(struct List* list);

// prints the list in the format [ element ] ->
void print_list(struct List *list);

/* checks if an element is in the list:
  returns 0 not found, 1 it's an int, 2 it's a const
  3 is temporary variables 4 int without value 
  and sets adress to the saved adress*/
int inlist(struct List list,char * nom,int* adress);


//VERIFIER AVANT QUE PAS DANS LA LISTE SINON MECHANT MONSIEUR
void insert(struct List* list, char * nom, int type);
#endif
